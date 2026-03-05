//
//  StudentCardView.swift
//  ProfileImpl
//
//  Created by aplle on 3/4/26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct StudentCardView: View {
    @ObservedObject var store: StoreOf<StudentCardFeature>
  
    var selectedColor: Color {
        store.state.selectedCover?.bgColor ?? Color.Palette.primary
    }
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 16) {
                topBarView(safeAreaTop:0)
                if !store.state.isChooseColorSheetPresented {
                    Spacer()
                }
                cardView
                Spacer()
                if !store.state.isChooseColorSheetPresented {
                Spacer()
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 16)
            .animation(.easeInOut(duration: 0.25), value: store.state.isChooseColorSheetPresented)
        }
        .background(
            
            LinearGradient(
                colors: [
                    selectedColor.opacity(0.5),
                    Color.Palette.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    @ViewBuilder
    private var cardView: some View {
        if let model = store.state.previewCard {
            UserCardView(model: model, onTap: {})
                .fixedSize(horizontal: false, vertical: true)
                .allowsHitTesting(false)
        }
    }

    private func topBarView(safeAreaTop: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            customNavigationBar(safeAreaTop: safeAreaTop)
            titleView
        }
    }

    private func customNavigationBar(safeAreaTop: CGFloat) -> some View {
        HStack {
            Button {
                store.send(.closeTapped)
            } label: {
                Image(uiImage: UIImage.Icons.xmark)
            }
            Spacer()
            
            Button {
                store.send(.editTapped)
            } label: {
                Image(uiImage: UIImage.Icons.penLine)
            }
        }
      
        .padding(.top, safeAreaTop)
        .padding(.bottom, 8)
       
    }
    private var titleView: some View {
        HStack {
            Text("User Card")
                .font(Font.Typography.TitleL.extraBold)
                .frame(maxWidth: .infinity, alignment: .leading)
               
        }
      
    }
    
}
