//
//  SecondViewController.swift
//  testTab
//
//  Created by  on 5/2/17.
//  Copyright © 2017 uhcl. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class SecondViewController: UIViewController, CLLocationManagerDelegate {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!
    var locationmanager : CLLocationManager!
    
    var cordinate: CLLocationCoordinate2D!
    
    var longitude: Double = 122.22
    var latitude: Double = 78.1
    
    @IBOutlet weak var lastname: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapType: UISegmentedControl!
    
    @IBAction func mapTypeSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0 : mapView.mapType = MKMapType.standard
        case 1 : mapView.mapType = MKMapType.satellite
        default: mapView.mapType = MKMapType.standard
        }
    }
    
    @IBAction func show(_ sender: UIButton) {
        if lastname.text! != "" {

            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person" )
            request.predicate = NSPredicate(format: "lastname = %@", lastname.text!)
            let persons = try? context.fetch(request)
            
            for person in persons! {
                print((person as! Person).firstname)
                print((person as! Person).lastname)
                if let address = (person as! Person).address {
                    if address == "" {
                        let region = MKCoordinateRegionMakeWithDistance(cordinate, 5000, 5000)
                        mapView.region = region
                        addAnnotation(cordinate)
                    } else {
                        var geoCoder = CLGeocoder()
                        geoCoder.geocodeAddressString(address, completionHandler: { placemarks,errors in
                        
                            let placeArray = placemarks! as [CLPlacemark]
                            var placemark: CLPlacemark = placeArray[0]
                            
                            self.cordinate = placemark.location?.coordinate
                            
                            
                            let region = MKCoordinateRegionMakeWithDistance(self.cordinate, 5000, 5000)
                            self.mapView.region = region
                            self.addAnnotation(self.cordinate)
                            
                        })
                        
                    }
                }
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        cordinate = locations[0].coordinate
    }
    
    func addAnnotation(_ cordinate: CLLocationCoordinate2D,_ title: String = "Hello", _ subtitle: String = "world"){
        var annotation = MKPointAnnotation()
        annotation.coordinate = cordinate
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cordinate = CLLocationCoordinate2DMake(latitude, longitude)
        context = appDelegate.persistentContainer.viewContext
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationmanager = CLLocationManager()
            locationmanager.requestWhenInUseAuthorization()
            locationmanager.desiredAccuracy = kCLLocationAccuracyBest
            locationmanager.startUpdatingLocation()
            locationmanager.delegate = self
        }else{
            print("Core Location Not available")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
