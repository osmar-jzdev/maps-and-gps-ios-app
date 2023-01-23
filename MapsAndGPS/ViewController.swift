//
//  ViewController.swift
//  MapsAndGPS
//
//  Created by Osmar Juarez on 12/11/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManagerVar = CLLocationManager()
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let aut =  locationManagerVar.authorizationStatus
        if aut == .authorizedAlways || aut == .authorizedWhenInUse {
            locationManagerVar.startUpdatingLocation()
        } else if aut == .notDetermined {
            locationManagerVar.requestAlwaysAuthorization()
        } else {
            //once again the user decline the geolocalization
            exit(666)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let textView = UITextView()
        textView.frame = self.view.frame.insetBy(dx: 30, dy: 100)
        
        guard let location =  locations.first else { /* the array is empty*/ return }
        CLGeocoder().reverseGeocodeLocation(location) { lugares, error in
            if error != nil {
                print("no se pudo encontrar ninguna dirección")
            } else {
                guard let somewhere = lugares?.first else { return }
                let thoroughfare = (somewhere.thoroughfare ?? "")
                let subThoroughfare = (somewhere.subThoroughfare ?? "")
                let locality = (somewhere.locality ?? "")
                let subLocality = (somewhere.subLocality ?? "")
                let administrativeArea = (somewhere.administrativeArea ?? "")
                let subAdministrativeArea = (somewhere.subAdministrativeArea ?? "")
                let postalCode = (somewhere.postalCode ?? "")
                let country = (somewhere.country ?? "")
                let address = "Dirección: \(thoroughfare) \(subThoroughfare) \(locality) \(subLocality) \(administrativeArea) \(subAdministrativeArea) \(postalCode) \(country)"
                textView.text =  "Usted esta en: \(location.coordinate.latitude), \(location.coordinate.longitude)\n\(address)"
            }
        }
        
        self.view.addSubview(textView)
        //stopping the lecture of the geolocalization
        locationManagerVar.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManagerVar.stopUpdatingLocation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManagerVar.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManagerVar.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.locationServicesEnabled() {
            if locationManagerVar.authorizationStatus == .authorizedAlways ||
                locationManagerVar.authorizationStatus == .authorizedWhenInUse {
                locationManagerVar.startUpdatingLocation()
            } else {
                locationManagerVar.requestAlwaysAuthorization()
            }
        }
        else {
            let alertController = UIAlertController(title: "Error", message: "Lo sentimos, pero para utilizar la app se necesitan permisos de feolocalización. ¿Deseas habilitar los permisos a la aplicación?", preferredStyle: .alert)
            let action = UIAlertAction(title: "SI", style: .default){
                action in
                let settingsURL = URL(string: UIApplication.openSettingsURLString)!
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:])
                }
            }
            alertController.addAction(action)
            let action2 = UIAlertAction(title: "NO", style: .default) {
                action in
                //with thsi code we just stop the app and indicate to the hone the error code
                exit(666)
            }
            alertController.addAction(action2)
            self.present(alertController, animated: true)
        }
    }

}

