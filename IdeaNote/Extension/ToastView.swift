//
//  ToastView.swift
//  IdeaNote
//
//  Created by v_jinlilili on 25/12/2024.
//

import SwiftUI

struct ToastViewModifier: ViewModifier {
    @Binding var message: String    // 吐司消息的内容
    var alignment: Alignment = .center  // 吐司消息的显示位置（默认居中）
    @Binding var present: Bool  // 控制吐司显示与否的状态
    @State private var showToast = false // 控制吐司消息是否显示的状态（内部使用）
    var duration: Double = 2.0 // 吐司消息显示的时长，默认为 2 秒
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .zIndex(0)
            VStack {
                Text(message)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .background(Color.gray.opacity(0.1))
            .opacity(showToast ? 1 : 0)
            .zIndex(1)
            .onChange(of: present) { oldValue, newValue in
                if newValue {
                    // 当 present 为 true 时，显示吐司
                    showToast = true
                    // 延时后隐藏吐司
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        showToast = false
                        present.toggle()
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showToast) // 吐司的显示与隐藏有动画效果
        }
    }
}

extension View {
    func toast(present: Binding<Bool>, message: Binding<String>, _ alignment: Alignment = .center, _ duration: Double = 2.0) -> some View {
        modifier(ToastViewModifier(message: message, alignment: alignment, present: present, duration: duration))
    }
}
