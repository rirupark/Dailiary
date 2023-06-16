//
//  HomeView.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/10.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var diaryViewModel = DiaryViewModel()
    @State private var showingAddingSheet: Bool = false
    @State var isShowingLoginSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(diaryViewModel.diaryInfos) { diary in
                    if authViewModel.currentUser?.id == diary.userId {
                        NavigationLink {
                            DetailDiaryView(diaryViewModel: diaryViewModel, selectedDiary: diary)
                        } label: {
                            DiaryView(diary: diary)
                                .contextMenu {
                                    Button {
                                        diaryViewModel.removeDiary(diary: diary)
                                    } label: {
                                        Text("Remove")
                                        Image(systemName: "trash")
                                    }
                                } // contextMenu
                        } // NavigationLink
                    }
                } // ForEach
                .onDelete(perform: removeDiary)
            }
            .listStyle(.plain)
            .navigationTitle("📓 Dailiary")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddingSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .fullScreenCover(isPresented: $showingAddingSheet) {
                AddDiaryView(diaryViewModel: diaryViewModel, showingSheet: $showingAddingSheet)
            }
            .onAppear {
                diaryViewModel.fetchDiaries()
            }
            .refreshable {
                diaryViewModel.fetchDiaries()
            }
        } // naviagationStack
    } // body
    
    // MARK: - onDelete perform function
    func removeDiary(at offsets: IndexSet) {
        // Delete from firestore
        for index in offsets {
            diaryViewModel.removeDiary(diary: diaryViewModel.diaryInfos[index])
        }
        // Delete from list
        diaryViewModel.diaryInfos.remove(atOffsets: offsets)
    }
}

struct DiaryView: View {
    var diary: DiaryInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(diary.createdDate)
                .font(.footnote)
                .foregroundColor(.gray)
            Text(diary.title)
                .padding(.bottom, 1)
            //Text(diary.content)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
