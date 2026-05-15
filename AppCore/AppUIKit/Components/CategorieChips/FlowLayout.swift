//
//  FlowLayout.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 30.12.25.
//

import SwiftUI

public struct FlowLayout: View {
    private let spacing: CGFloat
    private let items: [Item]
    private let content: (AnyHashable) -> AnyView
    
    @State private var totalHeight: CGFloat = 0
    
    private struct Item: Identifiable {
        let id: Int
        let value: AnyHashable
    }
    
    public init<Items: RandomAccessCollection, Content: View>(
        spacing: CGFloat = 12,
        items: Items,
        @ViewBuilder content: @escaping (Items.Element) -> Content
    ) where Items.Element: Hashable {
        self.spacing = spacing
        self.items = items.enumerated().map { index, item in
            Item(id: index, value: AnyHashable(item))
        }
        self.content = { item in
            AnyView(content(item.base as! Items.Element))
        }
    }
    
    public var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(items) { item in
                content(item.value)
                    .padding([.trailing, .bottom], spacing)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if (abs(width - dimension.width) > geometry.size.width) {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if item.id == items.last?.id {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { dimension in
                        let result = height
                        if item.id == items.last?.id {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
