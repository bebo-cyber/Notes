//
//  ImagePickerManager.swift
//  EjariNow
//
//  Created by Apple on 06/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
typealias MultipartCallBack = ((_ file: UIImage?) -> Void)

class ImagePickerManager: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var callBack: MultipartCallBack?
    var imagePicker = UIImagePickerController()
    
    override init() { }
    
    func select(vc: UIViewController, isEditing: Bool = false, fileCallBack: @escaping MultipartCallBack) {
        self.imagePicker.delegate = self
        self.callBack = fileCallBack
        let alert = UIAlertController(title: "Please Choose", message: "", preferredStyle: .actionSheet)
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.galery(vc, isEditing: isEditing)
        }
        alert.addAction(gallery)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.camera(vc, isEditing: isEditing)
            }
            alert.addAction(camera)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            (action) in
            
        }
        
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    
    // MARK: image from gallery
    private func galery(_ vc: UIViewController, isEditing: Bool = false) {
        
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = isEditing
        vc.present(self.imagePicker, animated: true, completion: nil)
    }
    
    // MARK: image from camera
    private func camera (_ vc: UIViewController, isEditing: Bool = false) {
        self.imagePicker.sourceType = .camera
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = isEditing
        vc.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var imagePicked: UIImage!
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imagePicked = pickedImage
        } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePicked = pickedImage
        }
        picker.dismiss(animated: true) {
            
        }
        picker.dismiss(animated: true) {
            [weak self] in
            guard let self = self else { return }
            self.callBack?(imagePicked)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
