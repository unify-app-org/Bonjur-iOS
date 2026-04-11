// /Users/aplle/Desktop/Bonjur-iOS/AppFeature/Profile/ProfileImpl/Presentation/StudentCard/View/StudentCardView.swift

import SwiftUI
import AppFoundation
import AppUIKit

struct StudentCardView: View {
    @ObservedObject var store: StoreOf<StudentCardFeature>

    var body: some View {
        GeometryReader { geometry in
            screenContent(safeAreaTop:0)
        }
        .background(backgroundGradient)
    }

    private func screenContent(safeAreaTop: CGFloat) -> some View {
        contentContainer(safeAreaTop: safeAreaTop)
            .appSheet(
                isPresented: store.state.coverSheetBinding(
                    onSetCoverSheetPresented: { store.send(.setCoverSheetPresented($0)) }
                ),
                detents: store.state.coverSheetDetents
            ) {
                coverPickerSheet
            }
    }

    private func contentContainer(safeAreaTop: CGFloat) -> some View {
        VStack(spacing: 16) {
            topBarView(safeAreaTop: safeAreaTop)
            collapsedTopSpacer
            cardView
            Spacer()
            collapsedBottomSpacer
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 16)
        .animation(.easeInOut(duration: 0.25), value: store.state.isChooseColorSheetPresented)
    }

    @ViewBuilder
    private var collapsedTopSpacer: some View {
        if store.state.shouldShowCollapsedSpacing {
            Spacer()
        }
    }

    @ViewBuilder
    private var collapsedBottomSpacer: some View {
        if store.state.shouldShowCollapsedSpacing {
            Spacer()
        }
    }

    private var coverPickerSheet: some View {
        StudentCardCoverPickerSheet(
            selected: store.state.draftCoverBinding(
                onCoverSelected: { store.send(.coverSelected($0)) }
            ),
            onSave: { store.send(.saveColorSelection) },
            onCancel: { store.send(.cancelColorSelection) }
        )
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                store.state.selectedColor.opacity(0.5),
                Color.Palette.white
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
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
