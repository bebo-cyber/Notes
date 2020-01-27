//
//  ImageViewerVC.swift
//  Notes
//
//  Created by Sandeep Kumar on 1/25/20.
//  Copyright © 2020 Sandeep Kumar. All rights reserved.
//

import UIKit

class ImageViewerVC: UIViewController, UIScrollViewDelegate {

    var image: UIImage?
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image  = image
        imageView.frame = .init(x: 0, y: 0, width: image?.size.width ?? 0, height: image?.size.height ?? 0)
        scrollView.contentSize = imageView.frame.size
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
//        scrollView.zoomScale = UIScreen.main.bounds.width/imageView.frame.size.width
//
//
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
