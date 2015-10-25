//
//  MapViewController.swift
//  RefugeesWelcome
//
//  Created by Anna on 24.10.15.
//  Copyright © 2015 socialc0de. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import CCHMapClusterController

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var mapClusterController: CCHMapClusterController?
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        mapClusterController = CCHMapClusterController(mapView: self.mapView)
        mapClusterController?.delegate = self
        
        var annotations = [MKPointAnnotation]()
        RequestHelper.loadDataFromUrl("http://pajowu.de:8080/poi/wifi") { (jsonData) -> Void in
            let mapItems = jsonData["items"].arrayValue
            
            for jsonElem in mapItems {
                let latitude = (jsonElem["location"]["lat"].stringValue as NSString).doubleValue
                let longitude = (jsonElem["location"]["lng"].stringValue as NSString).doubleValue
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = jsonElem["addresse"].stringValue
                annotations.append(annotation)
            }
            self.mapClusterController?.addAnnotations(annotations, withCompletionHandler: nil)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager?.startUpdatingLocation()
        } else {
            mapView.showsUserLocation = false
            locationManager?.stopUpdatingLocation()
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CCHMapClusterAnnotation {
            let identifier = "clusterAnnotation"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? PinClusterView
            if pinView == nil {
                pinView = PinClusterView(annotation: annotation, reuseIdentifier: identifier)
                pinView?.canShowCallout = true
            } else {
                pinView?.annotation = annotation
            }
            
            pinView?.count = annotation.annotations.count
            pinView?.oneLocation = annotation.isUniqueLocation()
            
            return pinView
        }
        return nil
    }
}

extension MapViewController: CCHMapClusterControllerDelegate {
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, titleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        return "\(mapClusterAnnotation.annotations.count) Items"
    }

    func mapClusterController(mapClusterController: CCHMapClusterController!, willReuseMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) {
        let pinView = mapClusterController.mapView.viewForAnnotation(mapClusterAnnotation) as! PinClusterView
        pinView.count = mapClusterAnnotation.annotations.count
        pinView.oneLocation = mapClusterAnnotation.isUniqueLocation()
    }
    
}
