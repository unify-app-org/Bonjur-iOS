//
//  DocumentPreviewView.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 22.08.26.
//

import SwiftUI
import QuickLook
import UIKit
import AppLocalization

/// Full-screen in-app document preview: downloads the file first, then renders
/// the local copy with QuickLook (PDF, Office, images, text all handled).
public struct DocumentPreviewView: View {

    public struct Item: Identifiable, Equatable {
        public var id: String { url.absoluteString }
        public let url: URL
        public let name: String

        public init(url: URL, name: String) {
            self.url = url
            self.name = name
        }
    }

    private enum LoadState: Equatable {
        case loading
        case ready(URL)
        case failed
    }

    private let item: Item
    private let onClose: () -> Void

    @State private var state: LoadState = .loading
    @State private var shareItem: ShareItem?

    public init(item: Item, onClose: @escaping () -> Void) {
        self.item = item
        self.onClose = onClose
    }

    public var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
                .foregroundStyle(Color.Palette.grayTeritary)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.Palette.white)
        .task(id: item.id) {
            await load()
        }
        .sheet(item: $shareItem) { share in
            DocumentShareSheet(url: share.url)
        }
    }

    /// The downloaded copy, once there is one — sharing has nothing to offer
    /// while the document is still loading or failed.
    private var readyFileURL: URL? {
        if case .ready(let fileURL) = state { return fileURL }
        return nil
    }

    private var header: some View {
        HStack(spacing: 12) {
            Button(action: onClose) {
                Image(uiImage: UIImage.Icons.xmark)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.Palette.grayQuaternary)
                    )
            }
            Text(item.name)
                .font(Font.Typography.BodyTextSm.medium)
                .foregroundStyle(Color.Palette.blackHigh)
                .lineLimit(1)
                .truncationMode(.middle)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let readyFileURL {
                Button {
                    shareItem = ShareItem(url: readyFileURL)
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.Palette.blackHigh)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.Palette.grayQuaternary)
                        )
                }
                .accessibilityLabel("document_preview_share".localized)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .loading:
            VStack(spacing: 12) {
                ProgressView()
                Text("document_preview_loading".localized)
                    .font(Font.Typography.TextMd.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
            }

        case .ready(let fileURL):
            QuickLookPreview(url: fileURL)
                .ignoresSafeArea(edges: .bottom)

        case .failed:
            VStack(spacing: 16) {
                Text("document_preview_failed".localized)
                    .font(Font.Typography.BodyTextSm.medium)
                    .foregroundStyle(Color.Palette.blackHigh)
                    .multilineTextAlignment(.center)
                Button("document_preview_retry".localized) {
                    Task { await load() }
                }
                .font(Font.Typography.BodyTextSm.medium)
                .foregroundStyle(Color.Palette.blackHigh)
            }
            .padding(.horizontal, 32)
        }
    }

    private func load() async {
        state = .loading
        do {
            let fileURL = try await DocumentFileLoader.shared.localFile(
                for: item.url,
                preferredName: item.name
            )
            state = .ready(fileURL)
        } catch {
            state = .failed
        }
    }
}

// MARK: - QuickLook bridge

private struct QuickLookPreview: UIViewControllerRepresentable {

    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: QLPreviewController, context: Context) {
        guard context.coordinator.url != url else { return }
        context.coordinator.url = url
        controller.reloadData()
    }

    final class Coordinator: NSObject, QLPreviewControllerDataSource {

        var url: URL

        init(url: URL) {
            self.url = url
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

        func previewController(
            _ controller: QLPreviewController,
            previewItemAt index: Int
        ) -> QLPreviewItem {
            url as NSURL
        }
    }
}

// MARK: - Share sheet

private struct ShareItem: Identifiable {
    var id: String { url.absoluteString }
    let url: URL
}

private struct DocumentShareSheet: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) { }
}

// MARK: - Presentation

public extension View {

    /// Presents the in-app document preview for `item`, clearing it on close.
    func documentPreview(item: Binding<DocumentPreviewView.Item?>) -> some View {
        fullScreenCover(item: item) { previewItem in
            DocumentPreviewView(item: previewItem) {
                item.wrappedValue = nil
            }
        }
    }
}
