//
//  StudentCardCoverPicker.swift
//  ProfileImpl
//
//  Created by aplle on 3/5/26.
//

import SwiftUI
import AppUIKit

struct StudentCardCoverPicker: View {
    
    let covers = StudentCardViewState.availableCovers
    
    @Binding var selected: AppUIEntities.BackgroundType?
    @State private var hasCompletedInitialPositioning = false
    
    var body: some View {
        
        GeometryReader { outer in
            
            ScrollViewReader { proxy in
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 16) {
                        
                        ForEach(Array(covers.enumerated()), id: \.offset) { index, cover in
                            
                            CoverItemView(
                                cover: cover,
                                isSelected: compareCovers(cover, selected),
                                width: outer.size.width / 2.8
                            )
                            .id(index)
                            .background(
                                GeometryReader { geo in
                                    
                                    Color.clear
                                        .onAppear {
                                            updateSelection(
                                                geo: geo,
                                                outer: outer,
                                                cover: cover
                                            )
                                        }
                                        .onChange(of: geo.frame(in: .global).midX) { _ in
                                            updateSelection(
                                                geo: geo,
                                                outer: outer,
                                                cover: cover
                                            )
                                        }
                                    
                                }
                            )
                            .onTapGesture {
                                selected = cover
                                
                                
                                withAnimation(.easeInOut) {
                                    proxy.scrollTo(index, anchor: .center)
                                }
                            }
                            
                        }
                        
                    }
                    .padding(.horizontal, outer.size.width / 2 - 70)
                    
                }
                .onAppear {
                    guard !hasCompletedInitialPositioning else { return }
                    let initialIndex = indexForCover(selected) ?? 0
                    DispatchQueue.main.async {
                        proxy.scrollTo(initialIndex, anchor: .center)
                        hasCompletedInitialPositioning = true
                    }
                }
               
                
            }
        }
      
        
    }
    
    private func updateSelection(
        geo: GeometryProxy,
        outer: GeometryProxy,
        cover: AppUIEntities.BackgroundType?
    ) {
        guard hasCompletedInitialPositioning else { return }
        
        let itemCenter = geo.frame(in: .global).midX
        let scrollCenter = outer.frame(in: .global).midX
        
        if abs(itemCenter - scrollCenter) < 40 {
            DispatchQueue.main.async {
                selected = cover
            }
        }
        
    }
    
    private func indexForCover(_ cover: AppUIEntities.BackgroundType?) -> Int? {
        covers.firstIndex { compareCovers($0, cover) }
    }
    
    func compareCovers(_ first: AppUIEntities.BackgroundType?, _ second: AppUIEntities.BackgroundType?) -> Bool {
        first?.bgColor == second?.bgColor
    }
}
struct CoverItemView: View {
    
    let cover: AppUIEntities.BackgroundType?
    let isSelected: Bool
    let width:CGFloat
    
    var body: some View {
        if let cover {
            CardBackgroundView(cardType: .club) {
               
            }
            
            .backgroundType(cover)
            .cornerRadius(12)
            .frame(height: width * 0.6)
            .padding(5)
            
            .overlay(
                
                RoundedRectangle(cornerRadius: 13,style: .continuous)
                        .stroke(isSelected ? Color.primary : .clear, lineWidth: 2.5)
                
            )
            .frame(width: width,height: width * 0.6 + 30)
        }else{
            RoundedRectangle(cornerRadius: 13)
            
                .stroke(isSelected ? Color.primary : .secondary, lineWidth:isSelected ? 2.5 : 0.5)
                .frame(width: width,height: width * 0.6 )
                .padding(5)
            .overlay {
                Text("Default")
                    .foregroundStyle(isSelected ? Color.primary : .secondary)
                    .font(Font.Typography.BodyTextMd.regular)
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
        StudentCardCoverPicker(selected: $selected)
    }
}
