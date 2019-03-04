//
//  SearchService.swift
//  
//
//  Created by YeouTimothy on 2019/3/2.
//

import UIKit
import Alamofire

enum APIError: String, Error {
    case loading        = "載入中"
    case networlFailed  = "網路請求失敗，請點擊右上角刷新"
    case decodeFailed   = "資料解析錯誤，請點擊右上角刷新"
}

protocol SearchServiceProtocol{
    func fetchSearchOutcome(_ keyword:String, numberPerPage:Int, complete: @escaping ( _ success: Bool, _ items: [SearchedItem]?, _ error: APIError? )->() )
}

class SearchService: SearchServiceProtocol {
    
    var searchedList:[SearchedItem]?
    
    func fetchSearchOutcome(_ keyword: String, numberPerPage: Int, complete: @escaping (Bool, [SearchedItem]?, APIError?) -> ()) {
        let params: Parameters =
            ["method"  : "flickr.photos.search",
             "api_key" : "46925be2c40f9b580861c773ecff41be",
             "format"  : "json",
             "nojsoncallback": 1,
             "text"    : keyword,
             "perPage" : numberPerPage]
        
        Alamofire.request( "https://api.flickr.com/services/rest", method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let _ = response.error{
                ///獲取失敗，網路錯誤
                complete(false, nil, APIError.networlFailed)
                return
            }
            
            if let _ = response.result.value{
                guard let searchedList = self.decodeJsonData(response)
                    else{
                        ///資料解析失敗
                        complete(false, nil, APIError.decodeFailed)
                        return
                }
                ///資料解析成功，回傳資料
                complete(true, searchedList, nil)
            }
        }
    }
    
    ///資料解析
    func decodeJsonData(_ response: DataResponse<Any>) -> [SearchedItem]?{
        guard let json: NSDictionary = response.result.value as? NSDictionary,
              let photosList: NSDictionary = json["photos"] as? NSDictionary,
              let photos = photosList["photo"] as? [Any]
        else {
            ///資料格式不符合預期
            return nil
        }
        do{
            let photosData = try JSONSerialization.data(withJSONObject: photos, options: [])
            let decoder = JSONDecoder()
            do{
                ///資料解析成功
                let searchedList = try decoder.decode([SearchedItem].self, from: photosData)
                return searchedList
            }catch{
                ///映射失敗
                print("Error \(error)")
                return nil
            }
        }catch{
            ///序列化失敗
            return nil
        }
        
    }

}
