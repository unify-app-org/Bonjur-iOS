//
//  DiscoverSkeletonView.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 04.09.26.
//

import SwiftUI
import AppUIKit

/// Skeleton stand-in for the Discover content while the first load (or a filter
/// change) is in flight. It traces the real layout — filter chips, the community
/// pager, then the three card rows — so the screen keeps its shape and the content
/// lands in place instead of the whole dashboard sitting behind a blocking spinner.
///
/// Card sizes are eyeballed against the real cards (which are content-sized, so
/// there is nothing exact to copy); they only have to read as the same rhythm.
///
/// Mirrors Android `DiscoverSkeleton`.
struct DiscoverSkeletonView: View {

    let width: CGFloat
    /// `false` once the real `FilterView` has chips of its own to draw.
    let showFilterChips: Bool

    var body: some View {
        VStack(spacing: 0) {
            if showFilterChips {
                filterChips
            }

            communitySection

            section(cardWidth: width - 60, cardHeight: Layout.clubCardHeight)
            section(cardWidth: width - 90, cardHeight: Layout.activityCardHeight)
            section(cardWidth: width - 90, cardHeight: Layout.activityCardHeight)
        }
        .padding(.bottom, 24)
        // Pin to the viewport. The card rows are deliberately wider than the screen
        // (the trailing card is meant to be cut off), and without this the VStack
        // sized itself to the widest row: every `.padding(.horizontal, 16)` was then
        // measured against that oversized width, so the community box ran past the
        // right edge and the page dots were shoved off to the trailing side.
        .frame(width: width)
    }

    /// Stands in for `FilterView`, which draws nothing until the categories arrive.
    private var filterChips: some View {
        HStack(spacing: 8) {
            ForEach([CGFloat(72), 96, 84, 110], id: \.self) { chipWidth in
                ShimmerBox(cornerRadius: 17)
                    .frame(width: chipWidth, height: 34)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        // Same pin as the card rows: the four chips are wider than the screen, and
        // unclipped they re-centred the row and pulled the first chip off the
        // leading margin the real `FilterView` keeps.
        .frame(width: width, alignment: .leading)
        .clipped()
    }

    /// The community pager, measured off the real one rather than eyeballed: the
    /// section has a title of its own, and `AppTabView` is pinned to
    /// `Layout.communityBlockHeight` with an 8pt `CustomPageIndicator` under the
    /// card, which itself carries 16pt vertical padding. Sizing the box to the whole
    /// block (the old 184) made the skeleton stand a card-and-a-bit taller than the
    /// content that replaced it.
    private var communitySection: some View {
        VStack(spacing: 0) {
            sectionHeader(showsViewAll: false)

            VStack(spacing: 0) {
                ShimmerBox(cornerRadius: 20)
                    .frame(height: Layout.communityCardHeight)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)

                pageDots
            }
            .frame(height: Layout.communityBlockHeight)
        }
    }

    /// Mirrors `CustomPageIndicator`: 8pt tall, the current dot wide and the rest short.
    private var pageDots: some View {
        HStack(spacing: 4) {
            ForEach([CGFloat(32), 14, 14], id: \.self) { dotWidth in
                ShimmerBox(cornerRadius: 4)
                    .frame(width: dotWidth, height: Layout.pageIndicatorHeight)
            }
        }
    }

    /// Section title, with the trailing "view all" the community section does not draw.
    private func sectionHeader(showsViewAll: Bool) -> some View {
        HStack {
            ShimmerBox()
                .frame(width: 132, height: 22)
            Spacer()
            if showsViewAll {
                ShimmerBox()
                    .frame(width: 64, height: 16)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    /// Section header (title + "view all") over a row of cards.
    private func section(cardWidth: CGFloat, cardHeight: CGFloat) -> some View {
        VStack(spacing: 0) {
            sectionHeader(showsViewAll: true)

            // A plain HStack, not a ScrollView: the skeleton is a fixed handful of
            // cards and must not scroll or trigger the real row's load-more plumbing.
            HStack(spacing: 16) {
                ForEach(0..<2, id: \.self) { _ in
                    ShimmerBox(cornerRadius: 20)
                        .frame(width: cardWidth, height: cardHeight)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            // The second card runs past the trailing edge, exactly like the real
            // row. Pinned and clipped here rather than around the whole section:
            // left to overflow, the row set the section's width, and the header
            // above it was then laid out — and centred — inside that wider box
            // instead of spanning the screen.
            .frame(width: width, alignment: .leading)
            .clipped()
        }
    }

    private enum Layout {
        /// `AppTabView`'s pinned height in `DiscoverView.communitiesView`.
        static let communityBlockHeight: CGFloat = 200
        /// `CustomPageIndicator`'s tallest dot.
        static let pageIndicatorHeight: CGFloat = 8
        /// What is left of the block for the card: 200 - 8 indicator - 32 vertical padding.
        static let communityCardHeight: CGFloat = communityBlockHeight - pageIndicatorHeight - 32
        static let clubCardHeight: CGFloat = 168
        static let activityCardHeight: CGFloat = 208
    }
}
