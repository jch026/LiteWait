//
//  RestaurantViewController.swift
//  litewait
//
//  Created by Joseph Ho on 10/9/18.
//  Copyright © 2018 dumplingNinjas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RestaurantViewController: UIViewController,

    CLLocationManagerDelegate{
    
    private let locationManager = CLLocationManager()
    private var previousPoint: CLLocation?
    private var totalMovementDistance: CLLocationDistance = 0

    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var waitLabel: UILabel!
    @IBOutlet var map: MKMapView!
    
    var uwt:String = ""
    
    var restaurantName:String = ""
    var waitName:String = ""
    var locationX: Double = 0
    var locationY: Double = 0
    var displayed: Bool = false
    var distanceInMeters: Double = 0
    var uid: String = ""
    var address: String = ""
    
    //Authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authoization status changed to \(status.rawValue)")
        switch status {
        case .authorized, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            map.showsUserLocation = true
            break
        default:
            locationManager.stopUpdatingLocation()
            map.showsUserLocation = false

        }
    }
    override func viewDidLayoutSubviews() {
        print("Y Location \(locationY)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let swt = segue.destination as? SubmitWaitTimeViewController
        {
            swt.uid = uid
        }
    }
    
    @IBAction func getDirections(_ sender: Any) {
       
        let coordinates = CLLocationCoordinate2DMake(locationX, locationY)

        let region = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.01, 0.02))
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(restaurantName)"
        //mapItem.name = "\(address)"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
//        let options = [
//            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
//            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
//        mapItem.name = "\(restaurantName)"
//        mapItem.openInMaps(launchOptions: options)
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = (locations as [CLLocation])[locations.count - 1]
        
        let centerLocation = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        let mapSpan = MKCoordinateSpanMake(0.01, 0.01)
        let mapRegion = MKCoordinateRegionMake(centerLocation, mapSpan)
        self.map.setRegion(mapRegion, animated: true)
        
        let coordinate = CLLocation(latitude: locationY, longitude: locationX)
        distanceInMeters = coordinate.distance(from: newLocation)
        
    }
    
    @IBAction func submitTime(_ sender: Any) {
        if displayed == false && distanceInMeters >= 100 {
            self.Alert(Message: "You can only update waiting time within 100 meters")
            displayed = true
        }
        performSegue(withIdentifier: "WaitTime", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantLabel?.text = restaurantName
        waitLabel?.text = waitName
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        setupNavigationBarItems()
        
        if CLLocationManager.locationServicesEnabled() {
            print("foo")
        }
    }
    
    private func setupNavigationBarItems(){
        let image = UIImage(named: "NavBar")
        let titleImageView = UIImageView(image: image)
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(restaurantName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindhere(segue:UIStoryboardSegue) {
        let comingFrom = segue.source as! SubmitWaitTimeViewController
        let uwt = Int(comingFrom.waittime)
        waitLabel.text = String(uwt)
    }
    
    func Alert (Message: String){
        let alert = UIAlertController(title: "Alert!", message: Message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    

}
