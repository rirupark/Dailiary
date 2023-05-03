//
//  ContentView.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/10.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.currentUser?.id == nil {
            LogInView()
        } else {
            TabView {
                HomeView().tabItem {
                    Image(systemName: "house.fill")
                    Text("HOME")
                }.tag(1)
                MypageView().tabItem {
                    Image(systemName: "person.circle")
                    Text("MYPAGE")
                }.tag(2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthViewModel())
    }
}
