//
//  ProfileDetailView.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct ProfileDetailView: View {
    @ObservedObject var store: StoreOf<ProfileDetailFeature>
    
    var body: some View {
        ScrollView {
            VStack {
                topView
                userCardView
            }
        }
    }
    
    
    private var topView: some View {
        HStack {
            Text("Profile")
                .font(Font.Typography.TitleL.extraBold)
                .foregroundStyle(Color.Palette.black)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(uiImage: UIImage.Icons.settings01)
                
            }
        }
    }
    
    private var userCardView: some View {
        UserCardView()
    }
}
