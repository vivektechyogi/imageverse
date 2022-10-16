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
    
    @IBOutlet weak var recentSearchCollectionView: UICollectionView!
    //this callback will be used as trigger then user enter some text and click search button
    var callback : ((String?) -> Void)?
    let columnLayout = CustomViewFlowLayout()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recentSearchCollectionView.delegate = self
        recentSearchCollectionView.dataSource = self
        recentSearchCollectionView.collectionViewLayout = columnLayout
        recentSearchCollectionView.contentInsetAdjustmentBehavior = .always
        searchTextField.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainBackView.roundCorners(8)
        searchTextField.becomeFirstResponder()
    }
    
    
    //MARK: ButtonActions
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        let text = searchTextField.text ?? ""
        if text == ""{
            return
        }
        addToRecentSearc()
        if let cb = callback {
            cb(text)
        }
        self.dismiss(animated: true)
        
    }
    
    
    //MARK: Utiity Function
    
    let defaults = UserDefaults.standard
    func getRecentSearchSrtings()->[String]{
        return defaults.stringArray(forKey: "RecentSearchArray") ?? [String]()
    }
    
    func addToRecentSearc(){
        let text = searchTextField.text ?? ""
        var array = getRecentSearchSrtings()
        array.removeAll(where: {$0.lowercased() == text.lowercased()})
        array.append(text)
        defaults.set(array, forKey: "RecentSearchArray")
        recentSearchCollectionView.reloadData()
    }
    
}


//MARK: CollectionView Datasource and Delegate
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getRecentSearchSrtings().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChipCell", for: indexPath) as! ChipCell
        cell.titleLabel.text = getRecentSearchSrtings()[indexPath.row]
        cell.titleLabel.setBorder(radius: 15,color: .white, width: 3)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cb = callback {
            cb(getRecentSearchSrtings()[indexPath.row])
        }
        self.dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let string = getRecentSearchSrtings()[indexPath.row]

        // your label font.
        let font = UIFont.systemFont(ofSize: 16)
        let fontAttribute = [NSAttributedString.Key.font: font]

        // to get the exact width for label according to ur label font and Text.
        let size = string.size(withAttributes: fontAttribute)

        // some extraSpace give if like so.
        let extraSpace : CGFloat = 44
        let width = size.width + extraSpace
        return CGSize(width:width, height: 44)
    }
}
