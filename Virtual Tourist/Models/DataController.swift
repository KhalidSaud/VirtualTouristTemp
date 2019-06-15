//
//  DataController.swift
//  Virtual Tourist
//
//  Created by KHALID ALSUBAIE on 15/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let dataController = DataController()
    
    let persistentDataContainer = NSPersistentContainer(name: "VirtualTouristModel")
    
    var viewContext: NSManagedObjectContext {
        return persistentDataContainer.viewContext
    }
    
    func load() {
        persistentDataContainer.loadPersistentStores { (storeDesc, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
    
}
