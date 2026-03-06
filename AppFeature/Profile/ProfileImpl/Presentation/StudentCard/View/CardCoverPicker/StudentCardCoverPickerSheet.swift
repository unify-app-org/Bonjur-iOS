//
//  StudentCardCoverPickerSheet.swift
//  ProfileImpl
//
//  Created by aplle on 3/5/26.
//

import SwiftUI
import AppUIKit

struct StudentCardCoverPickerSheet: View {
    @Binding var selected: AppUIEntities.BackgroundType?
    var onSave: () -> ()
    var onCancel: () -> ()

    var body: some View {
        VStack(spacing: 16) {
            titleView
            coverPickerView
            actionButtonsView
                .padding(.horizontal, 25)
                .padding(.bottom, 8)
        }
    }

    private var titleView: some View {
        Text("Choose cover")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font.Typography.TitleMd.extraBold)
            .padding(.horizontal, 25)
            .padding(.top, 25)
    }

    private var coverPickerView: some View {
        StudentCardCoverPicker(selected: $selected)
    }

    private var actionButtonsView: some View {
        HStack {
            AppButton(
                title: "Cancel",
                model: .init(type: .tertiary)
            ) {
                onCancel()
            }
            AppButton(
                title: "Save",
                model: .init(contentSize: .fill)
            ) {
                onSave()
            }
        }
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {

    @State var selected: AppUIEntities.BackgroundType? = nil

    var body: some View {
        VStack {
        }
        .sheet(isPresented: .constant(true)) {
            StudentCardCoverPickerSheet(
                selected: $selected,
                onSave: {},
                onCancel: {}
            )
        }
    }
}
