//
//  LogInView.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/10.
//

import SwiftUI
import PopupView


// MARK: - LoginView
/// 로그인을 하는 View 입니다.
struct LogInView: View {
    // MARK: - Property Wrappers
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var email = ""
    @State var password = ""
    
    @FocusState var isInFocusEmail: Bool
    @FocusState var isInFocusPassword: Bool
    
    @State private var isLoggedInFailed = false
    @State private var loginFailed = false
    
    @State var navStack = NavigationPath()

    
    // MARK: - Methods
    private func logInWithEmailPassword() {
        Task {
            await authViewModel.loginUser(email: email, password: password)
            if authViewModel.loginRequestState == .loggedIn {
                isLoggedInFailed = false
                dismiss()
                authViewModel.fetchUserInfo(user: authViewModel.currentUser!)
                print("로그인 성공 - 이메일: \(authViewModel.currentUser?.email ?? "???")")
            } else {
                isLoggedInFailed = true
                print("로그인 실패")
            }
        }
    }
    
    
    // MARK: - Body LoginView
    /// LoginView의 body 입니다.
    var body: some View {
        NavigationStack(path: $navStack) {
            VStack {

                ForEach(1...2, id: \.self) { _ in
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 13) {
                        Text("📓 Dailiary")
                            .font(.largeTitle)
                            .bold()
                        Text("회원 서비스 이용을 위해 로그인을 해주세요 :)")
                            .font(.subheadline)
                    } // VStack - 안내문구 text
                    Spacer()
                } // HStack - 안내문구 Vstack
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                Spacer()
            
                VStack {
                    VStack(spacing: 5) {
                        TextField("이메일", text: $email)
                            .focused($isInFocusEmail)
                            .modifier(ClearTextFieldModifier())
                            .font(.subheadline)
                        Rectangle()
                            .modifier(TextFieldUnderLineRectangleModifier(stateTyping: isInFocusEmail))
                    }
                    .padding(.bottom, 35)
                    
                    VStack(spacing: 5) {
                        SecureField("비밀번호", text: $password)
                            .focused($isInFocusPassword)
                            .modifier(ClearTextFieldModifier())
                            .font(.subheadline)
                        Rectangle()
                            .modifier(TextFieldUnderLineRectangleModifier(stateTyping: isInFocusPassword))
                    }
                } // VStack - 이메일, 비밀번호 TextField
                
                Spacer()
                
                Button {
                    // Login action with firebase...
                    logInWithEmailPassword()
                } label: {
                    if authViewModel.loginRequestState == .loggingIn {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .frame(height: 40)
                    } else { // 로그인 전이나 후에는 버튼을 띄운다.
                        Text("로그인하기")
                            .modifier(MaxWidthColoredButtonModifier(cornerRadius: 15))
                    }
                }
                
                
                HStack {
                    Text("아직 계정이 없으신가요?")
                        .font(.footnote)

                    NavigationLink(value: "") {
                        Text("회원가입")
                            .font(.footnote)
                            .foregroundColor(.accentColor)
                    }
                    .navigationDestination(for: String.self) { value in
                        // Going to SignupView
                        SignUpTermsView(navStack: $navStack)
                    }
                    .navigationBarBackButtonHidden(true)
                } // HStack - 회원가입
                .padding(.top, 20)
                
                ForEach(1...3, id: \.self) { _ in
                    Spacer()
                }
                
                
            } // VStack - body 바로 아래
//            .background(Color.white) // 화면 밖 터치할 때 백그라운드 지정을 안 해주면 View에 올라간 요소들 클릭 시에만 적용됨.
//            .onTapGesture() { // 키보드 밖 화면 터치 시 키보드 사라짐
//                endEditing()
//            } // onTapGesture
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        // 닫기 버튼 클릭 시 로그인 뷰(시트) 사라짐.
//                        dismiss()
//                    } label: {
//                        Image(systemName: "multiply")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 17)
//                            .foregroundColor(.gray)
//                            .fontWeight(.light)
//                    } // label
//                } // toolbarItem
//            } // toolbar
            .popup(isPresented: $isLoggedInFailed) {
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .foregroundColor(.white)
                    
                    Text("이메일 및 비밀번호를 다시 확인해주세요.")
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
        } // NavigationStack
    } // Body
}

// MARK: - LoginView Previews
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView().environmentObject(AuthViewModel())
    }
}


