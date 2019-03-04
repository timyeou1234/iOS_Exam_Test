//
//  SerchedItem.swift
//  iOS_Exam_Test
//
//  Created by YeouTimothy on 2019/3/2.
//  Copyright © 2019 Timothy. All rights reserved.
//

import UIKit

struct SearchedItem: Codable {
    let farm    : Int
    let secret  : String
    let id      : String
    let server  : String
    let title   : String
    ///存儲該圖片的網路位置
    var imageUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
    
}
