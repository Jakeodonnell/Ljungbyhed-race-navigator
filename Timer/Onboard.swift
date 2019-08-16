//
//  ViewController.swift
//  IOS12RecordVideoTutorial
//
//  Created by Arthur Knopper on 14/10/2018.
//  Copyright © 2018 Arthur Knopper. All rights reserved.
//

import MobileCoreServices
import UIKit
import MapKit
import CoreLocation
import CoreMotion


class Onboard: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    let locaManager = CLLocationManager()

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textOverlay: UILabel!
    @IBOutlet weak var viewToTest: UIView!
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var loggo: UIImageView!
    
    var currentSpeed = 0
    var timer = Timer()
    var timer2 = Timer()
    var counter = 0.0
    var counter2 = 0.0
    var fastestLap = 0.0
    var isRunning = false
    var isRunning2 = false
    
    var cameraIsRunning = false

    
    func locationManager(_ locaManager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        let speed = (location.speed * 3.6)
        let correctionSpeed: Int = Int(speed as Double)
        if(correctionSpeed >= 0){
            currentSpeed = correctionSpeed
            currentSpeedLabel.text = ("\(correctionSpeed) km/h")
            print(currentSpeed)
        }
        else {
            currentSpeed = 0
            currentSpeedLabel.text = ("\(0) km/h")
            print(currentSpeed)
        }
    }
    

   var controller = UIImagePickerController()
    let videoFileName = "/video.mp4"
    
    
    @IBAction func takeVideo(_ sender: Any) {
        // 1 Check if project runs on a device with camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // 2 Present UIImagePickerController to take video
            //controller.sourceType = .camera
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            controller.videoQuality = UIImagePickerController.QualityType(rawValue: 0)!
            controller.delegate = self
            controller.mediaTypes = [kUTTypeMovie as String]
            // start: controller.startVideoCapture() stop: controller.stopVideoCapture()
            controller.showsCameraControls = false
            
            controller.cameraOverlayView?.addSubview(currentSpeedLabel)
            controller.cameraOverlayView?.addSubview(timeLabel)
            controller.cameraOverlayView?.addSubview(loggo)
            
            present(controller, animated: true, completion: nil)
            startCamera()
            stopCamera()
        }
            
        else {
            print("Camera is not available")
        }
    }
    
    @IBAction func viewLibrary(_ sender: Any) {
        // Display Photo Library
        controller.sourceType = UIImagePickerController.SourceType.photoLibrary
        controller.mediaTypes = [kUTTypeMovie as String]
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.sourceType = UIImagePickerController.SourceType.camera
        
        locaManager.delegate = self
        locaManager.desiredAccuracy = kCLLocationAccuracyBest
        locaManager.requestWhenInUseAuthorization()
        locaManager.startUpdatingLocation()
        
        currentSpeedLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        timeLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        loggo.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

         }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            // Save video to the main photo album
            let selectorToCall = #selector(Onboard.videoSaved(_:didFinishSavingWithError:context:))
            UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
            // Save the video to the app directory so we can play it later
            let videoData = try? Data(contentsOf: selectedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(videoFileName)
            try! videoData?.write(to: dataPath, options: [])
        }
        picker.dismiss(animated: true)
    }
    
    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
            })
        }
    }
    //-------------------------------------------------2------------------------------------------

    @objc func startTimer2(){
        if !isRunning2{
            timer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime2), userInfo: nil, repeats: true)
            isRunning = true
        }
        
        
    }
    @objc func UpdateTime2(){
        counter2 += 0.1
        if(counter2 > 11) {
            controller.stopVideoCapture()
            timer2.invalidate()
            print("stopped")
            isRunning = false
        }
    }
   //-------------------------------------------------2------------------------------------------
    //-------------------------------------------------1------------------------------------------

    @objc func startTimer(){
        if !isRunning{
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
            isRunning = true
        }
    }
    @objc func UpdateTime(){
        counter += 0.1
        timeLabel.text = timeString(time: counter)
    }
    //-------------------------------------------------1------------------------------------------

    
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
    
    func startCamera(){
        if(cameraIsRunning == false){
            cameraIsRunning = true
            controller.startVideoCapture()
            print("running")
        }
    }
    
    func stopCamera(){
        if(cameraIsRunning == true){
            print("stopping camera")
            startTimer2()
        }
       
    }
}



