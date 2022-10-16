//
//  ImageListVC.swift
//  Imageverse
//
//  Created by Jai Mataji on 16/10/22.
//

import UIKit

class ImageListVC: BaseVC {
    
    //MARK: Outlets
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var toggleViewButton: UIButton!
    @IBOutlet weak var searchTextLabel: UILabel!
    
    var isListView = true
    var isAPICalling = false
    var imageData: [ImageData] = []
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        openSearchView()
    }
    
    //MARK: API Call to get image data
    func getImageDataFor(text:String){
        self.showActivityIndicator()
        self.isAPICalling = true
        self.searchTextLabel.text = "Search result for \(text)"
        APIManager.getImgaesForSearch(text: text).responseDecodable(of: ImageDataModel.self) { response in
            self.hideActivityIndicator()
            self.isAPICalling = false
            self.imageData = response.value?.data ?? []
            self.imageCollectionView.reloadData()
        }
    }
    
    //to open search view where user can enter search text and view recent search
    func openSearchView(){
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        searchVC.callback = {
            text in
            self.getImageDataFor(text: text ?? "")
        }
        let nav = UINavigationController(rootViewController: searchVC)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(nav, animated: true, completion: nil)
    }
    
    
    //MARK: Button Action
    
    @IBAction func toggleButtonClicked(_ sender: Any) {
        toggleViewButton.setImage( UIImage.init(systemName: isListView ? "rectangle.grid.1x2.fill" : "square.grid.2x2.fill"), for: .normal)
        isListView = !isListView
        self.imageCollectionView.reloadData()
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        openSearchView()
    }
    
}

//MARK: CollectionView Datasource and Delegate
extension ImageListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.imageData.count == 0) {
            
            collectionView.setEmptyMessage(isAPICalling ? "Fetching Data" : "Nothing to show :(")
            } else {
                collectionView.restore()
            }
        
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageData = imageData[indexPath.row]
        if isListView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellL", for: indexPath) as! ImageCell
            cell.roundCorners(20)
            let url = imageData.images?.first?.link ?? ""
            cell.imageView.setImage(url: url)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellG", for: indexPath) as! ImageCell
            cell.roundCorners(20)
            let url = imageData.images?.first?.link ?? ""
            cell.imageView.setImage(url: url)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isListView{
            return CGSize(width: (collectionView.frame.size.width), height: 200)
        }else{
            return CGSize(width: (collectionView.frame.size.width/2 - 4), height: 250)
        }
    }
}
