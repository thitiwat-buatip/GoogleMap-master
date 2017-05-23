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
import SwiftyJSON
import Alamofire

class LocationVC: UIViewController , UISearchBarDelegate,CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var googleMapContrainer: UIView!
    var mapView : GMSMapView!
    var locationmanager = CLLocationManager()
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        locationmanager = CLLocationManager()
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        locationmanager.startMonitoringSignificantLocationChanges()
        initGoogleMap()
        
        mapView.delegate = self

    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        let locationOfMarker = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        print("Tap marker \(locationOfMarker)")
        let mark = GMSMarker(position: locationOfMarker)
        locationEnd = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mark.title = "End Location"
        mark.snippet = "lat:\(coordinate.latitude) long:\(coordinate.longitude)"
        drawPath(startLocation: locationStart, endLocation: locationEnd)
        mark.map = mapView

    }
    
    func initGoogleMap(){
        mapView = GMSMapView.map(withFrame: googleMapContrainer.frame, camera: GMSCameraPosition())
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        view.addSubview(mapView)

    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
//        let position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        locationStart = CLLocation(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        locationmanager.stopUpdatingLocation()
        self.mapView.animate(to: camera)
        
    }

    @IBAction func searchBtn(_ sender: Any) {
        
        let autocomplete = GMSAutocompleteViewController()
        autocomplete.delegate = self
        self.locationmanager.startUpdatingLocation()
        self.present(autocomplete, animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        mapView.clear()
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        let mark = GMSMarker(position: position)
        mark.map = mapView
        mark.title = place.name
        mark.snippet = place.formattedAddress
        self.mapView.camera = camera
        self.dismiss(animated: true, completion: nil)
        
        drawPath(startLocation: locationStart, endLocation: locationEnd)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error AutoComplete \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.blue
                polyline.map = self.mapView
            }
            
        }
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
