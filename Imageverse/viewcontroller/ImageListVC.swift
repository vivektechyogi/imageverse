//
//  ImageListVC.swift
//  Imageverse
//
//  Created by Jai Mataji on 16/10/22.
//

import UIKit

class ImageListVC: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var toggleViewButton: UIButton!
    @IBOutlet weak var searchTextLabel: UILabel!
    
    var isListView = false
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self

    }

    //MARK: Button Action

    @IBAction func toggleButtonClicked(_ sender: Any) {
        toggleViewButton.setImage( UIImage.init(systemName: isListView ? "rectangle.grid.1x2.fill" : "square.grid.2x2.fill"), for: .normal)
        isListView = !isListView
        self.imageCollectionView.reloadData()
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            let nav = UINavigationController(rootViewController: detailViewController)
            // 1
            nav.modalPresentationStyle = .pageSheet

            if let sheet = nav.sheetPresentationController {

                // 3
                sheet.detents = [.medium()]

            }
            // 4
            present(nav, animated: true, completion: nil)
    }
    
}

//MARK: CollectionView Datasource and Delegate
extension ImageListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isListView{
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellL", for: indexPath)
            return cell
        }else{
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellG", for: indexPath)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isListView{
            return CGSize(width: (self.view.frame.size.width), height: 250)
        }else{
            return CGSize(width: (self.view.frame.size.width/2 - 20), height: 250)
        }
    }
}
