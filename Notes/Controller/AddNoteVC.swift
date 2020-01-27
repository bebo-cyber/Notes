//
//  AddNoteVC.swift
//  Notes
//
//  Created by Sandeep Kumar on 1/25/20.
//  Copyright © 2020 Sandeep Kumar. All rights reserved.
//

import UIKit

class AddNoteVC: UIViewController {
    
    var blockDone: (() -> ())?

    var objNote: Note?
    
    @IBOutlet var collectionViewImages: UICollectionView!

    @IBOutlet var constraintBottomContent: NSLayoutConstraint!
    @IBOutlet var textSubject: UITextField!
    @IBOutlet var textContent: UITextView!
    
    lazy var imagePicker: ImagePickerManager = {
        return ImagePickerManager()
    }()
    
    lazy var btnDone: UIToolbar = {
        let tool = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        tool.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(didTabDone(_:)))]
        return tool
    }()
    
    var arrayImages: [ImageOriginal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if objNote == nil {
            objNote = Note(context: AppDelegate.shared.managedObjectContainer)
            objNote?.createdAt = Date()
        }
        textSubject.text = objNote?.subject ?? ""
        textContent.text = objNote?.content ?? ""
        reloadCollection()

//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        textSubject.inputAccessoryView = btnDone
        textContent.inputAccessoryView = btnDone
    }
    
    deinit {
        guard let objNote = objNote else { return }
        
        NotificationCenter.default.removeObserver(self)
        
        if objNote.subject == nil && objNote.content == nil {
            AppDelegate.shared.managedObjectContainer.delete(objNote)
        }
    }
    
    @IBAction func didTabAddImage() {
        imagePicker.select(vc: self, isEditing: true) {
            [weak self] (image) in
            guard let self = self else { return }
            
            if let data = image?.pngData() {
                let img = ImageOriginal(context: AppDelegate.shared.managedObjectContainer)
                img.image = data
                
                self.objNote?.addToImages(img)
                self.reloadCollection()
            }
        }
    }

    func reloadCollection() {
        
        arrayImages = (objNote?.images?.allObjects as? [ImageOriginal]) ?? []
        collectionViewImages.dataSource = self
        collectionViewImages.delegate = self
        collectionViewImages.reloadData()
    }
    
    @IBAction func keyboardDidHide(_ sender: Notification) {
        constraintBottomContent.constant = 16
        view.layoutIfNeeded()
    }
    
    @IBAction func keyboardDidShow(_ sender: Notification) {
        let height = ((sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height) ?? 0.0
        constraintBottomContent.constant = height+16
        view.layoutIfNeeded()
    }
    
    @IBAction func didTabSave(_ sender: Any) {
        
        let subject = textSubject?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let content = textContent?.text ?? ""
        
        if subject.isEmpty {
            "Please Enter Subject".showAlert(self)
            return
        }
        
        if content.isEmpty {
            "Please Enter Note Content".showAlert(self)
            return
        }
        
        objNote?.subject = subject
        objNote?.content = content
            
        AppDelegate.shared.saveContext()
        blockDone?()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTabDone(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
}

extension AddNoteVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImages.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if arrayImages.count == indexPath.row {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellAdd", for: indexPath) as! AddCollectionViewCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        cell.objImage = arrayImages[indexPath.row]
        cell.blockRemove = {
            [weak self] obj in
            guard let self = self else { return }
            self.objNote?.removeFromImages(obj)
            AppDelegate.shared.managedObjectContainer.delete(obj)
            self.reloadCollection()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if arrayImages.count == indexPath.row {
            didTabAddImage()
        } else if let imageView = (collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.imageView {
            let imageInfo      = ImageInfo(image: imageView.image!, imageMode: .aspectFill)
            let transitionInfo = TransitionInfo(fromView: imageView)
            let imageViewer    = ImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            present(imageViewer, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: arrayImages.count == indexPath.row ? 40 : 80, height: 92)
    }
    
    
}
extension UIViewController {
    
    func save(image: UIImage?, _ block: ((String?) -> ())?) {
        guard let image = image else { return }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("\(Int(Date().timeIntervalSince1970)).png")
        if let pngImageData = image.pngData() {
            do {
                try pngImageData.write(to: fileURL, options: .atomic)
                block?(fileURL.absoluteString)
            } catch {
                block?(nil)
            }
        }
        
    }
}
