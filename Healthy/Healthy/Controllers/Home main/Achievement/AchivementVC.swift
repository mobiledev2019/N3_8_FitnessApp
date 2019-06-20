//
//  AchivementVC.swift
//  Healthy
//
//  Created by Phuong_Nguyen on 5/9/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FBSDKLoginKit

class AchivementVC: BaseVC {
    
    //MARK: - Outlets
    @IBOutlet weak var viewBtn: RoundedView!
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var lbShare: UILabel!
    @IBOutlet weak var lbNoValues: UILabel!
    
    //MARK: - variables
    var listResult = [ResultClass]()
     var btnShare = FBSDKShareButton()
    
    class func newNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: AchivementVC(nibName: "AchivementVC", bundle: nil))
    }

    //MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let user = RealmManager.shareInstance.getCurrentUser() else {
            lineChart.isHidden = true
            lbNoValues.isHidden = false
            lbNoValues.text = "You did skip login"
            return
        }
        btnShare.frame = CGRect(x: 0, y: 0, width: viewBtn.frame.width, height: viewBtn.frame.height)
        let photo = FBSDKSharePhoto()
//        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
//        let image = renderer.image { ctx in
//            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        }
//        photo.image = image

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            photo.image = image
        }
        
        photo.isUserGenerated = true
        //Your description here
        photo.caption = "this is caption"
        
        let content = FBSDKSharePhotoContent()
        content.photos = [photo]
        
        btnShare.shareContent = content
        
        lbShare.isHidden = true
        
        viewBtn.addSubview(btnShare)
    }

    //MARK: - setup
    func setUpData() {
        if let user = RealmManager.shareInstance.getCurrentUser(), let mail = user.email {
            listResult = RealmManager.shareInstance.getAllResult7DayLater(mail: mail)
        }
    }
    
    func setUpUI() {
        if listResult.count == 0 {
            hideChart()

        } else {
           showChart()
        }
        
//        lbNoValues.isHidden = true
//        let lables: [String] = ["4/5", "5/5", "6/5", "7/5", "8/5", "9/5", "10/5"]
//
//        lineChart.x.labels.values = lables
//        lineChart.addLine([10, 30, 50, 55, 70, 75, 90])
//        lineChart.dots.color = UIColor.Custom.AppMainDark
//        lineChart.dots.innerRadius = 16
//        lineChart.dots.outerRadius = 12
//        lineChart.colors = [UIColor.Custom.AppMainDark, UIColor.Custom.AppFirst]
//        lineChart.isHidden = false
    }
    
    //MARK: - method support
    func hideChart() {
        lbNoValues.isHidden = false
        let lables: [String] = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
        
        lineChart.x.labels.values = lables
        lineChart.addLine([10, 30, 50, 55, 70, 75, 90])
        lineChart.dots.color = UIColor.Custom.AppMainDark
        lineChart.dots.innerRadius = 16
        lineChart.dots.outerRadius = 12
        lineChart.colors = [UIColor.Custom.AppMainDark, UIColor.Custom.AppFirst]
        lineChart.isHidden = true
    }
    
    func showChart() {
        lbNoValues.isHidden = true
        var lableX = getDay()
        var valuesY = [CGFloat]()
        let listRe = getComplete()
        
        for value in listRe {
//            lableX.append(lable)
            valuesY.append(CGFloat(value))
        }
        //            let lables: [String] = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
        //            let labley: [String] = ["0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"]
        //
        lineChart.x.labels.values = lableX
        lineChart.addLine(valuesY)
        lineChart.dots.color = UIColor.Custom.AppMainDark
        lineChart.dots.innerRadius = 16
        lineChart.dots.outerRadius = 12
        lineChart.colors = [UIColor.Custom.AppMainDark, UIColor.Custom.AppSecond]
    }
    
    func getChartValues() -> [String: Double] {
        var re = [String: Double]()
        let count = listResult.count
        for _ in count..<6 {
            re["null"] = 0
        }
        for i in 0..<count {
            let result = listResult[i]
            if let date = result.date {
                re[date.toString(dateFormat: "dd/MM")] = result.complete
            }
        }
        
        print("---------------------------------------------------")
        print(re)
        
        return re
    }
    
    func getDay() -> [String] {
        let cal = Calendar.current
        let date = cal.startOfDay(for: Date())
        var days = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        for i in 0 ... 6 {
            let newdate = cal.date(byAdding: .day, value: -(6-i), to: date)!
            let str = dateFormatter.string(from: newdate)
            days.append(str)
        }
        
        return days
    }
    
    func getComplete() -> [Double] {
        var re = [Double]()
        let count = listResult.count
        for i in 0..<7-count{
            re.append(0)
        }
        for i in 0..<count {
            re.append(listResult[i].complete)
        }
        return re
    }
}

