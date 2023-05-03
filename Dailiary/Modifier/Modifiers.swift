//
//  Modifiers.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/10.
//

import SwiftUI
import Foundation

// MARK: - 배경색이 들어간 버튼에 사용될 모디파이어. maxWidth가 .infinity
///버튼 크기에 따라 cornerRadius를 5, 10 으로 구분지어 사용하면 된다
struct MaxWidthColoredButtonModifier: ViewModifier {
    var color: Color = Color.accentColor
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .bold()
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    }
}

// MARK: - Modifier : 배경이 투명한 TextField 속성
struct ClearTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .font(.subheadline)
            .padding(.horizontal, 20)
    }
}

// MARK: - Modifier : TextField 아래 밑줄을 표현하기 위한 Rectangle 속성
struct TextFieldUnderLineRectangleModifier: ViewModifier {
    let stateTyping: Bool
    var padding: CGFloat = 20
    func body(content: Content) -> some View {
        content
            .frame(height: (stateTyping ? 1.5 : 1))
            .foregroundColor(stateTyping ? .accentColor : Color("LightGray"))
            .padding(.horizontal, padding)
    }
}
