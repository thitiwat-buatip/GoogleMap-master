//
//  LocationVC.swift
//  GoogleMap
//
//  Created by Thitiwat on 5/23/2560 BE.
//  Copyright © 2560 Thitiwat. All rights reserved.
//

import GoogleMaps
import GooglePlaces
import UIKit

class LocationVC: UIViewController , UISearchBarDelegate,CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate {

    @IBOutlet weak var googleMapContrainer: UIView!
    var mapView : GMSMapView!
    var locationmanager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationmanager = CLLocationManager()
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        locationmanager.startMonitoringSignificantLocationChanges()
        initGoogleMap()

    }
    
    func initGoogleMap(){
        mapView = GMSMapView.map(withFrame: googleMapContrainer.frame, camera: GMSCameraPosition())
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        view.addSubview(mapView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        let position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        self.mapView.animate(to: camera)
        let mark = GMSMarker(position: position)
        mark.map = mapView
        self.locationmanager.stopUpdatingLocation()
        
    }

    @IBAction func searchBtn(_ sender: Any) {
        
        let autocomplete = GMSAutocompleteViewController()
        autocomplete.delegate = self
        self.locationmanager.startUpdatingLocation()
        self.present(autocomplete, animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let mark = GMSMarker(position: position)
        
        mark.map = mapView
        self.mapView.camera = camera
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error AutoComplete \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
