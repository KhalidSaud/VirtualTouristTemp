//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by KHALID ALSUBAIE on 14/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var map: MKMapView!
    var fetchController: NSFetchedResultsController<Pin>!
    var managedObjectContext: NSManagedObjectContext {
        return DataController.dataController.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        setupFetchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFetchController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchController = nil
    }
    
    func setupFetchController() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchController.delegate = self
        
        do {
            try fetchController.performFetch()
            updateMap()
        } catch {
            fatalError("Fetch Error : \(error.localizedDescription)")
        }
    }
    
    func updateMap() {
        guard let pins = fetchController.fetchedObjects else {
            print("Unable to fetch objects / pins")
            return
        }
        
        for pin in pins {
            if map.annotations.contains(where: { pin.compare(coord: $0.coordinate) }) { continue }
            let anno = MKPointAnnotation()
            anno.coordinate = pin.coord
            map.addAnnotation(anno)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMap()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coord = view.annotation?.coordinate {
            print("There is selected \(coord)")
            let pin = fetchController.fetchedObjects?.filter { $0.compare(coord: coord) }.first
            performSegue(withIdentifier: "ToImagesView", sender: pin)
        } else {
            print("There is NOT selected coord")
            return
        }
        
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began { return }
        let touchedPoint = sender.location(in: map)
        let pin = Pin(context: managedObjectContext)
        pin.coord = map.convert(touchedPoint, toCoordinateFrom: map)
        try? managedObjectContext.save()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToImagesView" {
            let imagesVC = segue.destination as! ImagesVC
            imagesVC.pin = sender as? Pin
        }
    }
    
}

