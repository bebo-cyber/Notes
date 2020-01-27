//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Sandeep Kumar on 1/26/20.
//  Copyright © 2020 Sandeep Kumar. All rights reserved.
//

import UIKit

extension Date {
 
    func toString() -> String {
        let df = DateFormatter()
        df.dateFormat = "MMMM DD, yyyy hh:mm a"
        return df.string(from: self)
    }
}

extension String {
    func showAlert(_ vc: UIViewController) {
        let alert = UIAlertController(title: "Error!!!", message: self, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}

class NoteTableViewCell: UITableViewCell {

    @IBOutlet var lblSubject: UILabel!
    @IBOutlet var lblContent: UILabel!
    @IBOutlet var lblDate: UILabel!

    var objNote: Note? {
        didSet {
            lblSubject.text = objNote?.subject
            lblContent.text = objNote?.content
            lblDate.text = objNote?.createdAt?.toString()
        }
    }
    
}
