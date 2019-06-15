//
//  API.swift
//  Virtual Tourist
//
//  Created by KHALID ALSUBAIE on 15/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit
import MapKit

struct API {
    
    
    static func ImagesURLs(coord: CLLocationCoordinate2D, pageNum: Int, completion: @escaping ([URL]?, Error?, String?) -> ()) {
        
        let Urlparams = [
            ConstantData.FlickerParameters.Method: ConstantData.FlickerValues.Method,
            ConstantData.FlickerParameters.ApiKey: ConstantData.FlickerValues.APIKey,
            ConstantData.FlickerParameters.BoudingBox: GetBoundingBox(coord: coord),
            ConstantData.FlickerParameters.SafeSearch: ConstantData.FlickerValues.EnablingSafeSearch,
            ConstantData.FlickerParameters.Extras: ConstantData.FlickerValues.MediumUrl,
            ConstantData.FlickerParameters.Format: ConstantData.FlickerValues.Format,
            ConstantData.FlickerParameters.NoJsonCallBack: ConstantData.FlickerValues.DisablingJsonCallBack,
            ConstantData.FlickerParameters.Page: pageNum,
            ConstantData.FlickerParameters.PerPage: ConstantData.FlickerValues.PerPage,
        ] as [String : Any]
        
        print(getFlickerApiUrl(params: Urlparams))
        
        let request = URLRequest(url: getFlickerApiUrl(params: Urlparams))
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                print("Error 1")
                completion(nil, nil, error!.localizedDescription)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil, nil, "Your status code is \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return
            }
            
            guard let data = data else {
                completion(nil, nil, "No Data Found!")
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                completion(nil, nil, "JSON was not parsed")
                return
            }
            
            guard let status = result["stat"] as? String, status == "ok" else {
                completion(nil, nil, "Status = \(result)")
                return
            }
            
            guard let imagesDictionary = result["photos"] as? [String: Any] else {
                completion(nil, nil, "Could not find photos key in \(result)")
                return
            }
            
            guard let images = imagesDictionary["photo"] as? [[String: Any]] else {
                completion(nil, nil, "Could not find photo key in \(imagesDictionary)")
                return
            }
            
            let imagesUrls = images.compactMap{ imagesDictionary -> URL? in
                
                guard let imageUrl = imagesDictionary["url_m"] as? String else {
                    return nil
                }
                
                return URL(string: imageUrl)
            }
            
            completion(imagesUrls, nil, nil)
        }
        
        task.resume()
    }
    
    
    static func GetBoundingBox(coord: CLLocationCoordinate2D) -> String {
        
        let lat = coord.latitude
        let long = coord.longitude
        
        
        let maxLat = min(lat + ConstantData.FlickerConstants.BoundBoxHeight, ConstantData.FlickerConstants.SearchLatitudeRange.1)
        let minLat = max(lat - ConstantData.FlickerConstants.BoundBoxHeight, ConstantData.FlickerConstants.SearchLatitudeRange.0)

        let maxLong = min(long + ConstantData.FlickerConstants.BoundBoxWidth, ConstantData.FlickerConstants.SearchLogitudeRange.1)
        let minLong = max(long - ConstantData.FlickerConstants.BoundBoxWidth, ConstantData.FlickerConstants.SearchLogitudeRange.0)
    
        return "\(minLong),\(minLat),\(maxLong),\(maxLat)"
    }
    
    
    static func getFlickerApiUrl(params: [String:Any]) -> URL {
    
        var urlComponents = URLComponents()
        urlComponents.scheme = ConstantData.FlickerConstants.FlickerScheme
        urlComponents.host = ConstantData.FlickerConstants.FlickerHost
        urlComponents.path = ConstantData.FlickerConstants.FlickerApiPath
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key, value) in params {
//            print(key)
//            print(value)
            let query = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems!.append(query)
        }
        
        return urlComponents.url!
    
    }
    
}
