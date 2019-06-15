//
//  CustomImageCellView.swift
//  Virtual Tourist
//
//  Created by KHALID ALSUBAIE on 15/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

protocol CustomImageViewDelegate {
    func imageDidDownload()
}

let imagesCache = NSCache<NSString, AnyObject>()

class CustomImageCellView: UIImageView {
    
    var imageURL: URL!
    
    func setImage(_ newImage: Image) {
        if photo != nil {
            return
        }
        photo = newImage
    }
    
    private var photo: Image! {
        didSet {
            if let image = photo.getImage() {
                hideActivityIndicatorView()
                self.image = image
                return
            }
            
            guard let url = photo.imgUrl else {
                return
            }
            
            loadCachedImages(url: url)
        }
    }
    
    func loadCachedImages(url: URL) {
        
        imageURL = url
        image = nil
        showActivityIndicatorView()
        
        if let cachedImage = imagesCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            image = cachedImage
            hideActivityIndicatorView()
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let downloadedImage = UIImage(data: data!) else { return }
            imagesCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                self.image = downloadedImage
                self.photo.setImage(image: downloadedImage)
                try? self.photo.managedObjectContext?.save()
                self.hideActivityIndicatorView()
            }
        }.resume()
        
    }
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        self.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicatorView.color = .black
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    func showActivityIndicatorView() {
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func hideActivityIndicatorView() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
}
