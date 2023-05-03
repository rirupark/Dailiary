//
//  DetailDiaryView.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/11.
//

import SwiftUI
import MapKit

struct DetailDiaryView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var diaryViewModel: DiaryViewModel
    @State private var address = ""
    @State private var imagesArray: [UIImage] = []
    
    var selectedDiary: DiaryInfo
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(selectedDiary.title)
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    Text(selectedDiary.content)
                        .fontWeight(.light)
                        .font(.subheadline)
                    
                    if imagesArray.count == 1 {
                        HStack {
                            ForEach(imagesArray, id: \.self) { imageId in
                                Image(uiImage: imageId)
                                    .resizable()
                                    .cornerRadius(10)
                                    .scaledToFit()
                                    .frame(maxHeight: 300)
                            } // foreach
                        } // HStack
                    } else {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(imagesArray, id: \.self) { imageId in
                                    Image(uiImage: imageId)
                                        .resizable()
                                        .cornerRadius(10)
                                        .scaledToFit()
                                        .frame(maxHeight: 200)
                                } // foreach
                            } // HStack
                        } // ScrollView Image
                    }

                    if !address.isEmpty {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.accentColor)
                                .font(.subheadline)
                            // 위치 주소 텍스트
                            Text(address)
                                .font(.subheadline)
                                .fontWeight(.light)
                        }
                        .padding(.top, 10)
                        
                        // 위치 지도 보기
                        MapViewHelper()
                            .environmentObject(locationManager)
                            .frame(height: 250)
                            .cornerRadius(10)
                    }
                } // VStack
                .padding(.horizontal, 20)
                
                
                
            } // ScrollView
        } // NavigationStack
        .onAppear {
            // 옵셔널 바인딩 후 이미지 키 저장
            if let images = selectedDiary.images {
                for imageKey in images {
                    if let image = diaryViewModel.dicImage[imageKey] {
                        imagesArray.append(image)
                    }
                } // foreach
            }
            
            // 옵셔널 바인딩 후 주소 저장
            if let addressFromServer = selectedDiary.address {
                address = addressFromServer
            }
            
            // setting Map Region
            locationManager.isDraggable = false
            if let latitude = selectedDiary.latitude, let longitude = selectedDiary.longitude {
                locationManager.pickedLocation = .init(latitude: latitude, longitude: longitude)
                locationManager.mapView.region = .init(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: 1000, longitudinalMeters: 1000)
                locationManager.addPin(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(selectedDiary.createdDate)
    }
}

struct DetailDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DetailDiaryView(diaryViewModel: DiaryViewModel(), selectedDiary: DiaryInfo(id: "FED03BB1-5181-495E-A2FC-513367501047", nickName: "릴루", title: "오늘은 지각 안 함", content: "더 일찍 자야지...", createdAt: 1673592366.1489391, userId: "o645h0lm1xTNNhVA8AMscnrNyOv2"))
    }
}
