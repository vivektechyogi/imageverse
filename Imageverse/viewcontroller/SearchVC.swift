//
//  SearchVC.swift
//  Imageverse
//
//  Created by Jai Mataji on 16/10/22.
//

import UIKit

class SearchVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var searchTextField: UITextField!
    
    //this callback will be used as trigger then user enter some text and click search button
    var callback : ((String?) -> Void)?
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.text = ""
    }
    
    
    //MARK: ButtonActions
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        let text = searchTextField.text ?? ""
        if text == ""{
            return
        }
        self.dismiss(animated: true)
        if let cb = callback {
            cb(text)
        }
    }
    
}
