//
//  FilterScreen.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 13.01.26.
//

import SwiftUI

struct FilterScreen: View {
    @EnvironmentObject private var viewModel: FilterViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            backButton
            topView
            SearchView(text: .constant(""))
            list
            buttons
        }
        .onAppear {
            viewModel.fetchFilterScreenData()
        }
        .padding()
    }
    
    private var backButton: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(uiImage: UIImage.Icons.arrowLeft01)
                    .foregroundStyle(Color.Palette.black)
            }
            Spacer()
        }
    }
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Filter")
                .font(Font.Typography.TitleXl.extraBold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("Select your interests to find the perfect community events for you.")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    @ViewBuilder
    private var list: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.filterModel, id: \.id) { section in
                    Text(section.title)
                        .foregroundStyle(Color.Palette.blackHigh)
                        .font(Font.Typography.BodyTextMd.semiBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    FlowLayout(spacing: 12, items: section.items) { item in
                        CategoriesChipsView(
                            model: .init(
                                id: item.id,
                                title: item.title,
                                selected: item.selected
                            )
                        )
                        .onTapGesture {
                            viewModel.toggleSubItemInFilterScreen(item)
                        }
                    }
                }
            }
        }
    }
    
    private var buttons: some View {
        HStack(spacing: 18) {
            AppButton(
                title: "Remove",
                model: .init(
                    type: .secondary,
                    contentSize: .fill
                )
            ) {
                withAnimation {
                    viewModel.removeAllFilters()
                    dismiss()
                }
            }
            
            AppButton(
                title: "Apply",
                model: .init(
                    contentSize: .fill
                )
            ) {
                withAnimation {
                    viewModel.confirmFilterScreen()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    FilterScreen()
}
