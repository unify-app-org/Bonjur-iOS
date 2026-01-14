//
//  CardBackgroundExample.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 15.01.26.
//

import SwiftUI

// MARK: - Preview Examples
struct CardBackgroundExample: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CardBackgroundView {
                    VStack(spacing: 12) {
                        Text("Community Hub")
                            .font(.system(size: 28, weight: .bold))
                        
                        Text("Connect with others")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(height: 200)
                .padding(.horizontal)
                
                CardBackgroundView {
                    HStack(spacing: 16) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.green.opacity(0.7))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Active Members")
                                .font(.system(size: 18, weight: .semibold))
                            Text("1,234 online now")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
                .frame(height: 150)
                .padding(.horizontal)
                
                CardBackgroundView {
                    VStack(spacing: 10) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue.opacity(0.7))
                        
                        Text("Start Chatting")
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
                .background(Color(red: 0.7, green: 0.85, blue: 0.95))
                .circleStroke(.white)
                .strokeWidth(50)
                .frame(height: 180)
                .padding(.horizontal)
                
                CardBackgroundView {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Premium")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.purple.opacity(0.6))
                                .cornerRadius(12)
                            
                            Text("Unlock Features")
                                .font(.system(size: 22, weight: .bold))
                            
                            Text("Get access to exclusive content")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .background(Color(red: 0.95, green: 0.85, blue: 0.95))
                .circleStroke(.white)
                .strokeWidth(30)
                .frame(height: 160)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(.black)
    }
}

#Preview {
    CardBackgroundExample()
}
