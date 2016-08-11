//
//  MapViewController.swift
//  beepLAH
//
//  Created by Nicole on 03/08/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,  MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var annotation : MKPointAnnotation!
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var currentCardName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        
        self.mapView.delegate = self
        
        mapView.showsUserLocation = true
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print(currentCardName)
        print(Card.currentCard.name)
        
        self.mapView.removeOverlays(mapView.overlays)
        
        if currentCardName != Card.currentCard.name{
            // clear all mapAnnotation
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            if Card.currentCard.name == nil {
                Card.currentCard.name = ""
            }else{
            self.findStalls(currentLocation, categoryString: Card.currentCard.name!)
            }
            // check that there is location
            // if yes
            // run the natural search
            
            
        }
        
        currentCardName = Card.currentCard.name!
        
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            if location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000 {
                
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                self.mapView.setRegion(region, animated: true)
                
                locationManager.stopUpdatingLocation()
                print("my location is \(location)")
                
                
                
                
                self.currentLocation = location
                
                self.findStalls(location, categoryString:Card.currentCard.name!)
                
            }
        }
    }
    
    func findStalls(location: CLLocation, categoryString: String) {
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = categoryString
        
        request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.05, 0.05))
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) in
            if let response = response {
                for mapItem in response.mapItems {
                    let placemark = mapItem.placemark
                    if let location = placemark.location {
                        self.annotation = MKPointAnnotation()
                        self.annotation.title = placemark.name
                        self.annotation.coordinate = placemark.coordinate
                        self.mapView.addAnnotation(self.annotation)
                    }
                    
                }
            }
        }
        
        
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        mapView.userLocation
        if annotation.isKindOfClass(MKUserLocation.classForCoder()){
            return nil
        }else{
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            return annotationView
        }
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.mapView.removeOverlays(mapView.overlays)
        if let locationTitle = self.annotation.title {
            print(locationTitle)
            let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "\(view.annotation!.title)"
            
            self.findRouteTo(mapItem)
        }
        
    }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        return renderer
    }
    
    func findRouteTo(mapItem: MKMapItem) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = mapItem
        request.requestsAlternateRoutes = true
        request.transportType = .Automobile
        let direction = MKDirections(request: request)
        direction.calculateDirectionsWithCompletionHandler { (response, error) in
            if let response = response {
                if let route = response.routes.first {
                    if let name = mapItem.name {
                        print(name)
                        
                    }
                    
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
                
            }
        }
    }
    
    
    
    
    
}