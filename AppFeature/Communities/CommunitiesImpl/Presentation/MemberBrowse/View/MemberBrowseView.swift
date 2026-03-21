//
//  MemberBrowseView.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import Communities

struct MemberBrowseView: View {
    @ObservedObject var store: StoreOf<MemberBrowseFeature>

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(store.state.faculties, id: \.id) { faculty in
                    facultyButton(faculty)
                }
            }
            .padding(16)
        }
        .background(Color.Palette.grayQuaternary.opacity(0.35))
        .navigationTitle(store.state.title)
        .onAppear {
            store.send(.onAppear)
        }
    }
    @ViewBuilder
    func facultyButton(_ faculty: CommunitiesMemberModuleModel.FacultyRowModel)->some View{
        Button {
            store.send(.facultyTapped(faculty))
        } label: {
            HStack(spacing: 12) {
                Text(faculty.label)
                    .font(Font.Typography.BodyTextMd.bold)
                    .foregroundStyle(Color.Palette.black)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(uiImage: UIImage.Icons.chevronRight)
                    .foregroundStyle(Color.Palette.graySecondary)
            }
            .padding(16)
            .background(Color.Palette.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.Palette.grayTeritary.opacity(0.7), lineWidth: 0.4)
            )
        }
        .buttonStyle(.plain)
    }
}
