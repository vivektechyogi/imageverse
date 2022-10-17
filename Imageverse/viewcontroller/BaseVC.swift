//
//  BaseVC.swift
//  Imageverse
//
//  Created by Jai Mataji on 16/10/22.
//

import UIKit

class BaseVC: UIViewController {
    
    var activityView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //acitivty indicator can we used on call where basevc is used
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
    //showAlert can we used on call where basevc is used
    func showAlert(title: String?, message: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let alert = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
