//
//  FavoriteViewController.swift
//  iOS_Exam_Test
//
//  Created by YeouTimothy on 2019/3/4.
//  Copyright © 2019 Timothy. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var viewModel  : SearchListViewModel = {
        return SearchListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshViewModel()
    }
    
    func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchedItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchedItemCollectionViewCell")
    }
    
    func refreshViewModel(){
        viewModel.getFavoriteList(false)
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

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
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
        cell.favoriteButton.isSelected = true
        return cell
    }
    
}

