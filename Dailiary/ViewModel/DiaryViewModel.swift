//
//  DiaryViewModel.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/10.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

class DiaryViewModel: ObservableObject {
    // MARK: - Property Wrappers
    @Published var diaryInfos: [DiaryInfo] = []
    @Published var dicImage: [String : UIImage] = [:]

    // MARK: - Properties
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    // MARK: - Init Method
    init() {
        diaryInfos = []
    }
    
    // MARK: - 서버에서 Diary Collection의 데이터들을 불러오는 Method
    func fetchDiaries() {
        database.collection("Diary")
            .order(by: "createdAt", descending: true)
            .getDocuments { (snapshot, error) in
                self.diaryInfos.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        
                        let docData = document.data()
                        let title: String = docData["title"] as? String ?? ""
                        let content: String = docData["content"] as? String ?? ""
                        let userNickName: String = docData["nickName"] as? String ?? ""
                        let createdAt: Double = docData["createdAt"] as? Double ?? 0
                        let userId: String = docData["userId"] as? String ?? ""
                        let images: [String] = docData["images"] as? [String] ?? []
                        let address: String = docData["address"] as? String ?? ""
                        let latitude: Double = docData["latitude"] as? Double ?? 0.0
                        let longitude: Double = docData["longitude"] as? Double ?? 0.0
                        
                        // fetch image set
                        for imageName in images {
                            self.fetchImage(diaryId: id, imageName: imageName)
                        }
                        
                        let diary: DiaryInfo = DiaryInfo(id: id, nickName: userNickName, title: title, content: content, createdAt: createdAt, userId: userId, images: images, address: address, latitude: latitude, longitude: longitude)
                        
                        self.diaryInfos.append(diary)
                    }
                }
            }
    }
    
    // MARK: - 서버의 Diary Collection에 Diary 객체 하나를 추가하여 업로드하는 Method
    func addDiary(diary: DiaryInfo, images: [UIImage]) async {
        do {
            // create image name list
            var imgNameList: [String] = []
            
            // ** uploadImage 함수 실행이 다 끝나기 전에 디비에 setData 될 수 있음 **
            // iterate over images
            for img in images {
                let imgName = UUID().uuidString
                imgNameList.append(imgName)
                uploadImage(image: img, name: (diary.id + "/" + imgName))
            }
            
            // 위치 설정을 했을 경우
            if let address = diary.address, let latitude = diary.latitude, let longitude = diary.longitude {
                try await database.collection("Diary")
                    .document(diary.id)
                    .setData(["nickName": diary.nickName,
                              "title": diary.title,
                              "content": diary.content,
                              "createdAt": diary.createdAt,
                              "userId": diary.userId,
                              "images": imgNameList,
                              "address": address,
                              "latitude": latitude,
                              "longitude": longitude])
            } else {
                try await database.collection("Diary")
                    .document(diary.id)
                    .setData(["nickName": diary.nickName,
                              "title": diary.title,
                              "content": diary.content,
                              "createdAt": diary.createdAt,
                              "userId": diary.userId,
                              "images": imgNameList])
            }
            
            fetchDiaries()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    

    
    // MARK: - 서버의 Diary Collection에서 Diary 객체 하나를 삭제하는 Method
    func removeDiary(diary: DiaryInfo) {
        database.collection("Diary")
            .document(diary.id).delete()

        // remove photos from storage
        if let images = diary.images {
            for image in images {
                let imagesRef = storage.reference().child("images/\(diary.id)/\(image)")
                imagesRef.delete { error in
                    if let error = error {
                        print("Error removing image from storage\n\(error.localizedDescription)")
                    } else {
                        print("images directory deleted successfully")
                    }
                }
            }
        }
        
        fetchDiaries()
    }
    
    // MARK: - 서버의 Storage에서 이미지를 가져오는 Method
    func fetchImage(diaryId: String, imageName: String) {
        let ref = storage.reference().child("images/\(diaryId)/\(imageName)")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        // maxSize 크게 해도 문제 없음. 이유 모름.
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.dicImage[imageName] = image
            }
        }
    }
    
    
    // MARK: - 서버의 Storage에 이미지를 업로드하는 Method
    func uploadImage(image: UIImage, name: String) {
        let storageRef = storage.reference().child("images/\(name)")
        let data = image.jpegData(compressionQuality: 0.1)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // uploda data
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, err) in
                if let err = err {
                    print("err when uploading jpg\n\(err)")
                }
                
                if let metadata = metadata {
                    print("metadata: \(metadata)")
                }
            }
        }
        
    }
}


// MARK: - 이미지의 높이에 맞게 이미지의 사이즈를 변경해주는 익스텐션
extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
