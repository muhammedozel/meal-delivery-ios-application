//
//  OrderTrackViewController.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-06-01.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class OrderTrackViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var estimatedCompletionLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var seconds = 60 //900 = 15 mins
    var timer = Timer()
    
    var locationManager:CLLocationManager?
    var orderPrepareStart:Bool = false
    let restLocation = CLLocation(latitude: 43.742057, longitude: -79.593456)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        //Restaurant location with 100m radius
        let circle = MKCircle(center: restLocation.coordinate, radius: 100)
        self.mapView.addOverlay(circle)
        let pin: MKPointAnnotation = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(restLocation.coordinate.latitude, restLocation.coordinate.longitude)
        pin.title = "Restaurant"
        mapView.addAnnotation(pin)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = .red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 4

            return circle
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        if(!orderPrepareStart){
            if(location.distance(from: restLocation) < 100) {
                let alertBox = UIAlertController(title: "Order Preparing", message: "We have started preparing your order.", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertBox, animated: true, completion: nil)
                orderPrepareStart = true
                estimatedCompletionLabel.isHidden = false
                timerLabel.text = ""
                timerLabel.isHidden = false
                orderStatusLabel.text = "Your order is being prepared."
                
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    self.seconds -= 1
                    self.timerLabel.text = self.timeString(time: TimeInterval(self.seconds))
                    if self.seconds < 1 {
                        timer.invalidate()
                        let alertBox = UIAlertController(title: "Order Ready!", message: "Your order is ready to pickup.", preferredStyle: .alert)
                        alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertBox, animated: true, completion: nil)
                        self.orderStatusLabel.text = "Your order is ready to pick up."
                    }
                }
            }
        }
    }

    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60

        return String(format:"%02i:%02i", minutes, seconds)
    }
}
