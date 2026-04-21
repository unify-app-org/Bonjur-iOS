
import SwiftUI
import UIKit

public extension View {
    func appSwipeableSheet<Content: View, Background: View>(
        ignoresSafeArea: Bool = false,
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping (UIEdgeInsets) -> Content,
        @ViewBuilder background: @escaping () -> Background
    ) -> some View {
        self.modifier(SwipableSheetModifier(
            ignoresSafeArea: ignoresSafeArea,
            isPresented: isPresented,
            content: content,
            background: background
        ))
    }
}

private struct SwipableSheetModifier<SheetContent: View, SheetBackground: View>: ViewModifier {
    var ignoresSafeArea: Bool
    @Binding var isPresented: Bool
    let content: (UIEdgeInsets) -> SheetContent
    let background: () -> SheetBackground

    func body(content: Content) -> some View {
        content.background(
            SwipableSheetPresenter(
                ignoresSafeArea: ignoresSafeArea,
                isPresented: $isPresented,
                content: self.content,
                background: self.background
            )
        )
    }
}

private struct SwipableSheetPresenter<Content: View, Background: View>: UIViewControllerRepresentable {
    var ignoresSafeArea: Bool
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
                ignoresSafeArea: ignoresSafeArea,
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


struct ExampleView:View {
    @State private var show:Bool = false
    var body: some View {
        NavigationStack{
            ZStack{
                
                Button("Show"){
                    show.toggle()
                }
                .appSwipeableSheet(isPresented: $show){safeArea in
                    
                    ScrollView{
                        LazyVStack{
                            ForEach(1...100,id: \.self){i in
                                Text("\(i)")
                                    .foregroundStyle(Color.white)
                                    .listRowBackground(Color.clear)
                            }
                        }
                    }
                        
                    
                    
                } background: {
                    RoundedRectangle(cornerRadius: 30 )
                        .fill(Color.yellow)
                    
                     
                    
                    
                }
            }
        }
        
    }
}

#Preview {
    ExampleView()
}
