//
//  DoExerciseCell.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 3/27/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import AVKit

class DoExerciseCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var lbOrdinal: UILabel!
    @IBOutlet weak var lbNameExercise: UILabel!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var circularProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var imgGuide: UIImageView!
    @IBOutlet weak var lbCountDown: UILabel!
    @IBOutlet weak var viewAdjustPlay: RoundedView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var btnDescription: UIButton!
    @IBOutlet weak var btnDoneDes: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    // MARK: - Variables
    var isPlaying = false
    var isPause = false
    var haveSound = true
    var positionExercise = 0
    var countDownTimer = Timer()
    var timer: DispatchSourceTimer?
    var timerProgress: DispatchSourceTimer?
    var total = 30
    var listImage: [UIImage] = []
    
    var resizeCellClosure: ((Bool) -> Void)?
   
    // MARK: - View life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewAdjustPlay.isHidden = true
        viewDescription.isHidden = true
        setUpFirstUI()
        btnBack.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.timer?.cancel()
        self.layer.backgroundColor = UIColor(red: 60, green: 179, blue: 113).cgColor
        isPlaying = !isPlaying
        if let resize = resizeCellClosure {
            resize(isPlaying)
            
        }
    }
    
    // MARK: - setup
    
    func setUpFirstUI() {
        // btn Sound
        btnSound.setImage(UIImage(named: "ic_volume"), for: .normal)
        btnSound.isHidden = false
        
        // circular progressbar
        circularProgressBar.value = 30
        
        // circular image guide
//        imgGuide.layer.masksToBounds = false
//        imgGuide.layer.backgroundColor = UIColor.white.cgColor
//        imgGuide.layer.cornerRadius = imgGuide.frame.width / 2
//        imgGuide.clipsToBounds = true
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "big_arm_circle", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        imgGuide.image = advTimeGif
//        let imageView2 = UIImageView(image: advTimeGif)
//        imageView2.frame = CGRect(x: 20.0, y: 220.0, width:
//            self.view.frame.size.width - 40, height: 150.0)
//        view.addSubview(imageView2)
        
        // view
        viewAdjustPlay.isHidden = false
        viewDescription.isHidden = true
        
        lbCountDown.isHidden = true
        
        // list image
        listImage = createImageArray(listName: ["bent_elbow_shoulder_circle_1", "bent_elbow_shoulder_circle_2", "bent_elbow_shoulder_circle_3"])
        animate(imageView: imgGuide, images: listImage)
    }
    func setUpCell(exercise: Exercise, isPlaying: Bool, resizeCellClosure: @escaping ((Bool) -> Void)) {
        lbNameExercise.text = exercise.name
        self.resizeCellClosure = resizeCellClosure
        if isPlaying {
            viewAdjustPlay.isHidden = true
            lbCountDown.isHidden = false
        } else {
            viewAdjustPlay.isHidden = false
            lbCountDown.isHidden = true
        }
    }
    
    // MARK: - actions
    @objc
    func backAction() {
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func descriptionAction(_ sender: UIButton) {
        switch sender {
        case btnDescription:
            viewDescription.isHidden = false
            btnDoneDes.isHidden = false
        default:
            viewDescription.isHidden = true
        }
    }
    
    @IBAction func setSoundAction(_ sender: UIButton) {
        haveSound = !haveSound
        if haveSound {
            btnSound.setImage(UIImage(named: "ic_volume"), for: .normal)
        } else {
            btnSound.setImage(UIImage(named: "ic_volume_off"), for: .normal)
        }
    }
    @IBAction func controlExerciseAction(_ sender: UIButton) {
        switch sender {
        case btnPrevious:
            print()
        case btnNext:
            print("")
        default:
            doExercise()
        }
    }
    
    // MARK: - update UI
    func doExercise() {
        isPlaying = true
        if let resize = resizeCellClosure {
            resize(isPlaying)
        }
        
        animate(imageView: imgGuide, images: listImage)
        startTimer()
    }
    
    func updateCell(isPlaying: Bool) {
        print("begin update")
        if isPlaying {
            setView(view: viewAdjustPlay, hidden: true)
            setView(view: viewDescription, hidden: true)
            lbCountDown.isHidden = false
        } else {
            setView(view: viewAdjustPlay, hidden: false)
            setView(view: viewDescription, hidden: true)
            lbCountDown.isHidden = true
        }
//        pauseLayer(layer: circularProgressBar.layer)
        timer?.cancel()
    }
    
    // MARK: - methods support
    func animate(imageView: UIImageView, images: [UIImage]) {
        DispatchQueue.main.async {
            print("animate Image view\(images.count)")
            imageView.animationImages = images
            imageView.animationDuration = 1.75
            imageView.animationRepeatCount = 10
            imageView.startAnimating()
        }
    }
    
    func createImageArray(listName: [String]) -> [UIImage] {
        var imageArray: [UIImage] = []
        
        for name in listName {
            let name = "\(name).png"
            let image = UIImage(named: name)!
            imageArray.append(image)
        }
        
        return imageArray
    }
    
    func setView(view: UIView, hidden: Bool) {
        
        UIView.transition(with: view, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            view.isHidden = hidden
        })
    }
   
    private func startTimer() {
        
        let queue = DispatchQueue(label: "timer", attributes: .concurrent)
        
        timer?.cancel()// cancel previous timer if any
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: .milliseconds(1000), leeway: .milliseconds(10))
        timer?.setEventHandler {// `[weak self]` only needed if you reference `self` in this closure and you want to prevent strong reference cycle
            self.total = self.total - 1
            if self.total <  0 {
                self.total = 30
            }
            
            DispatchQueue.main.async {
                self.lbCountDown.text = String(self.total)
                UIView.animate(withDuration: 1.0, animations: {
                    self.circularProgressBar.value = CGFloat(integerLiteral: self.total)
                    print("count down progress bar")
                })
                
                self.animate(imageView: self.imgGuide, images: self.listImage)
            }
        }
        
        timer?.resume()
    }
    
    private func stopTimer() {
        print("stop timer")
        timer?.cancel()
        timer = nil
    }
}
