// /Users/aplle/Desktop/Bonjur-iOS/AppFeature/Profile/ProfileImpl/Presentation/StudentCard/View/StudentCardView.swift

import SwiftUI
import AppFoundation
import AppUIKit

struct StudentCardView: View {
    @ObservedObject var store: StoreOf<StudentCardFeature>

    private var displayedCover: AppUIEntities.BackgroundType? {
        store.state.isChooseColorSheetPresented ? store.state.draftCover : store.state.savedCover
    }

    private var selectedColor: Color {
        displayedCover?.bgColor ?? Color.Palette.white
    }

    private var shouldShowCollapsedSpacing: Bool {
        !store.state.isChooseColorSheetPresented
    }

    private var coverSheetDetents: Set<PresentationDetent> {
        [.fraction(0.4)]
    }

    private var coverSheetBinding: Binding<Bool> {
        Binding(
            get: { store.state.isChooseColorSheetPresented },
            set: {
                if $0 {
                    store.send(.setCoverSheetPresented(true))
                }
            }
        )
    }

    private var draftCoverBinding: Binding<AppUIEntities.BackgroundType?> {
        Binding(
            get: { store.state.draftCover },
            set: {
                if store.state.isChooseColorSheetPresented {
                    store.send(.coverSelected($0))
                }
            }
        )
    }

    var body: some View {
        GeometryReader { geometry in
            screenContent(safeAreaTop:0)
        }
        .background(backgroundGradient)
    }

    private func screenContent(safeAreaTop: CGFloat) -> some View {
        contentContainer(safeAreaTop: safeAreaTop)
            .appSheet(
                isPresented: coverSheetBinding,
                detents: coverSheetDetents,
                onDismiss: { store.send(.coverSheetDismissed) }
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
        if shouldShowCollapsedSpacing {
            Spacer()
        }
    }

    @ViewBuilder
    private var collapsedBottomSpacer: some View {
        if shouldShowCollapsedSpacing {
            Spacer()
        }
    }

    private var coverPickerSheet: some View {
        StudentCardCoverPickerSheet(
            selected: draftCoverBinding,
            onSave: { store.send(.saveColorSelection) },
            onCancel: { store.send(.cancelColorSelection) }
        )
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                selectedColor.opacity(0.5),
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
