//
//  DocumentFileLoader.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 22.08.26.
//

import Foundation
import CryptoKit

public enum DocumentLoadError: Error {
    /// The server answered with a non-2xx status, or the transfer failed.
    case download
}

/// Fetches a remote document into the caches directory and hands back a local
/// file URL. Previews need a file on disk (QuickLook cannot render a remote
/// URL), and downloading here is what keeps the document inside the app instead
/// of bouncing the user out to Safari.
///
/// Re-opening the same document is served straight off disk, and two taps on
/// the same row share a single download.
public actor DocumentFileLoader {

    public static let shared = DocumentFileLoader()

    private let session: URLSession
    private var inFlight: [URL: Task<URL, Error>] = [:]

    private lazy var rootFolder: URL = {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let folder = caches.appendingPathComponent("DocumentPreview", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder
    }()

    public init(session: URLSession = .shared) {
        self.session = session
    }

    /// Local copy of `remoteURL`, downloading it first if it isn't cached yet.
    /// - Parameter preferredName: the attachment's display name. The API often
    ///   sends it **without an extension**, so the real type is resolved from the
    ///   response and the file's magic bytes — QuickLook picks its renderer off
    ///   the extension, and a file without one previews as unreadable "data".
    public func localFile(for remoteURL: URL, preferredName: String) async throws -> URL {
        let folder = cacheFolder(for: remoteURL)
        if let cached = cachedFile(in: folder) {
            return cached
        }
        if let running = inFlight[remoteURL] {
            return try await running.value
        }

        let session = session
        let task = Task<URL, Error> {
            let (temporaryURL, response) = try await session.download(from: remoteURL)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                try? FileManager.default.removeItem(at: temporaryURL)
                throw DocumentLoadError.download
            }

            let fileName = Self.fileName(
                preferredName: preferredName,
                remoteURL: remoteURL,
                mimeType: http.mimeType,
                downloadedFile: temporaryURL
            )
            let destination = folder.appendingPathComponent(fileName)
            try? FileManager.default.removeItem(at: destination)
            try FileManager.default.moveItem(at: temporaryURL, to: destination)
            return destination
        }
        inFlight[remoteURL] = task
        defer { inFlight[remoteURL] = nil }
        return try await task.value
    }

    /// Each document gets its own hashed folder so two files that share a name
    /// don't overwrite each other. The folder holds exactly one file, which is
    /// also how a cache hit is found without knowing the extension up front.
    private func cacheFolder(for remoteURL: URL) -> URL {
        let digest = SHA256.hash(data: Data(remoteURL.absoluteString.utf8))
            .map { String(format: "%02x", $0) }
            .joined()
            .prefix(16)
        let folder = rootFolder.appendingPathComponent(String(digest), isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder
    }

    private func cachedFile(in folder: URL) -> URL? {
        let contents = (try? FileManager.default.contentsOfDirectory(
            at: folder,
            includingPropertiesForKeys: [.fileSizeKey]
        )) ?? []
        let existing = contents.first {
            ((try? $0.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0) > 0
        }
        return existing.map(Self.repairingExtension)
    }

    /// A file cached before the type was ever sniffed sits on disk under a name
    /// with no extension, and would keep previewing as unreadable "data"
    /// forever. Re-identify it from its own bytes and rename in place — no
    /// second download, and the next tap is already correct.
    private static func repairingExtension(_ fileURL: URL) -> URL {
        guard !DocumentTypeSniffer.hasUsableExtension(fileURL.lastPathComponent),
              let resolved = DocumentTypeSniffer.fileExtensionFromContents(of: fileURL) else {
            return fileURL
        }
        let repaired = fileURL.deletingLastPathComponent()
            .appendingPathComponent("\(fileURL.lastPathComponent).\(resolved)")
        do {
            try? FileManager.default.removeItem(at: repaired)
            try FileManager.default.moveItem(at: fileURL, to: repaired)
            return repaired
        } catch {
            return fileURL
        }
    }

    /// Display name plus a resolved extension. Keeping the server name matters
    /// for the preview title; the extension is what makes it render.
    private static func fileName(
        preferredName: String,
        remoteURL: URL,
        mimeType: String?,
        downloadedFile: URL
    ) -> String {
        var base = preferredName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "/", with: "_")
        if base.isEmpty {
            base = remoteURL.lastPathComponent
        }
        if base.isEmpty {
            base = "document"
        }

        let resolved = DocumentTypeSniffer.fileExtension(
            name: preferredName,
            url: remoteURL,
            mimeType: mimeType,
            fileURL: downloadedFile
        )
        guard let resolved else { return base }

        if (base as NSString).pathExtension.lowercased() == resolved {
            return base
        }
        return "\(base).\(resolved)"
    }
}
