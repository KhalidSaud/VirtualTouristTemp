//
//  ImagesVC.swift
//  Virtual Tourist
//
//  Created by KHALID ALSUBAIE on 14/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class ImagesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImagesLabel: UILabel!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var newCollectionActivityIndicator: UIActivityIndicatorView!
    
    // MARK: Variables
    
    var fetchController: NSFetchedResultsController<Image>!
    var pin: Pin!
    var pageNum = 1
    var DeleteEverything = false
    
    var managedObjectContext: NSManagedObjectContext {
        return DataController.dataController.viewContext
    }
    
    var isThereImages: Bool {
        return (fetchController.fetchedObjects?.count ?? 0) != 0
    }
    
    // MARK: ViewDidLoad, appear, disappear
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchController = nil
    }
    
    // MARK: Actions
    
    @IBAction func newCollectionButtonPressed(_ sender: Any) {
        
        updateView(processing: true)
        
        if isThereImages {
            DeleteEverything = true
            for image in fetchController.fetchedObjects! {
                managedObjectContext.delete(image)
            }
            
            try? managedObjectContext.save()
            DeleteEverything = false
        }
        
        API.ImagesURLs(coord: pin.coord, pageNum: pageNum) { (urls, error, errorMsg) in
            
            DispatchQueue.main.async {
                
                self.updateView(processing: false)
                
                guard error == nil && errorMsg == nil else {
                    self.showAlert(title: "Something is wrong!", message: error?.localizedDescription ?? errorMsg!) // might be an issue with unwrapping errorMsg!
                    return
                }
                
                guard let urls = urls, !urls.isEmpty else {
                    self.noImagesLabel.isHidden = false
                    return
                }
                
                self.noImagesLabel.isHidden = true
                
                for url in urls {
                    let image = Image(context: self.managedObjectContext)
                    image.imgUrl = url
                    image.pin = self.pin
                }
                
                try? self.managedObjectContext.save()
                
            }
        }
        
        pageNum += 1
        
    }
    
    // MARK: Methods
    
    func setupFetchController() {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchController.delegate = self
        do {
            try fetchController.performFetch()
            if isThereImages {
                updateView(processing: false)
                self.noImagesLabel.isHidden = true
            } else {
                newCollectionButtonPressed(self)
                self.noImagesLabel.isHidden = false
            }
        } catch {
            fatalError("Photos fetch error : \(error.localizedDescription)")
        }
    }
    
    func updateView(processing: Bool) {
        collectionView.isUserInteractionEnabled = !processing
        if processing {
            newCollectionButton.title = ""
            newCollectionActivityIndicator.isHidden = false
            newCollectionActivityIndicator.startAnimating()
        } else {
            newCollectionActivityIndicator.stopAnimating()
            newCollectionActivityIndicator.isHidden = true
            newCollectionButton.title = "New Collection"
        }
    }
    
    
    
    // MARK: FetchControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let indexPath = indexPath, type == .delete && !DeleteEverything {
            collectionView.deleteItems(at: [indexPath])
            return
        }
        
        if let indexPath = indexPath, type == .insert {
            collectionView.insertItems(at: [indexPath])
            return
        }
        
        if let newIndexPath = newIndexPath, let oldIndexPath = indexPath, type == .move {
            collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
            return
        }
        
        if type != .update {
            collectionView.reloadData()
        }
        
    }
    
}
