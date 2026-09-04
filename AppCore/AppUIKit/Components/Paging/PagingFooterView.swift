//
//  PagingFooterView.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 04.09.26.
//

import SwiftUI

/// End-of-list marker that asks for the next page when it is reached.
///
/// It must sit as a direct child of a `LazyVStack`/`LazyHStack`: only then is it built
/// once the user has actually scrolled to the end, which is what makes paging follow the
/// scroll instead of firing once on entry. Inside a plain `VStack` every row is built
/// up front and `onReachEnd` would fire immediately.
public struct PagingFooterView: View {

    private let hasMore: Bool
    /// Bumped by the owner whenever a page lands, so the sentinel is rebuilt and can
    /// fire again for the page after it.
    private let token: Int
    private let onReachEnd: () -> Void

    public init(
        hasMore: Bool,
        token: Int,
        onReachEnd: @escaping () -> Void
    ) {
        self.hasMore = hasMore
        self.token = token
        self.onReachEnd = onReachEnd
    }

    public var body: some View {
        if hasMore {
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .id(token)
                .onAppear { onReachEnd() }
        }
    }
}
