//
//  ControllerAvecCarte.swift
//  Les Calanques
//
//  Created by Matthieu PASSEREL on 25/07/2018.
//  Copyright © 2018 Matthieu PASSEREL. All rights reserved.
//

import UIKit
import MapKit

class ControllerAvecCarte: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var calanques: [Calanque] = CalanqueCollection().all()
    var locationManager = CLLocationManager()
    var lastPosition: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        addAnnotations()
        NotificationCenter.default.addObserver(self, selector: #selector(notif(notification:)), name: Notification.Name("Detail"), object: nil)
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let random = Int.random(in: 0..<calanques.count)
        let calanque = calanques[random]
        setupMap(coordonnees: calanque.coordonnee)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let position = locations.last {
            print(position.coordinate)
            lastPosition = position
        }
    }
    
    func setupMap(coordonnees: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35)
        let region = MKCoordinateRegion(center: coordonnees, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func notif(notification: Notification) {
        print("On a recu une notif")
        performSegue(withIdentifier: "Detail", sender: notification.object)
    }
    
    func addAnnotations() {
        for calanque in calanques {
            
            //Annotation de base
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = calanque.coordonnee
//            annotation.title = calanque.nom
//            mapView.addAnnotation(annotation)
            
            
            //Anotation Custom
            
            let annotation = MonAnnotation(calanque)
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "reuseID"
        
        //Verifier que ce ne soit pas la position de l'utilisateur
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        if let anno = annotation as? MonAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            if annotationView == nil {
                
                //Overide init
                //annotationView = MonAnnotationView(annotation: anno, reuseIdentifier: reuseIdentifier)
                
                annotationView = MonAnnotationView(controller: self, annotation: anno, reuseIdentifier: reuseIdentifier)
                
                //Basique
//                annotationView = MKAnnotationView(annotation: anno, reuseIdentifier: reuseIdentifier)
//                annotationView?.image = UIImage(named: "placeholder")
//                annotationView?.canShowCallout = true
                return annotationView
            } else {
               return annotationView
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail", let vc = segue.destination as? DetailController {
            vc.calanqueRecue = sender as? Calanque
        }
    }
    
    
    @IBAction func getPosition(_ sender: Any) {
        locationManager.startUpdatingLocation()
        guard let position = lastPosition else { return }
        setupMap(coordonnees: position.coordinate)
    }
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : mapView.mapType = MKMapType.standard
        case 1: mapView.mapType = .satellite
        case 2: mapView.mapType = .hybrid
        default: break
        }
    }
    
}
