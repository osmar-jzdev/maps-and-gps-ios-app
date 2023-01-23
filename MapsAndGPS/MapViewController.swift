//
//  MapViewController.swift
//  MapsAndGPS
//
//  Created by Osmar Juarez on 12/11/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var mapView = MKMapView()
    var initCenterCoordinate =  CLLocationCoordinate2D(latitude: 19.331912, longitude: -99.192177)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .hybrid
        mapView.frame = self.view.bounds
        self.view.addSubview(mapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.setRegion(MKCoordinateRegion(center: initCenterCoordinate, latitudinalMeters: 400, longitudinalMeters: 400), animated: true)
    }
}
