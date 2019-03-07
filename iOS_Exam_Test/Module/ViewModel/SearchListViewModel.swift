//
//  SearchListViewModel.swift
//  iOS_Exam_Test
//
//  Created by YeouTimothy on 2019/3/2.
//  Copyright © 2019 Timothy. All rights reserved.
//

///定義存儲的 Key
let UserDefultFavoriteKey = "userDefultFavoriteKey"

import UIKit

class SearchListViewModel{
    let searchService :SearchServiceProtocol
    
    private var searchedList: [SearchedItem] = [SearchedItem]()
    
    private var favoriteList: [SearchedItem] = [SearchedItem]() {
        didSet{
            self.setFavoriteList(favoriteList)
        }
    }
    
    private var cellViewModels :[SearchedItemCellModel] = [SearchedItemCellModel]() {
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    var loadingStatus: String = "" {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( apiService: SearchServiceProtocol = SearchService()){
        self.searchService = apiService
    }
    
    ///網路資料使用
    func initFetch(_ keyword:String, numberPerPage:Int){
        self.searchedList = [SearchedItem]()
        self.getFavoriteList(true)
        searchService.fetchSearchOutcome(keyword, numberPerPage: numberPerPage) {
            (isSuccess, searchedList, error) in
            ///資料首先初始化
            self.searchedList = [SearchedItem]()
            self.cellViewModels = [SearchedItemCellModel]()
            if isSuccess {
                if let searchList = searchedList{
                    self.processSearchedList(searchList)
                    return
                }
            }
        }
    }
    
    ///兩種入口，若為我的最愛頁面則直接觸發轉化過程
    func getFavoriteList(_ isNewSearch: Bool){
        if let favoriteListData = UserDefaults.standard.data(forKey: UserDefultFavoriteKey){
            // Use PropertyListDecoder to convert Data
            guard let favoriteList = try? PropertyListDecoder().decode([SearchedItem].self, from: favoriteListData) else {
                return
            }
            ///資料解析成功
            if (!isNewSearch){
                processSearchedList(favoriteList)
            }
            self.favoriteList = favoriteList
            return
        }else{
            ///無資料
        }
    }
    
    func setFavoriteList(_ favoriteList:[SearchedItem]){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favoriteList), forKey:UserDefultFavoriteKey)
    }
    
    //處理並轉化為 CellViewModel
    func processSearchedList(_ searchedList: [SearchedItem]){
        self.searchedList = searchedList
        var cellViewModels = [SearchedItemCellModel]()
        for contact in searchedList{
            cellViewModels.append(createCellViewModel(contact))
        }
        self.cellViewModels = cellViewModels
    }
    
    func createCellViewModel(_ searchedItem: SearchedItem) -> SearchedItemCellModel{
        return SearchedItemCellModel(
            imageUrl: searchedItem.imageUrl,
            titel: searchedItem.title,
            isLike: favoriteList.contains{(favoriteItem) -> Bool in
                favoriteItem.imageUrl == searchedItem.imageUrl
            })
    }
    
    ///開放給 ViewController 取用
    func getCellViewModel( at indexPath: IndexPath ) -> SearchedItemCellModel {
        return cellViewModels[indexPath.item]
    }
    
    func pressedLike( at indexPath: IndexPath){
        if (cellViewModels[indexPath.item].isLike){
            ///未作反選功能
            return
        }else{
            let cellViewModel = cellViewModels[indexPath.item]
            cellViewModels[indexPath.row] = SearchedItemCellModel(imageUrl: cellViewModel.imageUrl, titel: cellViewModel.titel, isLike: true)
            favoriteList.append(searchedList[indexPath.item])
        }
    }
    
}

struct SearchedItemCellModel {
    let imageUrl :URL
    let titel    :String
    let isLike   :Bool
}
