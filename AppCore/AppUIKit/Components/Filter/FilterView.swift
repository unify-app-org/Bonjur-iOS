//
//  FilterView.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 12.01.26.
//

import SwiftUI
import Combine

public struct FilterView: View {
    @StateObject private var viewModel: FilterViewModel
    @State private var presentFilter: Bool = false
    
    public init(viewModel: FilterViewModel) {
        _viewModel = StateObject(
            wrappedValue: FilterViewModel(
                model: FilterView.Model.mock,
                selectedItems: { _ in }
            )
        )
    }
    
    public var body: some View {
        VStack(spacing: .zero) {
            chipsView
        }
        .overlay(alignment: .top) {
            selectSubItems(viewModel.selectedItem?.items ?? [])
                .frame(height: viewModel.selectedItem == nil ? 0 : nil)
                .opacity(viewModel.selectedItem == nil ? 0 : 1)
                .clipped()
                .background(Color.white)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 16,
                        bottomTrailingRadius: 16,
                        topTrailingRadius: 0
                    )
                )
                .offset(y: 64)
        }
        .background(alignment: .top) {
            if viewModel.selectedItem != nil {
                GeometryReader { geometry in
                    Color.black
                        .opacity(0.3)
                        .frame(height: UIScreen.main.bounds.height)
                        .onTapGesture {
                            withAnimation {
                                viewModel.selectItem(nil)
                            }
                        }
                }
            }
        }
        .fullScreenCover(isPresented: $presentFilter) {
            FilterScreen()
                .environmentObject(viewModel)
        }
        .animation(.easeInOut(duration: 0.25),
                   value: viewModel.selectedItem?.id)
        .zIndex(1)
        .onAppear {
            viewModel.sortFilters()
        }
    }
    
    @ViewBuilder
    private func selectSubItems(_ items: [Items]) -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(items, id: \.uuid) { item in
                        Button {
                            viewModel.toggleSubItem(item)
                        } label: {
                            HStack {
                                Image(uiImage: item.selected
                                      ? UIImage.Icons.selectedCheckBox
                                      : UIImage.Icons.notSelectedCheckBox)
                                Text(item.title)
                                    .foregroundStyle(Color.Palette.black)
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(.top)
            }
            .frame(height: 184)
            Divider()
            HStack(spacing: 18) {
                AppButton(
                    title: "Remove",
                    model: .init(
                        type: .secondary,
                        contentSize: .fill,
                        size: .small
                    )
                ) {
                    withAnimation {
                        viewModel.removeSelection()
                    }
                }
                
                AppButton(
                    title: "Apply",
                    model: .init(
                        contentSize: .fill,
                        size: .small
                    )
                ) {
                    withAnimation {
                        viewModel.confirmSelection()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(.white)
    }
    
    private var chipsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                filterView
                ForEach(viewModel.model, id: \.id) { item in
                    chipItem(item)
                }
            }
        }
        .background(Color.white)
    }
    
    private var filterView: some View {
        Button {
            presentFilter = true
        } label: {
            HStack {
                Image(uiImage: UIImage.Icons.filter04)
                Text("Filter")
                    .foregroundStyle(Color.Palette.black)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(viewModel.getSelectedCount() > 0 ? Color.Palette.primary.opacity(0.4) : Color.Palette.grayQuaternary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        viewModel.getSelectedCount() > 0 ? Color.Palette.border : Color.Palette.black,
                        lineWidth:  viewModel.getSelectedCount() > 0 ? 1 : 0
                    )
            )
            .overlay(alignment: .topTrailing) {
                if viewModel.getSelectedCount() > 0 {
                    Text("\(viewModel.getSelectedCount())")
                        .font(Font.Typography.TextSm.regular)
                        .foregroundStyle(Color.white)
                        .padding(5)
                        .background(Color.Palette.border)
                        .clipShape(Circle())
                        .offset(x: 4, y: -8)
                }
            }
            .padding(.leading)
        }
    }
    
    @ViewBuilder
    private func chipItem(_ item: Model) -> some View {
        Button {
            withAnimation {
                viewModel.selectItem(item)
            }
        } label: {
            HStack {
                Text(item.title)
                    .foregroundStyle(Color.Palette.black)
                Image(uiImage: UIImage.Icons.chevronDown02)
                    .rotationEffect(.degrees(viewModel.selectedItem?.id == item.id ? 180 : 0))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                viewModel.isSelected(item) ? .clear : viewModel.hasSelectedSubItems(item) ? Color.Palette.primary.opacity(0.4) : Color.Palette.grayQuaternary
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        viewModel.hasSelectedSubItems(item) ? viewModel.isSelected(item) ? Color.Palette.black : Color.Palette.border : Color.Palette.black,
                        lineWidth: viewModel.isSelected(item) || viewModel.hasSelectedSubItems(item) ? 1 : 0
                    )
            )
            .padding(.vertical)
            .padding(.trailing, viewModel.model.last?.id == item.id ? 16 : 0)
        }
    }
}

#Preview {
    ScrollView {
        FilterView(
            viewModel: FilterViewModel(
                model: FilterView.Model.mock,
                selectedItems: { item in
                
            })
        )
    }
}
