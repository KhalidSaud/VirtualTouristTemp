//
//  ConstantData.swift
//  Virtual Tourist
//
//  Created by KHALID ALSUBAIE on 15/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation

struct ConstantData {
    
    struct FlickerConstants {
        
        static let FlickerScheme = "https"
        static let FlickerHost = "api.flickr.com"
        static let FlickerApiPath = "/services/rest"
        static let BoundBoxWidth = 1.0
        static let BoundBoxHeight = 1.0
        static let SearchLatitudeRange = (-90.0, 90.0)
        static let SearchLogitudeRange = (-180.0, 180.0)
        
    }
    
    struct FlickerValues {
        
        static let Method = "flickr.photos.search"
        static let APIKey = "4a37f645e7c7fa0f5be0c5e36c9c4b98"
        static let Format = "json"
        static let DisablingJsonCallBack = "1"
        static let GalleryImagesMethod = "flickr.galleries.getPhotos"
        static let MediumUrl = "url_m"
        static let EnablingSafeSearch = "1"
        static let PerPage = "12"
        
    }
    
    struct FlickerParameters {
        
        static let Method = "method"
        static let ApiKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJsonCallBack = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoudingBox = "bbox"
        static let Page = "page"
        static let PerPage = "per_page"
        
    }
    
}
