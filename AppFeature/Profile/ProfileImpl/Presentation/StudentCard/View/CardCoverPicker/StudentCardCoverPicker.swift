//
//  StudentCardCoverPicker.swift
//  ProfileImpl
//
//  Created by aplle on 3/5/26.
//

import SwiftUI
import AppUIKit

struct StudentCardCoverPicker: View {

    let covers = StudentCardViewState.availableCovers

    @Binding var selected: AppUIEntities.BackgroundType?
    @State private var hasCompletedInitialPositioning = false
    @State private var isTapSelectionInProgress = false

    var body: some View {
        GeometryReader { outer in
            scrollableCovers(in: outer)
        }
    }

    private func scrollableCovers(in outer: GeometryProxy) -> some View {
        ScrollViewReader { proxy in
            coversScrollView(outer: outer, proxy: proxy)
                .onAppear {
                    alignInitialSelection(with: proxy)
                }
        }
    }

    private func coversScrollView(outer: GeometryProxy, proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Array(covers.enumerated()), id: \.offset) { index, cover in
                    coverCell(cover: cover, index: index, outer: outer, proxy: proxy)
                }
            }
            .padding(.horizontal, outer.size.width / 2 - 70)
        }
    }

    private func coverCell(
        cover: AppUIEntities.BackgroundType?,
        index: Int,
        outer: GeometryProxy,
        proxy: ScrollViewProxy
    ) -> some View {
        CoverItemView(
            cover: cover,
            isSelected: compareCovers(cover, selected),
            width: outer.size.width / 2.8
        )
        .id(index)
        .background(
            GeometryReader { geo in
                selectionObserver(geo: geo, outer: outer, cover: cover)
            }
        )
        .onTapGesture {
            handleTapSelection(cover: cover, index: index, proxy: proxy)
        }
    }

    private func selectionObserver(
        geo: GeometryProxy,
        outer: GeometryProxy,
        cover: AppUIEntities.BackgroundType?
    ) -> some View {
        Color.clear
            .onAppear {
                updateSelection(
                    geo: geo,
                    outer: outer,
                    cover: cover
                )
            }
            .onChange(of: geo.frame(in: .global).midX) { _ in
                updateSelection(
                    geo: geo,
                    outer: outer,
                    cover: cover
                )
            }
    }

    private func alignInitialSelection(with proxy: ScrollViewProxy) {
        guard !hasCompletedInitialPositioning else { return }
        let initialIndex = indexForCover(selected) ?? 0

        DispatchQueue.main.async {
            proxy.scrollTo(initialIndex, anchor: .center)
            hasCompletedInitialPositioning = true
        }
    }

    private func handleTapSelection(
        cover: AppUIEntities.BackgroundType?,
        index: Int,
        proxy: ScrollViewProxy
    ) {
        isTapSelectionInProgress = true
        selected = cover

        withAnimation(.easeInOut) {
            proxy.scrollTo(index, anchor: .center)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isTapSelectionInProgress = false
        }
    }

    private func updateSelection(
        geo: GeometryProxy,
        outer: GeometryProxy,
        cover: AppUIEntities.BackgroundType?
    ) {
        guard hasCompletedInitialPositioning else { return }
        guard !isTapSelectionInProgress else { return }

        let itemCenter = geo.frame(in: .global).midX
        let scrollCenter = outer.frame(in: .global).midX

        if abs(itemCenter - scrollCenter) < 28 {
            if !compareCovers(selected, cover) {
                selected = cover
            }
        }
    }

    private func indexForCover(_ cover: AppUIEntities.BackgroundType?) -> Int? {
        covers.firstIndex { compareCovers($0, cover) }
    }

    private func compareCovers(_ first: AppUIEntities.BackgroundType?, _ second: AppUIEntities.BackgroundType?) -> Bool {
        first?.bgColor == second?.bgColor
    }
}

struct CoverItemView: View {

    let cover: AppUIEntities.BackgroundType?
    let isSelected: Bool
    let width: CGFloat

    var body: some View {
        if let cover {
            CardBackgroundView(cardType: .club) {
            }
            .backgroundType(cover)
            .cornerRadius(12)
            .frame(height: width * 0.6)
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(isSelected ? Color.primary : .clear, lineWidth: 2.5)
            )
            .frame(width: width, height: width * 0.6 + 30)
        } else {
            RoundedRectangle(cornerRadius: 13)
                .stroke(isSelected ? Color.primary : .secondary, lineWidth: isSelected ? 2.5 : 0.5)
                .frame(width: width, height: width * 0.6)
                .padding(5)
                .overlay {
                    Text("Default")
                        .foregroundStyle(isSelected ? Color.primary : .secondary)
                        .font(Font.Typography.BodyTextMd.regular)
                }
        }
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {

    @State var selected: AppUIEntities.BackgroundType? = nil

    var body: some View {
        StudentCardCoverPicker(selected: $selected)
    }
}
