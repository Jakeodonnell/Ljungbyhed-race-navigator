//
//  ViewController.swift
//
//  Created by Jake O´Donnell on 24.05.2019.
//

import UIKit
import MapKit
import CoreLocation
import CoreMotion
import Foundation
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming

class ViewController: UIViewController, CLLocationManagerDelegate {
  
    let locManager = CLLocationManager()
    let AccManager = CMMotionManager()
    
    var timer = Timer()
    var counter = 0.0
    var fastestLap = 0.0
    var isRunning = false
    var lapsDone = 0
    var setUpType = 0
    var setupRun = 0
    var totSpeed = 0.0
    var vtot = 0.0
    var co = 0.0
    var delta = 0.0
    
    var startLat = 56.083993
    var startLong = 13.225494
    
    var lengthOfALatitude = 111343.12613789256
    var lengthOfALongitude = 62273.750366640306
    
    var speedo : Double = 0
    var setUpLap: Int = 0
    var headingAtStart: Double = 0
    var latAtStart: Double = 0
    var longAtStart: Double = 0
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var lastLapTime: UILabel!
    @IBOutlet var bestLapTime: UILabel!
    @IBOutlet var lapsLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBAction func goToMenu(_ sender: Any) {
       restartTimer()
       pauseTimer()
    }
    
    //Config Start/finish line
    @IBAction func startFinishButton(_ sender: Any) {
    
        //Info for start/finish line
        setUpLap = 1
        headingAtStart = (locManager.location?.course)!
        latAtStart = (locManager.location?.coordinate.latitude)!
        longAtStart = (locManager.location?.coordinate.longitude)!
        print("heading: \(headingAtStart), lat: \(latAtStart) long: \(longAtStart)")
        
        //Start timer
        setupRun = 1
        restartTimer()
        startTimer()
    }

    //Speed/map functions.
    func locationManager(_ locManager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
 /*       let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
   
        map.setRegion(region, animated: true)
*/
        let speed = (location.speed * 3.6)
        let correctionSpeed: Int = Int(speed as Double)
        
        if(correctionSpeed >= 0){
        totSpeed = speed
        speedLabel.text = ("\(correctionSpeed) km/h")
            speedo = Double(correctionSpeed)
        }
        else {
            totSpeed = 0
            speedLabel.text = ("0 km/h")
        }
       // self.map.showsUserLocation = true
        
    }
   
    
    override func viewDidLoad(){

        super.viewDidLoad()
        view.backgroundColor = UIColor.grayBackground
        pauseTimer()
        //Locationv
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        //Init text
        speedLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        timeLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        lastLapTime.font = UIFont.boldSystemFont(ofSize: 25.0)
        bestLapTime.font = UIFont.boldSystemFont(ofSize: 25.0)

        speedLabel.text = "0 km/h"
        timeLabel.text = "00:00.00"
        lastLapTime.text = "00:00.00"
        bestLapTime.text = "00:00.00"
        
        //Motion
        AccManager.startAccelerometerUpdates()
        AccManager.accelerometerUpdateInterval = 0.4
        AccManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
            if let acData = data {
                self.co += 1
                let gx = acData.userAcceleration.x
                let gy = acData.userAcceleration.y
                let gz = acData.userAcceleration.z
                
                let vx = gx * 0.1
                let vy = gy * 0.1
                let vz = gz * 0.1
                
                //let atot = abs((pow(gx,2)+pow(gy,2)+pow(gz,2)).squareRoot() - ((pow(acData.gravity.x,2)+pow(acData.gravity.y,2)+pow(acData.gravity.z,2)).squareRoot()))
                let atot = ((pow(gx,2)+pow(gy,2)+pow(gz,2)).squareRoot() * 10) / 3.6
                var testtot = ((pow(gy,2)).squareRoot() * 10) / 3.6
                if(gy < 0){
                        testtot = -1 * testtot
                    if(testtot < 0) {
                        testtot = 0
                    }
                }
                //print("total acceleration", atot)
                //print(self.totSpeed + atot)
                print(gx)
                self.bestLapTime.text = "\(Int(self.totSpeed + (testtot * 10)))"
                self.speedLabel.text = "\(Int(self.totSpeed)) km/h"
                //print("User gravitys \(acData.userAcceleration.x, acData.userAcceleration.y, acData.userAcceleration.z)")
            }
        }
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        date.text = dateString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func UpdateTime(){
        counter += 0.1
        timeLabel.text = timeString(time: counter)
    }
    
    @objc func startTimer(){
        if !isRunning{
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
            isRunning = true
        }
    }
    
    @objc func pauseTimer(){
        timer.invalidate()
        isRunning = false
    }
    
    @objc func restartTimer(){
        timer.invalidate()
        counter = 0
        timeLabel.text = timeString(time: counter)
        isRunning = false
    }
    
    @objc func checkFastest(){
        if(fastestLap < counter) {
            fastestLap = counter
            //bestLapTime.text = timeString(time: counter)
        }
    }
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%02i:%02i.%01i",minutes,Int(seconds),Int(secondsFraction * 10.0))
    }
}
