//
//  DiaryInfo.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/10.
//

import Foundation
import UIKit

struct DiaryInfo: Codable, Identifiable {
    var id: String
    var nickName: String
    var title: String
    var content: String
    var createdAt: Double
    var userId: String
    var images: [String]?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    //var weather: String
    
    var createdDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일" // "yyyy-MM-dd HH:mm:ss"
        
        let dateCreatedAt = Date(timeIntervalSince1970: createdAt)
        
        return dateFormatter.string(from: dateCreatedAt)
    }
    
//    var textForSharing: String {
//        return "\(title)\n\(nickName)\n\(createdDate)"
//    }
}


//struct DiaryImage: Identifiable, Hashable {
//    var id: String
//    var image: UIImage
//    var imageName: String
//}
