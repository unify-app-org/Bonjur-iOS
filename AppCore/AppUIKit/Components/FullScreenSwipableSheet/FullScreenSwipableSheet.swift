
import SwiftUI
import UIKit

public extension View {
    func appSwipeableSheet<Content: View, Background: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping (UIEdgeInsets) -> Content,
        @ViewBuilder background: @escaping () -> Background
    ) -> some View {
        self.modifier(SwipableSheetModifier(
            isPresented: isPresented,
            content: content,
            background: background
        ))
    }
}

private struct SwipableSheetModifier<SheetContent: View, SheetBackground: View>: ViewModifier {
    @Binding var isPresented: Bool
    let content: (UIEdgeInsets) -> SheetContent
    let background: () -> SheetBackground

    func body(content: Content) -> some View {
        content.background(
            SwipableSheetPresenter(
                isPresented: $isPresented,
                content: self.content,
                background: self.background
            )
        )
    }
}

private struct SwipableSheetPresenter<Content: View, Background: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let content: (UIEdgeInsets) -> Content
    let background: () -> Background

    final class Coordinator {
        weak var presentedSheetController: UIViewController?
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let presentedSheetController = context.coordinator.presentedSheetController

        if isPresented {
            if let presentedSheetController,
               uiViewController.presentedViewController === presentedSheetController ||
               presentedSheetController.presentingViewController != nil {
                return
            }

            context.coordinator.presentedSheetController = nil
            guard uiViewController.presentedViewController == nil else { return }

            let safeArea = uiViewController.view.safeAreaInsets
            let sheetVC = SwipableSheetViewController(
                isPresented: $isPresented,
                content: content(safeArea),
                background: background().ignoresSafeArea()
            )

            sheetVC.modalPresentationStyle = .overFullScreen
            context.coordinator.presentedSheetController = sheetVC
            uiViewController.present(sheetVC, animated: true)
        } else {
            guard let presentedSheetController else { return }

            if uiViewController.presentedViewController === presentedSheetController {
                presentedSheetController.dismiss(animated: true)
            }

            context.coordinator.presentedSheetController = nil
        }
    }
}
