//
//  AddDiaryView.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/10.
//

import SwiftUI
import PhotosUI

struct AddDiaryView: View {
    // MARK: - Property Wrappers
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var diaryViewModel: DiaryViewModel
    @Binding var showingSheet: Bool
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    @State private var selectedImages: [PhotosPickerItem] = [] // 이미지 변수
    @State private var selectedImageData: [Data] = [] // 뿌려주기 위한 이미지 데이터 변수
    
    @State private var showingMapSheet: Bool = false
    
    @State private var address: String = ""
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    
    // MARK: - Properties
    // 공백 제거
    var trimTitle: String {
        title.trimmingCharacters(in: .whitespaces)
    }
    var trimContent: String {
        content.trimmingCharacters(in: .whitespaces)
    }
    
    var images: [UIImage]  {
        var uiImages: [UIImage] = []
        if !selectedImageData.isEmpty {
            for imageData in selectedImageData {
                if let image = UIImage(data: imageData) {
                    uiImages.append(image)
                }
            }
        }
        return uiImages
    }
    
    // MARK: - Method
    func getToday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일" // "yyyy-MM-dd HH:mm:ss"
        
        let dateCreatedAt = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        
        return dateFormatter.string(from: dateCreatedAt)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Text("오늘 하루는 어땠나요? 🫧")
                        .foregroundColor(.gray)
                    Spacer()
                } // HStack
                .padding(EdgeInsets(top: 1, leading: 20, bottom: 5, trailing: 20))
                
                VStack {
                    if !address.isEmpty {
                        HStack {
                            Spacer()
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.accentColor)
                                .font(.caption)
                            Text("\(address)")
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // *** 이미지 업로드 중일 때 Progress가 필요해보임. ***
                    // 선택된 이미지가 하나라면 이미지가 꽉 차게 출력시켜준다.
                    if selectedImageData.count == 1 {
                        // 선택된 이미지 출력.
                        ForEach(selectedImageData, id: \.self) { imageData in
                            if let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .cornerRadius(10)
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                                    .padding(.horizontal, 20)
                            } // if let
                        } // ForEach
                    } else { // 여러개면 스크롤뷰로 작게 보여준다.
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                // 선택된 이미지 출력.
                                ForEach(selectedImageData, id: \.self) { imageData in
                                    if let image = UIImage(data: imageData) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .cornerRadius(10)
                                            .scaledToFit()
                                            .frame(maxHeight: 200)
                                    } // if let
                                } // ForEach
                            } // HStack
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    TextField("제목을 입력해주세요.", text: $title, axis: .vertical)
                        .modifier(ClearTextFieldModifier())
                        .bold()
                        .padding(.top, 15)
                    
                    Divider()
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                    
                    TextField("내용을 입력해주세요.", text: $content, axis: .vertical)
                        .modifier(ClearTextFieldModifier())
                } // VStack
                .padding(.vertical, 10)
                .navigationTitle(getToday())
                .formStyle(.columns)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            // 닫기 버튼 클릭 시 로그인 뷰(시트) 사라짐.
                            showingSheet.toggle()
                        } label: {
                            Image(systemName: "multiply")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17)
                                .foregroundColor(.gray)
                                .fontWeight(.light)
                        } // label
                    } // ToolbarItem

                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            // 위치 정보 추가 버튼
                            Button {
                                // 지도 action
                                showingMapSheet.toggle()
                            } label: {
                                Image(systemName: "map")
                            }

                            // 이미지 선택하기 버튼
                            PhotosPicker(selection: $selectedImages, matching: .images, photoLibrary: .shared()) {
                                Image(systemName: "photo")
                            }
                            .onChange(of: selectedImages) { newImages in
                                // 선택된 이미지가 없다면 비워줘야 함.
                                if newImages.isEmpty { selectedImageData = [] }
                                // 선택된 이미지가 있다면 뿌려주기 위해 배열에 담기.
                                for newImage in newImages {
                                    Task {
                                        // 배열 초기화
                                        selectedImageData = []
                                        // Retrieve selected asset in the form of Data
                                        if let data = try? await newImage.loadTransferable(type: Data.self) {
                                            selectedImageData.append(data)
                                        }
                                    } // Task
                                } // for
                            } // onChanged
                        } // HStack - 위치 버튼과 앨범 버튼
                    } // ToolbarItem
                } // toolbar
            } // ScrollView
            .sheet(isPresented: $showingMapSheet) {
                SearchAddressView(address: $address, latitude: $latitude, longitude: $longitude ,showingMapSheet: $showingMapSheet)
            }
            
            Divider()

            // 작성 완료 버튼
            Button {
                Task {
                    let createdAt = Date().timeIntervalSince1970
                    // Model에 정보 담기
                    var diary: DiaryInfo = DiaryInfo(id: UUID().uuidString, nickName: authViewModel.currentUser?.nickname ?? "Unknown", title: title, content: content, createdAt: createdAt, userId: authViewModel.currentUser?.id ?? "unknownId")
                    if !address.isEmpty {
                        diary.address = address
                        diary.latitude = latitude
                        diary.longitude = longitude
                    }
                    // DB에 일기 데이터 추가 - 비동기 처리
                    await diaryViewModel.addDiary(diary: diary, images: images)
                    // 추가가 다 완료되면 시트 닫기
                    showingSheet.toggle()
                }
            } label: {
                Text("작성 완료")
                    .modifier(MaxWidthColoredButtonModifier(cornerRadius: 15))
            }
            .disabled(trimTitle.count > 0 && trimContent.count > 0 ? false : true)
        } // NavigationStack
    } // body
}

// MARK: - Previews
struct AddDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        AddDiaryView(diaryViewModel: DiaryViewModel(), showingSheet: .constant(false))
    }
}

