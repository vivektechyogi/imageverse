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
