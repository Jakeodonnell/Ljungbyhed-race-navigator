//
//  0100.swift
//  Timer
//
//  Created by Jake O´Donnell on 2019-05-31.
//  Copyright © 2019 Jake O´Donnell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class _100: UIViewController, CLLocationManagerDelegate {
    
    let locManager0100 = CLLocationManager()
   
    @IBOutlet var timeCounter: UILabel!
    @IBOutlet var speedOmeterTitle: UILabel!
    
    var speedOmeter = 0
    var timer = Timer()
    var counter = 0.0
    var isRunning = false
    var readyToRun = 0
    
    var v1 = 0
    var v2 = 0
    var t1 = 0
    var t2 = 0

    @IBAction func GoButton(_ sender: Any) {
        if(speedOmeter == 0){
            readyToRun = 1
            timeCounter.text = ("\(0)")
            print("hej")
        }
    }
    
    func locationManager(_ locManager0100: CLLocationManager, didUpdateLocations locations0100: [CLLocation]){
        let location = locations0100[0]
        let speed = (location.speed * 3.6)
        speedOmeter = Int(speed as Double)
        print("\(speedOmeter)")
        shouldIStart()
        shouldIStop()
        speedOmeterTitle.text = ("\(speedOmeter)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeCounter.text = ("\(0)")
        view.backgroundColor = UIColor.grayBackground
        pauseTimer()
        //Location
        
        locManager0100.delegate = self
        locManager0100.desiredAccuracy = kCLLocationAccuracyBest
        locManager0100.requestWhenInUseAuthorization()
        locManager0100.startUpdatingLocation()
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func UpdateTime(){
        counter += 0.1
        timeCounter.text = String(format: "%.1f", counter)
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
        timeCounter.text = "00.00.00"
        counter = 0
        isRunning = false
    }
    
    @objc func shouldIStart(){
        if(speedOmeter < 0) {
            speedOmeter = 0
        }
        
        if(speedOmeter > 0 && readyToRun == 1){
            startTimer()
            readyToRun = 0
        }
    }
    
    @objc func shouldIStop(){
        if(speedOmeter >= 100){
            pauseTimer()
        }
    }
    
    @objc func acceleration(){
        
    }
}
