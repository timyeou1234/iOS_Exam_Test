//
//  SearchListViewModel.swift
//  iOS_Exam_Test
//
//  Created by YeouTimothy on 2019/3/2.
//  Copyright © 2019 Timothy. All rights reserved.
//

import UIKit

class SearchListViewModel{
    let searchService :SearchServiceProtocol
    
    private var searchedList: [SearchedItem] = [SearchedItem]()
    
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
    
    func initFetch(_ keyword:String, numberPerPage:Int){
        self.searchedList = [SearchedItem]()
        
        searchService.fetchSearchOutcome(keyword, numberPerPage: numberPerPage) {
            (isSuccess, searchedList, error) in
            ///資料首先初始化
            self.searchedList = [SearchedItem]()
            self.cellViewModels = [SearchedItemCellModel]()
            if isSuccess {
                if let searchList = searchedList{
                    self.processContactList(searchList)
                    return
                }
            }
        }
    }
    
    //處理並轉化為 CellViewModel
    func processContactList(_ searchedList: [SearchedItem]){
        self.searchedList = searchedList
        var cellViewModels = [SearchedItemCellModel]()
        for contact in searchedList{
            cellViewModels.append(createCellViewModel(contact))
        }
        self.cellViewModels = cellViewModels
    }
    
    func createCellViewModel(_ searchedItem: SearchedItem) -> SearchedItemCellModel{
        return SearchedItemCellModel(imageUrl:searchedItem.imageUrl, titel: searchedItem.title)
    }
    
    ///開放給 ViewController 取用
    func getCellViewModel( at indexPath: IndexPath ) -> SearchedItemCellModel {
        return cellViewModels[indexPath.row]
    }
    
}

struct SearchedItemCellModel {
    let imageUrl :URL
    let titel    :String
}
