//
//  ViewController.swift
//  GoogleMap
//
//  Created by Thitiwat on 5/23/2560 BE.
//  Copyright © 2560 Thitiwat. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    

    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var mapView: UIView!
    var map : GMSMapView!
    
    var locationmanager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 15
        tapView.backgroundColor = UIColor( white : 1 , alpha : 0)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(Tapped))
        gesture.numberOfTapsRequired = 1
        tapView.addGestureRecognizer(gesture)
        
        locationmanager = CLLocationManager()
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        locationmanager.startMonitoringSignificantLocationChanges()
       
        LoadMap()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func LoadMap(){
        
        map = GMSMapView.map(withFrame: self.mapView.bounds, camera: GMSCameraPosition())
        mapView.addSubview(map)
        
        // Creates a marker in the center of the map.
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        let position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        self.map.animate(to: camera)
        
        let mark = GMSMarker(position: position)
        mark.map = map
    }
    
    func Tapped(){
        print("Tapped !!!")
        performSegue(withIdentifier: "showmap", sender: nil)
    }
}

