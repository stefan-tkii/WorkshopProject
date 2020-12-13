//
//  RegularViewController.swift
//  WorkshopProject
//
//  Created by Stefan Kjoropanovski on 12/12/20.
//  Copyright © 2020 Stefan Kjoropanovski-Resen. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class RegularViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var userInfo: String = ""
    var desc: String = ""
    var workerType: String = "Specialist"
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var locationView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureRecognizer:)))
        longpress.minimumPressDuration = 2.0
        longpress.delaysTouchesBegan = true
        longpress.delegate = self
        self.locationView.addGestureRecognizer(longpress)
        checkLocationServices()
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer)
    {
        if gestureRecognizer.state == .began
        {
            let location = gestureRecognizer.location(in: locationView)
            let coordinates = locationView.convert(location, toCoordinateFrom: locationView)
            let geopoint = PFGeoPoint(latitude: coordinates.latitude, longitude: coordinates.longitude)
            self.latitude = geopoint.latitude
            self.longitude = geopoint.longitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = "Problem"
            annotation.subtitle = "Your problem's location"
            locationView.addAnnotation(annotation)
            displayAdvancedAlert()
        }
    }
    
    func displayAdvancedAlert()
    {
       
        let alert = UIAlertController(title: "Info alert", message: "Please fill out the description regarding your problem, toggle switch to choose Expert type of worker, default is Specialist", preferredStyle: .alert)
        alert.view.addSubview(createSwitch())
        alert.addTextField(configurationHandler: {(textField) in
            self.desc = textField.text!
        })
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {
            (action) in
            let problem = PFObject(className: "UserProblem")
            problem["userEmail"] = self.userInfo
            problem["locationLongitude"] = self.longitude
            problem["locationLatitude"] = self.latitude
            problem["description"] = self.desc
            problem["workerType"] = self.workerType
            problem.saveInBackground(block: {
                (result, error) in
                if(result)
                {
                    print("Succsessfully saved the problem.")
                }
                else
                {
                    if let err = error
                    {
                        print(err.localizedDescription)
                    }
                    else
                    {
                        print("Unknown error")
                    }
                }
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createSwitch() -> UISwitch
    {
        let switchControl = UISwitch(frame: CGRect(x: 10, y: 20, width: 0, height: 0))
        switchControl.isOn = false
        switchControl.setOn(false, animated: true)
        switchControl.addTarget(self, action: #selector(switchValueChanged(sender:)), for: .valueChanged)
        return switchControl
    }
    
    @objc func switchValueChanged(sender: UISwitch!)
    {
        if(sender.isOn)
        {
            self.workerType = "Expert"
        }
        else
        {
            self.workerType = "Specialist"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    @IBAction func listWorkers(_ sender: UIButton)
    {
        performSegue(withIdentifier: "gotoList", sender: self)
    }
    
    func initLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuth()
    {
        switch CLLocationManager.authorizationStatus()
        {
        case .authorizedWhenInUse:
            mapManagement()
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            displayAlert("Authorization error", "Location services are restricted in your area.")
            break
        case .denied:
            displayAlert("Authorization error", "Please allow our app access to your location.")
            break
        case .authorizedAlways:
            //Ne go koristam
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            fatalError("An unkown error has occured.")
        }
    }
    
    func mapManagement()
    {
        locationView.showsUserLocation = true
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            locationView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            initLocationManager()
            checkLocationAuth()
        }
        else
        {
            displayAlert("Location services error", "Please turn on location services.")
        }
    }
    
    func displayAlert(_ title: String, _ message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension RegularViewController: CLLocationManagerDelegate
{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        locationView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
    
}
