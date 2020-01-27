//
//  AddCollectionViewCell.swift
//  Notes
//
//  Created by Sandeep Kumar on 1/25/20.
//  Copyright © 2020 Sandeep Kumar. All rights reserved.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell {
    @IBOutlet var btn: UIButton! {
        didSet {
            btn.layer.borderColor = #colorLiteral(red: 0.08235294118, green: 0.6, blue: 0.7294117647, alpha: 1)
        }
    }

}
