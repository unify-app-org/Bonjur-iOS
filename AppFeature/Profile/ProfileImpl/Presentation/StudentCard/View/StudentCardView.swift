// /Users/aplle/Desktop/Bonjur-iOS/AppFeature/Profile/ProfileImpl/Presentation/StudentCard/View/StudentCardView.swift

import SwiftUI
import AppFoundation
import AppUIKit

struct StudentCardView: View {
    @ObservedObject var store: StoreOf<StudentCardFeature>

    var displayedCover: AppUIEntities.BackgroundType? {
        store.state.isChooseColorSheetPresented ? store.state.draftCover : store.state.selectedCover
    }

    var selectedColor: Color {
        displayedCover?.bgColor ??  Color.Palette.white
    }

    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 16) {
                topBarView(safeAreaTop: 0)

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
            .sheet(
                isPresented: Binding(
                    get: { store.state.isChooseColorSheetPresented },
                    set: {
                        if $0 {
                            store.send(.setCoverSheetPresented(true))
                        }
                    }
                ),
                onDismiss: {
                    store.send(.coverSheetDismissed)
                }
            ) {
                VStack(spacing: 16) {
                    Text("Choose cover")

                    StudentCardCoverPicker(
                        selected: Binding(
                            get: { store.state.draftCover },
                            set: { store.send(.coverSelected($0)) }
                        )
                    )

                    HStack {
                        Button("Cancel") { store.send(.cancelColorSelection) }
                        Button("Save") { store.send(.saveColorSelection) }
                    }
                }
                .presentationDetents([.height(260)])
            }
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
