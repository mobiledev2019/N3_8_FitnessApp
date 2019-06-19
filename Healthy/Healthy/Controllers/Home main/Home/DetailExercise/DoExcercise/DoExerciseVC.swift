//
//  DoExerciseVC.swift
//  Healthy
//
//  Created by Phuong_Nguyen on 5/7/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import UserNotifications
import AVFoundation
import RealmSwift

protocol DoExerciseDelegate {
    func changeExercise(jump: Int, vc: DoExerciseVC)
}

class DoExerciseVC: BaseVC, UNUserNotificationCenterDelegate {

    //MARK: - Outlets
    @IBOutlet weak var progress: MBCircularProgressBarView!
    @IBOutlet weak var imgGuide: UIImageView!
    @IBOutlet weak var lbCountDown: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tvDes: UITextView!
    @IBOutlet weak var viewAdjust: UIView!
    @IBOutlet weak var viewDes: UIView!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnDes: UIButton!
    @IBOutlet weak var btnGotDes: UIButton!
    
    // MARK: - Variables
    var player: AVAudioPlayer?
    weak var exercise: ExerciseClass?
    var isPause = false
    var haveSound = true
    var positionExercise = 0
    var timer: DispatchSourceTimer?
    var total = 30
    
    var complete = 0.0
    
    var delegate: DoExerciseDelegate?
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        
        // Do any additional setup after loading the view.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        
        //detect app in background
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateViewHidden(hideLbCountDown: true, hideViewAdjust: false, hideViewDes: true)
        
        timer?.cancel()
        imgGuide.layer.removeAllAnimations()
        if let name = exercise?.gif_phone {
            imgGuide.image = UIImage.getCoverImage(name: name)
        }
    }
    
    //MARK: - setup
    func setUpUI() {
        
        print(exercise)
        //title
        lbName.text = exercise?.name
        //progress
        progress.value = 0;
        //image guide
        imgGuide.layer.masksToBounds = false
        imgGuide.layer.backgroundColor = UIColor.white.cgColor
        imgGuide.layer.cornerRadius = imgGuide.frame.height / 2
        imgGuide.clipsToBounds = true
        if let ex = exercise, let gif = ex.gif_phone {
            imgGuide.image = UIImage.getCoverImage(name: gif)
        }
        
        //lb countdown
        lbCountDown.text = "30"
        //view adjust
        //view description
        tvDes.text = exercise?.des
        //cover view
        updateViewHidden(hideLbCountDown: true, hideViewAdjust: false, hideViewDes: true)
        
    }
    
    //MARK: - actions
    @IBAction func soundAction(_ sender: UIButton) {
        print("action sound")
        haveSound = !haveSound
        if haveSound {
            sender.setImage(UIImage(named: "ic_volume_up"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic_volume_off"), for: .normal)
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        saveDataComplete()
        stopTimer()
        VCService.pop()
    }
    
    @IBAction func adjustAction(_ sender: UIButton) {
        switch sender {
        case btnPrevious:
            saveDataComplete()
            stopTimer()
            delegate?.changeExercise(jump: -1, vc: self)
        case btnNext:
            saveDataComplete()
            stopTimer()
            delegate?.changeExercise(jump: 1, vc: self)
        default:
            play()
        }
    }
    
    @IBAction func gotDescAction(_ sender: UIButton) {
        switch sender {
        case btnDes:
            timer?.cancel()
            imgGuide.layer.removeAllAnimations()
            if let name = exercise?.gif_phone {
                imgGuide.image = UIImage.getCoverImage(name: name)
            }
            updateViewHidden(hideLbCountDown: true, hideViewAdjust: true, hideViewDes: false)
        default:
            updateViewHidden(hideLbCountDown: true, hideViewAdjust: false, hideViewDes: true)
        }
        
    }
    
    //MARK: - updateUI
    func updateViewHidden(hideLbCountDown: Bool, hideViewAdjust: Bool, hideViewDes: Bool) {
        lbCountDown.isHidden = hideLbCountDown
        viewAdjust.isHidden = hideViewAdjust
        viewDes.isHidden = hideViewDes
    }
    
    func updateUIChangeExercise() {
        lbName.text = exercise?.name
        
        progress.value = 0;
        
        if let name = exercise?.gif_phone {
            imgGuide.image = UIImage.getCoverImage(name: name)
        }
        
        updateViewHidden(hideLbCountDown: false, hideViewAdjust: true, hideViewDes: true)
        
    }
    
    //MARK: - methods support
    func saveDataComplete() {
        let com = ((30 - Double(total)) / 30) / 81 *  100
        if let re = RealmManager.shareInstance.getResultCurrentDay() {
            let realm = try! Realm()
            try! realm.write {
                re.complete += com
            }
        } else {
            let date = Date()
            var result = ResultClass()
            result.complete = com
            result.date = date
            result.owner_mail = RealmManager.shareInstance.getCurrentUser()?.email
            RealmManager.shareInstance.addNewResult(re: result)
        }
    }
    
    func changeExercise(ex: ExerciseClass) {
        stopTimer()
        exercise = ex
        total = 30
        updateUIChangeExercise()
        play()
    }
    func coutdown() {
        print("coutdown")
        
        UIView.animate(withDuration: 20) {
            print("run")
            self.progress.value = 30
        }
    }
    
    func play() {
        lbCountDown.isHidden = false
        viewAdjust.isHidden = true
        animateImageView()
        startTimer()
        
    }
    
    func playSound(sound: String?) {
        print(exercise)
        guard haveSound, let url = Bundle.main.url(forResource: sound, withExtension: "") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func animateImageView() {
//        let namer = String((exercise?.gif_phone?.dropLast(4))!)
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: exercise?.gif_phone, withExtension: "")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        imgGuide.image = advTimeGif
    }
    
    private func startTimer() {
        
        let queue = DispatchQueue(label: "timer", attributes: .concurrent)
        
        timer?.cancel()// cancel previous timer if any
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: .milliseconds(1000), leeway: .milliseconds(10))
        timer?.setEventHandler {// `[weak self]` only needed if you reference `self` in this
            
            if self.total == 30 {
                DispatchQueue.main.async {
                    self.playSound(sound: self.exercise?.sound)
                }
            }
            
            if self.total == 4 {
                DispatchQueue.main.async {
                    self.playSound(sound: "sys_countdown3.mp3")
                }
            }
            
            if self.total == 3 {
                DispatchQueue.main.async {
                    self.playSound(sound: "sys_countdown2.mp3")
                }
            }
            
            if self.total == 2 {
                DispatchQueue.main.async {
                    self.playSound(sound: "sys_countdown1.mp3")
                }
            }
            
            if self.total == 1 {
                DispatchQueue.main.async {
                    self.playSound(sound: "sys_nextstep.mp3")
                    self.saveDataComplete()
                }
                
            }
            
            self.total = self.total - 1
            
            if self.total <  0 {
                
//                self.stopTimer()
                DispatchQueue.main.async {
                    self.stopTimer()
                    self.delegate?.changeExercise(jump: 1, vc: self)
                }
               
            }
            
            DispatchQueue.main.async {
                self.lbCountDown.text = String(self.total)
                UIView.animate(withDuration: 1.0, animations: {
                    self.progress.value = CGFloat(integerLiteral: self.total)
                    print("count down progress bar")
                })
            }
            
        }
        
        timer?.resume()
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    func sendNotification(name: String?, seconds: Int?) {
        guard let name = name, let second = seconds else {
            return
        }
        let content = UNMutableNotificationContent()
//        content.title = "Fitness"
//        content.subtitle = "from ioscreator.com"
        content.body = "Bạn đang tập bài tập: \(name) ở giây thứ:\(second)"
        content.badge = 1
        content.sound = UNNotificationSound.default
        // 2
//        let imageName = "round_icon"
//        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
//
//        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
//
//        content.attachments = [attachment]
        
        // 3
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        // 4
        
        UNUserNotificationCenter.current().delegate = self
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        sendNotification(name: exercise?.name, seconds: total)
    }
    
}
