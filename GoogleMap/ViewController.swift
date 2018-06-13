//
//  ViewController.swift
//  GoogleMapApp
//
//  Created by Gavin Ong on 12/6/18.
//  Copyright © 2018 Gavin Ong. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces



class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    var mapView: GMSMapView!

    var arrayAddress = [GMSAutocompletePrediction]()
    
    lazy var filter: GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = .address
    
        return filter
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
   
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var searchBarContainerView: UIView!
    
    @IBOutlet weak var mapContainerView: UIView!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    var resultView: UITextView?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAPIKey()
        //setupCurrentLocation()
        setupView()
        setupMapView()
        
        
        
    
        
        
        
        
    }
    
    func setupView(){
     
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.addressTextField.delegate = self
    
        self.tableView.register(UINib(nibName: "AutoCompleteAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.tableView.isHidden = true
        
        self.tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Float.pi))
        
    }
    
    func setupAPIKey(){
        GMSServices.provideAPIKey("AIzaSyAjai5Pv46eB_6SPj2oS2kFPDTtTtJOJxw")
        GMSPlacesClient.provideAPIKey("AIzaSyAjai5Pv46eB_6SPj2oS2kFPDTtTtJOJxw")
    }
    
    
    
    func setupMapView() {

        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        self.mapView = GMSMapView.map(withFrame: self.mapContainerView.bounds, camera: camera)
        // view = mapView
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        mapView.settings.myLocationButton = true
        
        
        self.mapContainerView.addSubview(mapView)
        
       // self.mapContainerView.bringSubview(toFront: tableView)
        
    }
    
    func setupCurrentLocation(){
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

extension ViewController : CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.locationManager.stopUpdatingLocation()
    }

}

extension ViewController : UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AutoCompleteAddressTableViewCell
        
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        
        cell.resultAddressLabel.attributedText = arrayAddress[indexPath.row].attributedFullText
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAddress.count
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GMSPlacesClient.shared().lookUpPlaceID(arrayAddress[indexPath.row].placeID!, callback: { (result, error) in
            print(result!.coordinate)
            self.tableView.isHidden = true
            
            self.addressTextField.text = result!.formattedAddress
            self.mapView.clear()
            
            self.mapView.moveCamera(GMSCameraUpdate.setTarget((result?.coordinate)!, zoom: 10))
     
            let marker = GMSMarker()
            marker.position = (result?.coordinate)!
            marker.title = result!.name
            marker.map = self.mapView
        })

    }
}


extension ViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if searchString == ""{
            self.arrayAddress = [GMSAutocompletePrediction]()
            self.tableView.isHidden = true
           // self.view.bringSubview(toFront: self.mapContainerView)
        }else{
            
            self.tableView.isHidden = false
            self.view.bringSubview(toFront: self.tableView)
            GMSPlacesClient.shared().autocompleteQuery(searchString, bounds: nil, filter: filter, callback: { (result, error) in
                if error == nil && result != nil{
                    
                    self.arrayAddress = result!
                  
                }
            })
        }
        self.tableView.reloadData()
        return true
    }
}
