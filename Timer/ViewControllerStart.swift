//
//  ViewControllerStart.swift
//  Timer
//
//  Created by Jake O´Donnell on 2019-05-26.
//  Copyright © 2019 Jake O´Donnell. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import AVFoundation
import AVKit
import MobileCoreServices
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming

class ViewControllerStart: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var viewTabel: UITableView!
    private let arrayTime: NSArray = []

    
    @IBOutlet weak var race: UIButton!
    @IBOutlet weak var zeroHundred: UIButton!
    @IBOutlet weak var videoVieew: UIView!
    @IBOutlet weak var theTrack: UIButton!
    @IBOutlet var videoView: UIView!

    @IBAction func Onboard(_ sender: Any) {
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

            present(controller, animated: true, completion: nil)

        }
        else {
            print("Camera is not available")
        }
    }
    
    @IBAction func postLap(_ sender: Any) {
        ref.child(user).updateChildValues(["time": 55])
    }
    
    var user = "Jake"
    var ref: DatabaseReference!
    var controller = UIImagePickerController()
    let videoFileName = "/video.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        viewTabel.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        viewTabel.dataSource = self as? UITableViewDataSource
        viewTabel.delegate = self as? UITableViewDelegate
        viewTabel.backgroundColor = UIColor.clear
        self.viewTabel.rowHeight = 44.0
        self.viewTabel.separatorStyle = .none
        
        var ref = Database.database().reference()
        

        /*
        ref.child("287").observe(.value, with: { (snapshot) in
            let latitutde = "\(snapshot.childSnapshot(forPath: "Latitude").value!)"
          */
        
        setupView()
        controller.sourceType = UIImagePickerController.SourceType.camera
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "test"
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
  
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        cell.textLabel!.textColor = UIColor.white; //according to you.
        
        return cell
    }
    
    

func setupView(){
    let path = URL(fileURLWithPath: Bundle.main.path(forResource: "YES", ofType: ".mov")!)
    let player = AVPlayer(url: path)
    let newLayer = AVPlayerLayer(player: player)
    newLayer.frame = self.videoVieew.frame
    self.videoVieew.layer.addSublayer(newLayer)
    newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    player.play()
    player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
    }
    
    @IBAction func menue(_ sender: Any) {
        let actionSheet = MDCActionSheetController()
        
        
        let actionOne = MDCActionSheetAction(title: "Acceleration", image: UIImage(named: "Home"), handler: { (action) in print("\(action.title) action")
            
            let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let _100 = mainStoryBoard.instantiateViewController(withIdentifier: "_100") as! _100
            self.present(_100, animated: true, completion: nil)
        })
        
        
        let actionTwo = MDCActionSheetAction(title: "Onboard", image: UIImage(named: "Email"), handler: { (action) in print("\(action.title) action")
            
            let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let Onboard = mainStoryBoard.instantiateViewController(withIdentifier: "Onboard") as! Onboard
            self.present(Onboard, animated: true, completion: nil)
            
        })
        
        let actionThree = MDCActionSheetAction(title: "Race", image: UIImage(named: "Email"), handler: { (action) in print("\(action.title) action")
            
            let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "Race") as! ViewController
            self.present(ViewController, animated: true, completion: nil)
            
        })
        
        let actionFour = MDCActionSheetAction(title: "The Track", image: UIImage(named: "Email"), handler: { (action) in print("\(action.title) action")
            
            let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let TheTrack = mainStoryBoard.instantiateViewController(withIdentifier: "TheTrack") as! TheTrack
            self.present(TheTrack, animated: true, completion: nil)
            
        })
        
        
        actionSheet.addAction(actionOne)
        actionSheet.addAction(actionTwo)
        actionSheet.addAction(actionThree)
        actionSheet.addAction(actionFour)
        
        
        present(actionSheet, animated: true, completion: nil)
    }
}
