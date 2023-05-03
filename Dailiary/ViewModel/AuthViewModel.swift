//
//  AuthViewModel.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/10.
//

import Foundation
import Firebase

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum LoginRequestState {
    case loggingIn
    case loggedIn
    case notLoggedIn
}

enum EmailDuplicationState {
    case checking
    case duplicated
    case notDuplicated
}

enum NickNamelDuplicationState {
    case checking
    case duplicated
    case notDuplicated
}

class AuthViewModel: ObservableObject {
    // MARK: - Property Wrappers
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var loginRequestState: LoginRequestState = .notLoggedIn
    @Published var emailDuplicationState: EmailDuplicationState = .duplicated // 중복한다고 전제
    @Published var nickNameDuplicationState: NickNamelDuplicationState = .duplicated // 중복한다고 전제
    @Published var currentUser: UserInfo?

    // MARK: - Properties
    let database = Firestore.firestore()
    let authentification = Auth.auth()
    
    
    // MARK: - Firebase Authentication에 사용자 계정을 생성하는 Method
    @MainActor
    func createUser(email: String, password: String, nickname: String) async -> Bool {
        authenticationState = .authenticating // 회원가입 진행 상태 저장
        do  {
            try await authentification.createUser(withEmail: email, password: password)
            print("account created.")
            authenticationState = .authenticated // 회원가입 진행 상태 저장
            // firestore에 user 등록
            let currentUserId = authentification.currentUser?.uid ?? ""
            registerUser(uid: currentUserId, email: email, nickname: nickname)
            return true
        }
        catch {
            print(error.localizedDescription)
            authenticationState = .unauthenticated // 회원가입 진행 상태 저장
            return false
        }
    }
    
    // MARK: - Firestore에 사용자 계정을 추가하는 Method
    func registerUser(uid: String, email: String, nickname: String) {
        database.collection("User")
            .document(uid)
            .setData([
                "id" : uid,
                "userEmail" : email,
                "userNickname" : nickname
            ])
    }
    
    // MARK: - Firestore를 통한 이메일 중복 검사를 하는 Method
    @MainActor
    func isEmailDuplicated(currentUserEmail: String) async -> Bool {
        emailDuplicationState = .checking // 중복 검사 진행 상태를 저장
        do {
            let document = try await database.collection("User")
                .whereField("userEmail", isEqualTo: currentUserEmail)
                .getDocuments()
            emailDuplicationState = document.isEmpty ? .notDuplicated : .duplicated // 중복 검사 진행 상태를 저장
            return !(document.isEmpty) // true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Firestore를 통한 닉네임 중복 검사를 하는 Method
    @MainActor
    func isNicknameDuplicated(currentUserNickname: String) async -> Bool {
        nickNameDuplicationState = .checking // 중복 검사 진행 상태를 저장
        do {
            let document = try await database.collection("User")
                .whereField("userNickname", isEqualTo: currentUserNickname)
                .getDocuments()
            nickNameDuplicationState = document.isEmpty ? .notDuplicated : .duplicated // 중복 검사 진행 상태를 저장
            return !(document.isEmpty) // true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Login Method
    @MainActor
    public func loginUser(email: String, password: String) async -> Void {
        loginRequestState = .loggingIn // 로그인 상태 저장
        do {
            loginRequestState = .loggedIn // 로그인 상태 저장
            try await authentification.signIn(withEmail: email, password: password)
            // 임시로 닉네임 빈 문자열로 넣어준다.
            self.currentUser = UserInfo(id: self.authentification.currentUser?.uid ?? "", email: email, nickname: "")
            print(self.currentUser!)
        } catch {
            loginRequestState = .notLoggedIn // 로그인 상태 저장
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Firestore에 저장된 사용자 닉네임을 가져오는 Method
    /// 수정 필요
//    private func requestUserNickname(uid: String) async -> String {
//        var nickName = ""
//        do {
//            try await database.collection("User").document(uid).getDocument { (document, error) in
//                if let document = document, document.exists {
//                    nickName = document.get("userNickname") as? String ?? ""
//                }
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        return nickName
//    }
    
    
    // MARK: - FireStore의 사용자 정보를 불러오는 Method
    func fetchUserInfo(user: UserInfo) {
        database.collection("User").getDocuments { snapshot, error in
            if let snapshot {
                for document in snapshot.documents {
                    let id : String = document.documentID
                    let docData = document.data()
                    
                    if id == user.id {
                        let userNickname: String = docData["userNickname"] as? String ?? ""
                        let userEmail: String = docData["userEmail"] as? String ?? ""
                        
                        self.currentUser = UserInfo(id: self.authentification.currentUser?.uid ?? "" ,email: userEmail, nickname: userNickname)
                        print(self.currentUser!)
                    }
                }
                
            }
        }
    }
    
    
    // MARK: - Authentication에서 로그아웃하는 Method
    public func signOutUser() {
        do {
            try authentification.signOut()
            loginRequestState = .notLoggedIn // 로그인 상태 저장
            
            // 로컬에 있는 CustomerInfo 구조체의 객체를 날림
            self.currentUser = nil
        } catch {
            dump("DEBUG : LOG OUT FAILED \(error.localizedDescription)")
        }
    }
}

