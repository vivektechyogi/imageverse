//
//  extension.swift
//  Imageverse
//
//  Created by Jai Mataji on 16/10/22.
//

import UIKit
import Kingfisher

//Extension for adding radius to view
extension UIView {
    public func roundCorners(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func setBorder(radius:CGFloat, color:UIColor = UIColor.clear, width: CGFloat = 1) -> UIView{
        var roundView:UIView = self
        roundView.layer.cornerRadius = CGFloat(radius)
        roundView.layer.borderWidth = width
        roundView.layer.borderColor = color.cgColor
        roundView.clipsToBounds = true
        return roundView
    }
}

//Extension for setting image to image view using kingfisher, will set placeholderimage and loader until the image is dowloading.
extension UIImageView {
    func setImage(url:String){
        let processor = DownsamplingImageProcessor(size:self.bounds.size)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: URL(string:url),
            placeholder: UIImage(named: "placeholder-image"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}

//Extension for adding no data found when data for collection view is empty
extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}

class CustomViewFlowLayout: UICollectionViewFlowLayout {

let cellSpacing:CGFloat = 4

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            self.minimumLineSpacing = 4.0
            self.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 6)
            let attributes = super.layoutAttributesForElements(in: rect)

            var leftMargin = sectionInset.left
            var maxY: CGFloat = -1.0
            attributes?.forEach { layoutAttribute in
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + cellSpacing
                maxY = max(layoutAttribute.frame.maxY , maxY)
            }
            return attributes
    }
}
