//
//  ViewController.swift
//  iOS_Exam_Test
//
//  Created by YeouTimothy on 2019/3/1.
//  Copyright © 2019 Timothy. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController{
    
    @IBOutlet weak var searchContextTextField: UITextField!
    @IBOutlet weak var numberPerPageTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var searchContext: String?
    var numberPerPage: Int?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchContextTextField.delegate = self
        numberPerPageTextField.delegate = self
        
        ///設定搜尋按鈕背景顏色（根據狀態改變）
        searchButton.setBackgroundColor(UIColor.lightGray, forState: .disabled)
        searchButton.setBackgroundColor(UIColor.blue, forState: .normal)
        ///預設關閉（無資料填入）
        searchButton.isEnabled = false
    }
    
    func isSearchingValid() -> Bool {
        guard let searchContext = searchContextTextField.text,
              let _ = numberPerPageTextField.text,
              let numberPerPage = Int(numberPerPageTextField.text!)
        else {
            return false
        }
        self.searchContext = searchContext
        self.numberPerPage = numberPerPage
        return searchContext.count > 0 && numberPerPage > 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationController: SearchListViewController = segue.destination as? SearchListViewController
            else {
            ///segue 錯誤指定
            return
        }
        destinationController.keyword = self.searchContext
        destinationController.numberPerPage = self.numberPerPage
    }

}

extension SearchViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        ///判斷是否可以點擊
        searchButton.isEnabled = isSearchingValid()
        return true
    }
    
}
