//
//  Page.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 04.09.26.
//

import Foundation

/// One page of already-mapped domain models, plus what the caller needs to ask for the
/// next one. Repos build this from `PageNationResponse` so view models never have to
/// guess whether more rows exist from the row count alone.
public struct Page<Item> {
    public let items: [Item]
    /// Zero-based index of the page these items came from.
    public let page: Int
    public let hasMore: Bool
    public let totalCount: Int?

    public init(
        items: [Item],
        page: Int,
        hasMore: Bool,
        totalCount: Int? = nil
    ) {
        self.items = items
        self.page = page
        self.hasMore = hasMore
        self.totalCount = totalCount
    }

    public func map<Mapped>(_ transform: (Item) -> Mapped) -> Page<Mapped> {
        .init(
            items: items.map(transform),
            page: page,
            hasMore: hasMore,
            totalCount: totalCount
        )
    }

    public static var empty: Page<Item> {
        .init(items: [], page: 0, hasMore: false, totalCount: 0)
    }
}

public extension PageNationResponse {

    /// True when a further page exists. Prefers the page metadata; falls back to
    /// "this page came back full" so paging still works if `page`/`totalPages` ever go
    /// missing (they'd otherwise decode as nil and silently end the list).
    func hasMore(requestedPage: Int, requestedSize: Int, receivedCount: Int) -> Bool {
        if let totalPages {
            return (page ?? requestedPage) + 1 < totalPages
        }
        let received = numberOfElements ?? receivedCount
        let pageSize = size ?? requestedSize
        guard pageSize > 0 else { return false }
        return received >= pageSize
    }

    /// Wraps mapped domain models in a `Page`, carrying the server's paging metadata over.
    func page<Item>(
        requestedPage: Int,
        requestedSize: Int,
        items: [Item]
    ) -> Page<Item> {
        .init(
            items: items,
            page: page ?? requestedPage,
            hasMore: hasMore(
                requestedPage: requestedPage,
                requestedSize: requestedSize,
                receivedCount: items.count
            ),
            totalCount: totalElements
        )
    }
}
