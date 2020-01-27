//
//  ImageCollectionViewCell.swift
//  Notes
//
//  Created by Sandeep Kumar on 1/25/20.
//  Copyright © 2020 Sandeep Kumar. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    var blockRemove: ((ImageOriginal) -> ())?
    @IBOutlet var imageView: UIImageView!
    
    var objImage: ImageOriginal? {
        didSet {
            if let data = objImage?.image {
                imageView.image = UIImage(data: data)
            } else {
                imageView.image = nil
            }
        }
    }
    
    @IBAction func didTabDeletee(_ sender: Any) {
        guard let objImage = objImage else {
            return
        }
        blockRemove?(objImage)
    }
}
