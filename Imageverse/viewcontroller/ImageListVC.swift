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
    @IBOutlet weak var toggleButtom: UIButton!
    @IBOutlet weak var searchView: UIView!
    
    var isListView = true
    var isAPICalling = false
    var imageDataArray: [ImageData] = []
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        searchView.setBorder(radius: 25, color: .white)
        toggleButtom.setBorder(radius: 25, color: .white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        openSearchView()
    }
    
    
    //MARK: Button Action
    
    @IBAction func toggleButtonClicked(_ sender: Any) {
        if self.imageDataArray.count > 0 {
            toggleViewButton.changeImageAnimated(image: UIImage.init(systemName: isListView ? "rectangle.grid.1x2.fill" : "square.grid.2x2.fill"))
            isListView = !isListView
            
            self.imageCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
            self.imageCollectionView.reloadData()
        }
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        openSearchView()
    }
    
}

extension ImageListVC{
    
    //MARK: API Call to get image data
    func getImageDataFor(text:String){
        self.imageDataArray = []
        self.imageCollectionView.reloadData()
        self.searchTextLabel.text = "Search result for \(text)"
        
        if !Reachability.isConnectedToNetwork(){
            self.showAlert(title: "No Internet Connection", message: "Make sure your device is connected to the internet.")
            return
        }
        callSearchImageAPIfor(text:text)
    }
    
    //MARK: API Call to get image data
    func callSearchImageAPIfor(text:String){
        self.showActivityIndicator()
        self.isAPICalling = true
        self.imageCollectionView.reloadData()
        
        APIManager.getImgaesForSearch(text: text).responseDecodable(of: ImageDataModel.self) { response in
            self.hideActivityIndicator()
            self.isAPICalling = false
            self.imageDataArray = []
            if let dataArray = response.value?.data{
                for data in dataArray{
                    let isImage = (data.images?.first?.type ?? "").contains("image")
                    if isImage{
                        self.imageDataArray.append(data)
                    }
                }
            }
            self.imageCollectionView.reloadData()
        }
    }
    
    //to open search view where user can enter search text and view recent search
    func openSearchView(){
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        
        //once we get trigger to callback we call getimage api for user entered text
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
}

//MARK: CollectionView Datasource and Delegate
extension ImageListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imageDataArray.count == 0 {
            //check if calling api, if api call in pregress showing message as "Fetching Data"
            //check for connectivity if user not connected to inter showing error message "No Internet Connection \nMake sure your device is connected to the internet."
            //check if there are any images available for user search query if noe image available showing message as "Nothing to show :("
            collectionView.setEmptyMessage(isAPICalling ? "Fetching Data" : !Reachability.isConnectedToNetwork() ? "No Internet Connection \nMake sure your device is connected to the internet." : "Nothing to show :(")
        } else {
            collectionView.restore()
        }
        return imageDataArray.count
    }
    
    // using variable isListView we identity if user has selected for which view
    //if isListView == true then using cell as "ImageCellL"
    //if isListView == false then using cell as "ImageCellG"
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageData = imageDataArray[indexPath.row]
        if isListView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellL", for: indexPath) as! ImageCell
            return getImageCell(cell: cell, imageData:imageData)
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellG", for: indexPath) as! ImageCell
            return getImageCell(cell: cell, imageData:imageData)
        }
    }
    
    //function to set all data to cell and ui formating
    func getImageCell(cell: ImageCell, imageData:ImageData) -> ImageCell{
        cell.roundCorners(20)
        cell.countLabel.roundCorners(10)
        
        cell.countLabel.isHidden = true
        
        let url = imageData.images?.first?.link ?? ""
        cell.imageView.setImage(url: url)
        cell.titleLabel.text = imageData.title ?? ""
        if let count = imageData.imagesCount {
            cell.countLabel.isHidden = count <= 1
            cell.countLabel.text = "1 / \(imageData.imagesCount ?? 0)"
        }
        cell.dateLabel.text = (imageData.datetime ?? 0).getDateStringFromUnixTime()
        return cell
    }
    
    // using variable isListView we identity if user has selected for which view
    //if isListView == true then using cgsize as (width: (collectionView.frame.size.width), height: 200)"
    //if isListView == false then using cgsize as (width: (collectionView.frame.size.width/2 - 4), height: 250)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isListView{
            return CGSize(width: (collectionView.frame.size.width), height: 200)
        }else{
            return CGSize(width: (collectionView.frame.size.width/2 - 4), height: 250)
        }
    }
}
