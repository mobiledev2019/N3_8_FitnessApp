//
//  DoExerciseCell.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 3/27/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import AVFoundation

protocol DoExerciseDelegate: class {
    func backClosure()
    func resizeCell(isBig: Bool)
    func changeExercise(jump: Int)
}

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
    @IBOutlet weak var tvDes: UITextView!
    
    // MARK: - Variables
    weak var delegate: DoExerciseDelegate?
    weak var player: AVAudioPlayer?
    weak var exercise: ExerciseClass?
    var isPause = false
    var haveSound = true
    var positionExercise = 0
    var countDownTimer = Timer()
    var timer: DispatchSourceTimer?
    var timerProgress: DispatchSourceTimer?
    var total = 30
    
    // MARK: - View life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewAdjustPlay.isHidden = true
        viewDescription.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.timer?.cancel()
        self.layer.backgroundColor = UIColor(red: 60, green: 179, blue: 113).cgColor
        setUpCellNotPlaying()
        delegate?.resizeCell(isBig: false)
//        if isPlaying {
//            setUpCellPlaying()
//            delegate?.resizeCell(isBig: true)
//        } else {
//            setUpCellNotPlaying()
//            delegate?.resizeCell(isBig: false)
//        }
    }
    
    // MARK: - setup
    
    func setUpFirstUI() {
        lbNameExercise.text = exercise?.name
        // btn Sound
        btnSound.setImage(UIImage(named: "ic_volume"), for: .normal)
        btnSound.isHidden = false
        
        // circular progressbar
        circularProgressBar.value = 30
        
        // circular image guide
        imgGuide.layer.masksToBounds = false
        imgGuide.layer.backgroundColor = UIColor.white.cgColor
        imgGuide.layer.cornerRadius = imgGuide.frame.height / 2
        imgGuide.clipsToBounds = true
        
        // view
        setUpCellNotPlaying()
        
//        playSound()
    }
    
    func setUpCell(exercise: Exercise) {
        lbNameExercise.text = exercise.name
        setUpCellNotPlaying()
    }
    
    func setUpCellPlaying() {
        viewAdjustPlay.isHidden = true
        lbCountDown.isHidden = false
    }
    
    func setUpCellNotPlaying() {
        print("view not playing")
        viewAdjustPlay.isHidden = false
        lbCountDown.isHidden = true
        viewDescription.isHidden = true
        self.imgGuide.layer.removeAllAnimations()
    }
    
    func setUpCellDes() {
        viewDescription.isHidden = false
        viewAdjustPlay.isHidden = true
        lbCountDown.isHidden = true
        tvDes.text = exercise?.des
    }
    
    // MARK: - actions
    @IBAction func backAction(_ sender: UIButton) {
        stopTimer()
        delegate?.backClosure()
    }
    
    @IBAction func descriptionAction(_ sender: UIButton) {
        switch sender {
        case btnDescription:
            setUpCellDes()
            delegate?.resizeCell(isBig: true)
        default:
            setUpCellNotPlaying()
            delegate?.resizeCell(isBig: false)
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
            stopTimer()
            delegate?.changeExercise(jump: -1)
        case btnNext:
            stopTimer()
            delegate?.changeExercise(jump: 1)
        default:
            doExercise()
        }
    }
    
    // MARK: - update UI
    func doExercise() {
        setUpCellPlaying()
        delegate?.resizeCell(isBig: true)
        startTimer()
    }
    
    func updateCell(isPlaying: Bool) {
        if isPlaying {
            setView(view: viewAdjustPlay, hidden: true)
            setView(view: viewDescription, hidden: true)
            lbCountDown.isHidden = false
            animateImageView()
        } else {
            setView(view: viewAdjustPlay, hidden: false)
            setView(view: viewDescription, hidden: true)
            lbCountDown.isHidden = true
            self.imgGuide.layer.removeAllAnimations()
        }
        timer?.cancel()
    }
    
    // MARK: - methods support
    func animate(imageView: UIImageView, images: [UIImage]) {
        
//        DispatchQueue.main.async {
//            print("animate Image view\(images.count)")
//            imageView.animationImages = images
//            imageView.animationDuration = 1.75
//            imageView.animationRepeatCount = 10
//            imageView.startAnimating()
//        }
    }
    
    func animateImageView() {
        
        let namer = String((exercise?.gif_phone?.dropLast(4))!)
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: namer, withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        imgGuide.image = advTimeGif
    }
    
    func playSound() {
        guard haveSound else {
            return
        }
        
        let path = exercise?.sound?.dropLast(4)
        guard let url = Bundle.main.url(forResource: "wall_sit", withExtension: "mp3") else { return }
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else {
                print("can not play this sound")
                return
                
            }
            
            player.play()
            print("play sound")
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
//    func createImageArray(listName: [String]) -> [UIImage] {
//        var imageArray: [UIImage] = []
//
//        for name in listName {
//            let name = "\(name).png"
//            let image = UIImage(named: name)!
//            imageArray.append(image)
//        }
//
//        return imageArray
//    }
    
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
//            if self.total == 30 {
//                self.playSound()
//            }
            self.total = self.total - 1
            if self.total <  0 {
                self.total = 30
            }
            
            DispatchQueue.main.async {
                self.lbCountDown.text = String(self.total)
                self.animateImageView()
                UIView.animate(withDuration: 1.0, animations: {
                    self.circularProgressBar.value = CGFloat(integerLiteral: self.total)
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
}
