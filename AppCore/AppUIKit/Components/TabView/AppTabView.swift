//
//  AppTabView.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import SwiftUI

public struct AppTabView<Content: View>: View {
    @Binding private var currentPage: Int
    private let content: Content
    private let pageCount: Int
    
    public init(
        currentPage: Binding<Int>,
        pageCount: Int,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._currentPage = currentPage
        self.content = content()
        self.pageCount = pageCount
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                content
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            CustomPageIndicator(numberOfPages: pageCount, currentPage: currentPage)
                .padding(.bottom, 20)
        }
    }
}
