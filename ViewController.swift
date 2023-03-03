//
//  ViewController.swift
//  map4
//
//  Created by 陳昶瑞 on 2023/2/8.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController,CLLocationManagerDelegate {
    
        let mapView = MKMapView()
        let locationManager = CLLocationManager()
        let locations = [
            ["title":"East Parking Deck", "latitude":40.804461,"longitude":-77.863061],
            ["title":"Hub Parking Deck", "latitude":40.79911,"longitude":-77.85985],
            ["title":"Nittany Parking Deck", "latitude":40.79798,"longitude":-77.86948]
            
        ]
       
        override func viewDidLoad() {
            super.viewDidLoad()
            setupMapView()
            checkLocationServices()
            for location in locations {
                let annotation = MKPointAnnotation()
                annotation.title = location["title"] as? String
                annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
                mapView.addAnnotation(annotation)
            }           // Do any additional setup after loading the view.
        }
        func setupMapView() {
            view.addSubview(mapView)
            mapView.translatesAutoresizingMaskIntoConstraints = false
            mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        }
       
        func checkLocationAuthorization() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                mapView.showsUserLocation = true
                followUserLocation()
                locationManager.startUpdatingLocation()
                break
            case .denied:
                // Show alert
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // Show alert
                break
            case .authorizedAlways:
                break
            }
        }
        
        func checkLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                setupLocationManager()
                checkLocationAuthorization()
            } else {
                // the user didn't turn it on
            }
        }
        
        func followUserLocation() {
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 800, longitudinalMeters: 800)
                mapView.setRegion(region, animated: true)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
        }
        
        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is MKPointAnnotation else { return nil }

            let identifier = "Annotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            } else {
            annotationView!.annotation = annotation
            }

            return annotationView
    }
    }

