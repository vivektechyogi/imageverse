//
//  SearchVC.swift
//  Imageverse
//
//  Created by Jai Mataji on 16/10/22.
//

import UIKit

class SearchVC: BaseVC {
    
    //MARK: Outlets
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var recentSearchCollectionView: UICollectionView!
    
    //this callback will be used as trigger then user enter some text and click search button
    var callback : ((String?) -> Void)?
    let columnLayout = CustomViewFlowLayout()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        recentSearchCollectionView.delegate = self
        recentSearchCollectionView.dataSource = self
        recentSearchCollectionView.collectionViewLayout = columnLayout
        recentSearchCollectionView.contentInsetAdjustmentBehavior = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainBackView.roundCorners(8)
        searchView.setBorder(radius: 25, color: .white)
        searchTextField.text = ""
        searchTextField.becomeFirstResponder()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    //MARK: ButtonActions
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        dismissViewAndTriggerCallback()
    }
    
    
    //MARK: Utiity Function
    
    //on click of search button we trigger callback fucntion which then allow us to get image for user entered query
    //store same string in user preference
    func dismissViewAndTriggerCallback(){
        let text = searchTextField.text ?? ""
        if text == ""{
            self.showAlert(title: "", message: "Kindly enter text to search")
            return
        }
        addToRecentSearch()
        if let cb = callback {
            cb(text)
        }
        self.dismiss(animated: true)
    }
    
    let defaults = UserDefaults.standard
    //storing user search history in user default and using same to list out helps user for fast search
    func getRecentSearchSrtings()->[String]{
        return defaults.stringArray(forKey: "RecentSearchArray") ?? [String]()
    }
    
    func addToRecentSearch(){
        let text = searchTextField.text ?? ""
        var array = getRecentSearchSrtings()
        array.removeAll(where: {$0.lowercased() == text.lowercased()})
        array.append(text)
        defaults.set(array, forKey: "RecentSearchArray")
        recentSearchCollectionView.reloadData()
    }
    
}

//MARK: Textfield delegate
extension SearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        dismissViewAndTriggerCallback()
        return false
    }
}


//MARK: CollectionView Datasource and Delegate
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.getRecentSearchSrtings().count == 0 {
            //check if there are recent search available showing message as "No recent Search, Search Now :)"
            collectionView.setEmptyMessage("No recent Search, Search Now :)")
        } else {
            collectionView.restore()
        }
        return getRecentSearchSrtings().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChipCell", for: indexPath) as! ChipCell
        cell.titleLabel.text = getRecentSearchSrtings()[indexPath.row]
        cell.titleLabel.setBorder(radius: 15,color: .white, width: 3)
        return cell
    }
    
    // when user tap on any chip we trigger callback and fetch images for user selected query
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cb = callback {
            cb(getRecentSearchSrtings()[indexPath.row])
        }
        self.dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let string = getRecentSearchSrtings()[indexPath.row]
        
        // label font.
        let font = UIFont.systemFont(ofSize: 16)
        let fontAttribute = [NSAttributedString.Key.font: font]
        
        // to get the exact width for label according to ur label font and Text.
        let size = string.size(withAttributes: fontAttribute)
        
        // some extraSpace given.
        let extraSpace : CGFloat = 44
        let width = size.width + extraSpace
        return CGSize(width:width, height: 44)
    }
}
