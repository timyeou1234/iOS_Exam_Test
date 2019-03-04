//
//  SearchOutcomeViewController.swift
//  iOS_Exam_Test
//
//  Created by YeouTimothy on 2019/3/1.
//  Copyright © 2019 Timothy. All rights reserved.
//

import UIKit
import SDWebImage

class SearchListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var keyword         :String?
    var numberPerPage   :Int?
    
    lazy var viewModel  : SearchListViewModel = {
        return SearchListViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let keyword = keyword,
              let numberPerPage = numberPerPage
        else {
            print("傳值錯誤")
            return
        }
        self.title = "搜尋結果 \(keyword)"
        
        initViewModel(keyword, numberPerPage: numberPerPage)
        self.setCollectionView()
        // Do any additional setup after loading the view.
    }
    
    func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchedItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchedItemCollectionViewCell")
    }
    
    func initViewModel(_ keyword:String, numberPerPage:Int){
        ///進行資料提取，不做資料初始化
        viewModel.initFetch(keyword, numberPerPage: numberPerPage)
        
        viewModel.reloadTableViewClosure = {
            [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 2
        //                圖片間距 字體  距下方
        let height = width + 8 + 21 + 20
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchedItemCollectionViewCell", for: indexPath) as! SearchedItemCollectionViewCell
        let cellModel = viewModel.getCellViewModel(at: indexPath)
        cell.titleLabel.text = cellModel.titel
        cell.photoImageView.sd_setImage(with: cellModel.imageUrl, completed: nil)
        return cell
    }
    
}
