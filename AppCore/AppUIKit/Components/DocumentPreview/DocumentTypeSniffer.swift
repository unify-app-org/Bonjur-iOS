//
//  DocumentTypeSniffer.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 22.08.26.
//

import Foundation
import UniformTypeIdentifiers

/// Works out a document's file extension. Attachments come back from the API
/// with a display name that often has **no extension** (e.g. `abbCardApproved`)
/// and a URL that has none either, and previewers key off the extension — so we
/// fall back to the response MIME type and finally to the file's magic bytes.
public enum DocumentTypeSniffer {

    /// Office containers put their marker entries early; 1 MB is plenty.
    private static let officeScanLimit = 1_048_576

    /// Extension without the dot, or nil when nothing recognises the file.
    ///
    /// The bytes are asked first on purpose: a name like `report.2026.final`
    /// ends in something that *looks* like an extension but isn't, while the
    /// header of a PDF is never wrong. The name is the last resort, and covers
    /// the text formats that have no magic number (txt/csv/json).
    public static func fileExtension(
        name: String,
        url: URL,
        mimeType: String?,
        fileURL: URL?
    ) -> String? {
        if let fileURL, let fromBytes = extensionFromMagicBytes(at: fileURL) {
            return fromBytes
        }
        if let fromMime = extensionFromMimeType(mimeType) {
            return fromMime
        }
        if let fromName = usableExtension((name as NSString).pathExtension) {
            return fromName
        }
        if let fromURL = usableExtension(url.pathExtension) {
            return fromURL
        }
        // Dead last: a text payload has no signature, so "this decodes as text"
        // is a guess. It must not outrank a specific name like `notes.csv`.
        return fileURL.flatMap(textExtension)
    }

    /// Type resolved from the file's own bytes alone. Used to re-identify a
    /// document that was already cached under a name with no extension.
    public static func fileExtensionFromContents(of fileURL: URL) -> String? {
        extensionFromMagicBytes(at: fileURL) ?? textExtension(at: fileURL)
    }

    /// Whether a path already carries an extension worth trusting.
    public static func hasUsableExtension(_ name: String) -> Bool {
        usableExtension((name as NSString).pathExtension) != nil
    }

    /// Rejects junk that can't be an extension at all — punctuation, digits
    /// only, or a segment far too long to be one.
    private static func usableExtension(_ candidate: String) -> String? {
        let value = candidate.lowercased()
        guard !value.isEmpty, value.count <= 5,
              value.allSatisfy({ $0.isLetter || $0.isNumber }),
              value.contains(where: { $0.isLetter }) else {
            return nil
        }
        return value
    }

    private static func extensionFromMimeType(_ mimeType: String?) -> String? {
        guard let mimeType else { return nil }
        let cleaned = mimeType
            .components(separatedBy: ";")[0]
            .trimmingCharacters(in: .whitespaces)
            .lowercased()
        // MinIO serves anything it can't classify as octet-stream, which tells
        // us nothing — only the magic bytes can.
        guard !cleaned.isEmpty, cleaned != "application/octet-stream" else { return nil }
        return UTType(mimeType: cleaned)?.preferredFilenameExtension
    }

    private static func extensionFromMagicBytes(at fileURL: URL) -> String? {
        guard let handle = try? FileHandle(forReadingFrom: fileURL) else { return nil }
        defer { try? handle.close() }
        guard let header = try? handle.read(upToCount: 16), header.count >= 4 else { return nil }
        let bytes = [UInt8](header)

        if bytes.starts(with: [0x25, 0x50, 0x44, 0x46]) { return "pdf" }                    // %PDF
        if bytes.starts(with: [0x89, 0x50, 0x4E, 0x47]) { return "png" }
        if bytes.starts(with: [0xFF, 0xD8, 0xFF]) { return "jpg" }
        if bytes.starts(with: [0x47, 0x49, 0x46, 0x38]) { return "gif" }                    // GIF8
        if bytes.starts(with: [0x52, 0x49, 0x46, 0x46]), bytes.count >= 12,
           Array(bytes[8..<12]) == [0x57, 0x45, 0x42, 0x50] { return "webp" }               // RIFF….WEBP
        if bytes.starts(with: [0x42, 0x4D]) { return "bmp" }
        if bytes.starts(with: [0xD0, 0xCF, 0x11, 0xE0]) { return "doc" }                    // legacy OLE
        if bytes.starts(with: [0x7B, 0x5C, 0x72, 0x74, 0x66]) { return "rtf" }              // {\rtf
        if bytes.starts(with: [0x37, 0x7A, 0xBC, 0xAF]) { return "7z" }
        if bytes.starts(with: [0x52, 0x61, 0x72, 0x21]) { return "rar" }
        if bytes.starts(with: [0x50, 0x4B, 0x03, 0x04]) { return officeExtension(at: fileURL) }
        // ISO base media: the brand at offset 8 says heic / avif / mp4 / mov.
        if bytes.count >= 12, Array(bytes[4..<8]) == [0x66, 0x74, 0x79, 0x70] {             // ftyp
            return isoBaseMediaExtension(brand: Array(bytes[8..<12]))
        }
        return nil
    }

    private static func isoBaseMediaExtension(brand: [UInt8]) -> String? {
        let code = String(bytes: brand, encoding: .isoLatin1)?.lowercased() ?? ""
        switch code {
        case "heic", "heix", "hevc", "heim", "heis": return "heic"
        case "mif1", "msf1": return "heif"
        case "avif", "avis": return "avif"
        case "qt  ": return "mov"
        default: return "mp4"
        }
    }

    /// Sniffs plain-text payloads (XML/SVG/HTML/JSON/CSV/log). A file is text
    /// when a leading sample decodes as UTF-8 and holds no NUL bytes.
    private static func textExtension(at fileURL: URL) -> String? {
        guard let handle = try? FileHandle(forReadingFrom: fileURL) else { return nil }
        defer { try? handle.close() }
        guard let sample = try? handle.read(upToCount: 2048), !sample.isEmpty,
              !sample.contains(0x00),
              let text = String(data: sample, encoding: .utf8) else { return nil }

        let head = text.trimmingCharacters(in: .whitespacesAndNewlines).prefix(512).lowercased()
        if head.hasPrefix("<svg") || head.contains("<svg ") { return "svg" }
        if head.hasPrefix("<!doctype html") || head.hasPrefix("<html") { return "html" }
        if head.hasPrefix("<?xml") { return "xml" }
        if head.hasPrefix("{") || head.hasPrefix("[") { return "json" }
        return "txt"
    }

    /// docx/xlsx/pptx are all zips; the entry names say which. Zip stores every
    /// entry name uncompressed in its local header, so scanning the raw bytes
    /// finds them without unpacking anything.
    private static func officeExtension(at fileURL: URL) -> String {
        guard let handle = try? FileHandle(forReadingFrom: fileURL) else { return "zip" }
        defer { try? handle.close() }
        guard let chunk = try? handle.read(upToCount: officeScanLimit),
              let text = String(data: chunk, encoding: .isoLatin1) else { return "zip" }

        if text.contains("word/") { return "docx" }
        if text.contains("xl/") { return "xlsx" }
        if text.contains("ppt/") { return "pptx" }
        return "zip"
    }
}
