//
//  DiscoverView.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct DiscoverView: View {
    @ObservedObject var store: StoreOf<DiscoverFeature>
    
    var body: some View {
        VStack(spacing: .zero) {
            topView
            scrollView
        }
    }
    
    private var scrollView: some View {
        ScrollView {
            VStack {
                Text("Test")
            }
        }
    }

    private var topView: some View {
        VStack(spacing: .zero) {
            profileView
                .padding(.horizontal)
            FilterView(
                viewModel: .init(
                    model: FilterView.Model.mock,
                    selectedItems: { item in
                        // do
                    }
                )
            )
        }
    }
    
    private var profileView: some View {
        HStack {
            AsyncImage(url: nil) { image in
                image
                    .resizable()
                    .frame(width: 40, height: 40)
            } placeholder: {
                Image(systemName: "person")
                    .frame(width: 24, height: 24)
                    .padding(12)
                    .foregroundStyle(Color.Palette.black)
                    .background(Color.Palette.grayQuaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            
            VStack(spacing: 4) {
                Text("Welcome Bonjur")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .font(Font.Typography.TextMd.regular)
                    .foregroundStyle(Color.Palette.grayPrimary)
                Text("Durdana Hasan")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .font(Font.Typography.BodyTextSm.medium)
                    .foregroundStyle(Color.Palette.black)
            }
            
            Button {
                
            } label: {
                Image(uiImage: UIImage.Icons.bell)
                    .frame(width: 24, height: 24)
                    .padding(12)
                    .foregroundStyle(Color.Palette.graySecondary)
                    .background(Color.Palette.grayQuaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
}
