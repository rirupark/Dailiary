//
//  MypageView.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/10.
//

import SwiftUI

struct MypageView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isClickedSignOut: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(authViewModel.currentUser?.nickname ?? "Unknown")
                    .font(.title)
                    .bold()
                Spacer()
                
                Button {
                    isClickedSignOut = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        authViewModel.signOutUser()
                    }
                } label: {
                    Text("로그아웃")
                }
                .disabled(isClickedSignOut) // 다중클릭 방지
            }
            .padding(20)
            .padding(.top, 20)
            
            Spacer()
        } // VStack
        .popup(isPresented: $isClickedSignOut) {
            HStack {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                
                Text("로그아웃되었습니다.")
                    .foregroundColor(.white)
                    .font(.footnote)
                    .bold()
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(Color.red)
            .cornerRadius(100)
        } customize: {
            $0
                .autohideIn(2)
                .type(.floater())
                .position(.top)
        } // popup

    }
}

struct MypageView_Previews: PreviewProvider {
    static var previews: some View {
        MypageView().environmentObject(AuthViewModel())
    }
}
