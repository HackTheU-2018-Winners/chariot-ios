//
//  MapViewController.swift
//  chariot
//
//  Created by Jared Amen on 9/9/18.
//  Copyright © 2018 Chariot App. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class DropoffBin: NSObject, MKAnnotation {
    private let latitude: CLLocationDegrees
    private let longitude: CLLocationDegrees
    let title: String?
    let subtitle: String?

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(latitude: CLLocationDegrees,
         longitude: CLLocationDegrees,
         title: String,
         subtitle: String) {

        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.subtitle = subtitle
    }
}

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        Firestore.firestore().collection("Bins").addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("bin snapshot error \(String(describing: error))")
                return
            }

            let annotations = snapshot.documents.map { thing -> DropoffBin in
                let data = thing.data()
                let point = data["Location"] as! GeoPoint
                return DropoffBin(latitude: point.latitude,
                                  longitude: point.longitude,
                                  title: data["Name"] as! String,
                                  subtitle: "Needs: \(data["Needs"] as! String)")
            }

            self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
            self?.mapView.addAnnotations(annotations)
        }

        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        locationManager.stopUpdatingLocation()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location fail \(error)")
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let bin = annotation as? DropoffBin else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: bin, reuseIdentifier: "pin")
        } else {
            annotationView?.annotation = bin
        }

        annotationView?.image = UIImage.init(named: "binIcon")

        let pinImage = UIImage(named: "binIcon")
        let size = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage

        return annotationView
    }
}

