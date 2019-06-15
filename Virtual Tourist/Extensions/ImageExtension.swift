//
//  ImageExtension.swift
//  Virtual Tourist
//
//  Created by KHALID ALSUBAIE on 15/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

extension Image {
    
    func setImage(image: UIImage) {
        self.imageBinary = image.pngData()
    }
    
    func getImage() -> UIImage? {
        return (imageBinary == nil) ? nil : UIImage(data: imageBinary!)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
}
