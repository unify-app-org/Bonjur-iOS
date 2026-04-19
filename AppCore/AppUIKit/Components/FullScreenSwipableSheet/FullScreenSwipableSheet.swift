
import SwiftUI

extension View{
    @ViewBuilder
    func fullScreenSwipableSheet<Content: View,Background:View>(
        ignoresSafeArea:Bool = false,
        isPresented:Binding<Bool>,
        @ViewBuilder content: @escaping (UIEdgeInsets) -> Content,
        @ViewBuilder background: @escaping () -> Background
    ) -> some View {
        self
            .fullScreenCover(isPresented: isPresented){
                FullScreenSwipableSheet(ignoreSafeArea: ignoresSafeArea, content: content, background: background)
            }
    }
    
    
}

fileprivate struct FullScreenSwipableSheet<Content: View,Background:View>: View {
    var ignoreSafeArea:Bool
    @ViewBuilder var content:(UIEdgeInsets) -> Content
    @ViewBuilder var background:Background // for now its not used
    @Environment(\.dismiss) var dismiss
    @State private var offset:CGFloat = 0
    @State private var scrollDisabled:Bool = false
    var body: some View {
        if #available(iOS 18.0, *) {
            content(safeArea)
                .scrollDisabled(scrollDisabled)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .offset(y:offset)
                .gesture(
                    CustomPanGesture{recognizer in
                        print("Handle")
                        let state = recognizer.state
                        let halfHeight = self.windowSize.height/2
                        let translation = min(max(recognizer.translation(in: recognizer.view).y,0),windowSize.height)
                        let velocity = min(max(recognizer.velocity(in: recognizer.view).y, 0),halfHeight)
                        print(translation)
                        switch state {
                            
                        case .began:
                            scrollDisabled = true
                            print(translation)
                            offset = translation
                        case .changed:
                            print(translation)
                            guard scrollDisabled else { return }
                            offset = translation
                        case .ended,.cancelled,.failed:
                            recognizer.isEnabled = false
                            if (translation + velocity) > halfHeight{
                                withAnimation(.snappy(duration:0.3,extraBounce:0)){
                                    offset = windowSize.height
                                }
                                Task{
                                    try? await Task.sleep(for:.seconds(0.3))
                                    var transaction = Transaction()
                                    transaction.disablesAnimations = true
                                    withTransaction(transaction){
                                        
                                        dismiss()
                                    }
                                    
                                }
                            }else{
                                withAnimation(.snappy(duration:0.3,extraBounce:0)){
                                    offset = 0
                                }
                                
                                Task{
                                    try? await Task.sleep(for:.seconds(0.3))
                                    scrollDisabled = false
                                    recognizer.isEnabled = true
                                }
                            }
                        default:()
                        }
                        
                    }
                )
                .presentationBackground{
                    background
                        .offset(y: offset)
                }
                .ignoresSafeArea(.container,edges:ignoreSafeArea ? .all : [])
        } else {
            // Fallback on earlier versions
        }
    }
    var windowSize:CGSize{
        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow{
            return window.screen.bounds.size
        }
        return .zero
    }
    var safeArea:UIEdgeInsets{
        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow{
            return window.safeAreaInsets
        }
        return .zero
    }
}

fileprivate struct CustomPanGesture: UIGestureRecognizerRepresentable {
    var handle: (UIPanGestureRecognizer) -> ()

    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator(handle: handle)
    }

    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let gr = UIPanGestureRecognizer()
        gr.delegate = context.coordinator
        return gr
    }

    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        context.coordinator.handle = handle  // ✅ Keep closure up to date
    }

    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        context.coordinator.handle(recognizer)  // ✅ Call through coordinator
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var handle: (UIPanGestureRecognizer) -> ()

        init(handle: @escaping (UIPanGestureRecognizer) -> ()) {
            self.handle = handle
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
            guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }
            let velocity = pan.velocity(in: pan.view).y
            var offset: CGFloat = 0
            if let cv = other.view as? UICollectionView {
                offset = cv.contentOffset.y + cv.adjustedContentInset.top
            } else if let sv = other.view as? UIScrollView {
                offset = sv.contentOffset.y + sv.adjustedContentInset.top
            }
            return Int(offset) <= 1 && velocity > 0
        }
    }
}
struct ExampleView:View {
    @State private var show:Bool = false
    var body: some View {
        NavigationStack{
            Button("Show"){
                show.toggle()
            }
            .fullScreenSwipableSheet(ignoresSafeArea: true,isPresented: $show){safeArea in
                if #available(iOS 17.0, *) {
                    ScrollView{
                        LazyVStack{
                            ForEach(1...100,id: \.self){i in
                                Text("\(i)")
                                    .foregroundStyle(Color.white)
                                    .listRowBackground(Color.clear)
                            }
                        }
                    }
                  
                    .safeAreaPadding(.top,safeArea.top)
                } else {
                    // Fallback on earlier versions
                }
            } background: {
                if #available(iOS 26.0, *) {
                    ConcentricRectangle()
                        .fill(Color.red)
                } else {
                    // Fallback on earlier versions
                }
                  
                   
            }
        }
        
    }
}

#Preview {
    ExampleView()
}
