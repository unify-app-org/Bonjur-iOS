
import SwiftUI
import UIKit

extension View {
    func fullScreenSwipableSheet<Content: View, Background: View>(
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

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            if uiViewController.presentedViewController == nil {

                let safeArea = uiViewController.view.safeAreaInsets

                let sheetVC = SwipableSheetViewController(
                    ignoresSafeArea: ignoresSafeArea,
                    isPresented: $isPresented,
                    content: content(safeArea),
                    background: background().ignoresSafeArea()
                )

                sheetVC.modalPresentationStyle = .overFullScreen
                uiViewController.present(sheetVC, animated: true)
            }
        } else {
            uiViewController.presentedViewController?.dismiss(animated: true)
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
                .fullScreenSwipableSheet(isPresented: $show){safeArea in
                    
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
