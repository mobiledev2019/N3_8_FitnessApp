//
//  ExerciseVC.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 3/22/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class ExerciseVC: BaseVC {

    // MARK: - Outlets
    @IBOutlet weak var tableExercise: BaseTableView!
    
    // MARK: - Variables
    var exer = Exercise(name: "Arm", pathVideo: "5_f")
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpTable()
        
    }
    
    // MARK: - setup
    func setUpTable() {
        tableExercise.registerNibCellFor(type: DoExerciseCell.self)
        tableExercise.registerNibCellFor(type: ExerciseCell.self)
        tableExercise.dataSource = self
        tableExercise.delegate = self
    }
    
    func setUpData() {
        let fileJson = Bundle.main.path(forResource: "ExerciseJson", ofType: "txt")
        var content = ""
        
        do {
            if let path = fileJson {
                content = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
//                print("content date : \(content)" )
            }
        } catch let err as NSError {
            print("err: \(err)")
        }
        
        do {
            // data we are getting from network request
            let decoder = JSONDecoder()
            let content2 = """
                            [{"name":"7M BEGINNER","level":"Beginner","pic_pad":"7m_beginner.webp","pic_phone":"7m_beginner.webp","brief":"This is a beginner friendly version of the classic 7 minute workout. We have replaced the harder exercises with alternatives that should be easier to perform.","order":1,"time":7,"exercises":[{"get_ready":10,"switch_side":false,"id":156,"time_span":30},{"get_ready":10,"switch_side":false,"id":135,"time_span":20},{"get_ready":10,"switch_side":false,"id":77,"time_span":20},{"get_ready":10,"switch_side":false,"id":44,"time_span":20},{"get_ready":10,"switch_side":false,"id":100,"time_span":20},{"get_ready":10,"switch_side":false,"id":98,"time_span":20},{"get_ready":10,"switch_side":false,"id":56,"time_span":30},{"get_ready":10,"switch_side":false,"id":134,"time_span":20},{"get_ready":10,"switch_side":false,"id":136,"time_span":30},{"get_ready":10,"switch_side":false,"id":159,"time_span":20},{"get_ready":10,"switch_side":true,"id":160,"time_span":20},{"get_ready":10,"switch_side":false,"id":61,"time_span":30},{"get_ready":10,"switch_side":false,"id":111,"time_span":20},{"get_ready":10,"switch_side":true,"id":110,"time_span":20}],"calorie":28,"type":"Normal","id":96},{"name":"7M CLASSIC","level":"Beginner","pic_pad":"7m_classic.webp","pic_phone":"7m_classic.webp","brief":"The classic 7 minute workout. Scientifically proven to improve health and fitness.","order":2,"time":7,"exercises":[{"get_ready":10,"switch_side":false,"id":33,"time_span":30},{"get_ready":10,"switch_side":false,"id":116,"time_span":30},{"get_ready":10,"switch_side":false,"id":115,"time_span":30},{"get_ready":10,"switch_side":false,"id":40,"time_span":30},{"get_ready":10,"switch_side":false,"id":114,"time_span":30},{"get_ready":10,"switch_side":false,"id":113,"time_span":30},{"get_ready":10,"switch_side":false,"id":125,"time_span":30},{"get_ready":10,"switch_side":false,"id":41,"time_span":30},{"get_ready":10,"switch_side":false,"id":72,"time_span":30},{"get_ready":10,"switch_side":false,"id":28,"time_span":15},{"get_ready":10,"switch_side":true,"id":29,"time_span":15},{"get_ready":10,"switch_side":false,"id":112,"time_span":30},{"get_ready":10,"switch_side":false,"id":111,"time_span":15},{"get_ready":10,"switch_side":true,"id":110,"time_span":15}],"calorie":41,"type":"Normal","id":3},{"name":"7M ABS","level":"Beginner","pic_pad":"7m_abs.webp","pic_phone":"7m_abs.webp","brief":"Want washboard abs? This is the workout for you. A short workout that targets every part of your abs.","order":3,"time":7,"exercises":[{"get_ready":10,"switch_side":false,"id":33,"time_span":30},{"get_ready":10,"switch_side":false,"id":44,"time_span":30},{"get_ready":10,"switch_side":false,"id":41,"time_span":30},{"get_ready":10,"switch_side":false,"id":37,"time_span":30},{"get_ready":10,"switch_side":false,"id":45,"time_span":30},{"get_ready":10,"switch_side":false,"id":46,"time_span":30},{"get_ready":10,"switch_side":false,"id":47,"time_span":30},{"get_ready":10,"switch_side":false,"id":111,"time_span":20},{"get_ready":10,"switch_side":true,"id":110,"time_span":20},{"get_ready":10,"switch_side":false,"id":40,"time_span":30},{"get_ready":10,"switch_side":false,"id":42,"time_span":30},{"get_ready":10,"switch_side":false,"id":49,"time_span":30}],"calorie":42,"type":"Normal","id":4},{"name":"7M SWEAT","level":"Beginner","pic_pad":"7m_sweat.webp","pic_phone":"7m_sweat.webp","brief":"High intensity workout that will get your heart rate up and make you sweat. Workout less but lose more!","order":4,"time":7,"exercises":[{"get_ready":10,"switch_side":false,"id":33,"time_span":30},{"get_ready":10,"switch_side":false,"id":72,"time_span":30},{"get_ready":10,"switch_side":false,"id":41,"time_span":30},{"get_ready":10,"switch_side":false,"id":127,"time_span":30},{"get_ready":10,"switch_side":false,"id":18,"time_span":20},{"get_ready":10,"switch_side":true,"id":19,"time_span":20},{"get_ready":10,"switch_side":false,"id":74,"time_span":30},{"get_ready":10,"switch_side":false,"id":46,"time_span":30},{"get_ready":10,"switch_side":false,"id":114,"time_span":30},{"get_ready":10,"switch_side":false,"id":47,"time_span":30},{"get_ready":10,"switch_side":false,"id":109,"time_span":30},{"get_ready":10,"switch_side":false,"id":34,"time_span":30}],"calorie":54,"type":"Normal","id":5},{"name":"7M TABATA","level":"Beginner","pic_pad":"7m_hiit.webp","pic_phone":"7m_hiit.webp","brief":"A tabata inspired workout that includes a warmup and cooldown. Although short, this workout is intense. Make sure you are physically fit before attempting.","order":5,"time":7,"exercises":[{"get_ready":10,"switch_side":false,"id":78,"time_span":30},{"get_ready":10,"switch_side":false,"id":33,"time_span":30},{"get_ready":10,"switch_side":false,"id":83,"time_span":30},{"get_ready":10,"switch_side":false,"id":120,"time_span":20},{"get_ready":10,"switch_side":false,"id":84,"time_span":20},{"get_ready":10,"switch_side":false,"id":127,"time_span":20},{"get_ready":10,"switch_side":false,"id":72,"time_span":20},{"get_ready":0,"switch_side":false,"id":129,"time_span":30},{"get_ready":10,"switch_side":false,"id":120,"time_span":20},{"get_ready":10,"switch_side":false,"id":84,"time_span":20},{"get_ready":10,"switch_side":false,"id":127,"time_span":20},{"get_ready":10,"switch_side":false,"id":72,"time_span":20},{"get_ready":10,"switch_side":false,"id":104,"time_span":20},{"get_ready":10,"switch_side":true,"id":103,"time_span":20}],"calorie":49,"type":"Normal","id":30},{"name":"7M COMPLETE","level":"Advanced","pic_pad":"7m_complete.webp","pic_phone":"7m_complete.webp","brief":"This is the classic 7 minute workout, but done 3 times in a row. Doing this complete workout will help you hit the doctor recommended 20 minutes of exercise a day for better health.","order":6,"time":26,"exercises":[{"get_ready":10,"switch_side":false,"id":33,"time_span":30},{"get_ready":10,"switch_side":false,"id":116,"time_span":30},{"get_ready":10,"switch_side":false,"id":115,"time_span":30},{"get_ready":10,"switch_side":false,"id":40,"time_span":30},{"get_ready":10,"switch_side":false,"id":114,"time_span":30},{"get_ready":10,"switch_side":false,"id":113,"time_span":30},{"get_ready":10,"switch_side":false,"id":125,"time_span":30},{"get_ready":10,"switch_side":false,"id":41,"time_span":30},{"get_ready":10,"switch_side":false,"id":72,"time_span":30},{"get_ready":10,"switch_side":false,"id":28,"time_span":15},{"get_ready":10,"switch_side":true,"id":29,"time_span":15},{"get_ready":10,"switch_side":false,"id":112,"time_span":30},{"get_ready":10,"switch_side":false,"id":111,"time_span":15},{"get_ready":10,"switch_side":true,"id":110,"time_span":15},{"get_ready":0,"switch_side":false,"id":129,"time_span":30},{"get_ready":10,"switch_side":false,"id":33,"time_span":30},{"get_ready":10,"switch_side":false,"id":116,"time_span":30},{"get_ready":10,"switch_side":false,"id":115,"time_span":30},{"get_ready":10,"switch_side":false,"id":40,"time_span":30},{"get_ready":10,"switch_side":false,"id":114,"time_span":30},{"get_ready":10,"switch_side":false,"id":113,"time_span":30},{"get_ready":10,"switch_side":false,"id":125,"time_span":30},{"get_ready":10,"switch_side":false,"id":41,"time_span":30},{"get_ready":10,"switch_side":false,"id":72,"time_span":30},{"get_ready":10,"switch_side":false,"id":28,"time_span":15},{"get_ready":10,"switch_side":true,"id":29,"time_span":15},{"get_ready":10,"switch_side":false,"id":112,"time_span":30},{"get_ready":10,"switch_side":false,"id":111,"time_span":15},{"get_ready":10,"switch_side":true,"id":110,"time_span":15},{"get_ready":0,"switch_side":false,"id":129,"time_span":30},{"get_ready":10,"switch_side":false,"id":33,"time_span":30},{"get_ready":10,"switch_side":false,"id":116,"time_span":30},{"get_ready":10,"switch_side":false,"id":115,"time_span":30},{"get_ready":10,"switch_side":false,"id":40,"time_span":30},{"get_ready":10,"switch_side":false,"id":114,"time_span":30},{"get_ready":10,"switch_side":false,"id":113,"time_span":30},{"get_ready":10,"switch_side":false,"id":125,"time_span":30},{"get_ready":10,"switch_side":false,"id":41,"time_span":30},{"get_ready":10,"switch_side":false,"id":72,"time_span":30},{"get_ready":10,"switch_side":false,"id":28,"time_span":15},{"get_ready":10,"switch_side":true,"id":29,"time_span":15},{"get_ready":10,"switch_side":false,"id":112,"time_span":30},{"get_ready":10,"switch_side":false,"id":111,"time_span":15},{"get_ready":10,"switch_side":true,"id":110,"time_span":15}],"calorie":124,"type":"Normal","id":31},{"name":"CORE","level":"Beginner","pic_pad":"core.webp","pic_phone":"core.webp","brief":"","order":7,"time":10,"exercises":[{"get_ready":10,"switch_side":false,"id":41,"time_span":30},{"get_ready":10,"switch_side":false,"id":81,"time_span":30},{"get_ready":10,"switch_side":false,"id":52,"time_span":30},{"get_ready":10,"switch_side":false,"id":49,"time_span":30},{"get_ready":10,"switch_side":false,"id":48,"time_span":30},{"get_ready":10,"switch_side":false,"id":117,"time_span":30},{"get_ready":10,"switch_side":false,"id":50,"time_span":30},{"get_ready":10,"switch_side":false,"id":22,"time_span":30},{"get_ready":10,"switch_side":false,"id":40,"time_span":30},{"get_ready":10,"switch_side":false,"id":53,"time_span":30},{"get_ready":10,"switch_side":false,"id":161,"time_span":30},{"get_ready":10,"switch_side":false,"id":32,"time_span":30},{"get_ready":10,"switch_side":false,"id":42,"time_span":30},{"get_ready":10,"switch_side":false,"id":91,"time_span":30},{"get_ready":10,"switch_side":false,"id":55,"time_span":30}],"calorie":51,"type":"Custom","id":29},{"name":"UPPER BODY","level":"Beginner","pic_pad":"upper_body.webp","pic_phone":"upper_body.webp","brief":"","order":8,"time":10,"exercises":[{"get_ready":10,"switch_side":false,"id":102,"time_span":30},{"get_ready":10,"switch_side":false,"id":78,"time_span":30},{"get_ready":10,"switch_side":false,"id":147,"time_span":30},{"get_ready":10,"switch_side":false,"id":68,"time_span":30},{"get_ready":10,"switch_side":false,"id":125,"time_span":30},{"get_ready":10,"switch_side":false,"id":82,"time_span":30},{"get_ready":10,"switch_side":false,"id":61,"time_span":30},{"get_ready":10,"switch_side":false,"id":77,"time_span":30},{"get_ready":10,"switch_side":false,"id":76,"time_span":30},{"get_ready":10,"switch_side":false,"id":115,"time_span":30},{"get_ready":10,"switch_side":false,"id":112,"time_span":30},{"get_ready":10,"switch_side":false,"id":67,"time_span":30},{"get_ready":10,"switch_side":false,"id":75,"time_span":30},{"get_ready":10,"switch_side":false,"id":56,"time_span":30},{"get_ready":10,"switch_side":false,"id":170,"time_span":30}],"calorie":43,"type":"Custom","id":28},{"name":"LOWER BODY","level":"Beginner","pic_pad":"lower_body.webp","pic_phone":"lower_body.webp","brief":"","order":9,"time":10,"exercises":[{"get_ready":10,"switch_side":false,"id":98,"time_span":30},{"get_ready":10,"switch_side":false,"id":116,"time_span":30},{"get_ready":10,"switch_side":false,"id":113,"time_span":30},{"get_ready":10,"switch_side":false,"id":13,"time_span":30},{"get_ready":10,"switch_side":false,"id":133,"time_span":30},{"get_ready":10,"switch_side":false,"id":130,"time_span":30},{"get_ready":10,"switch_side":false,"id":26,"time_span":30},{"get_ready":10,"switch_side":false,"id":27,"time_span":30},{"get_ready":10,"switch_side":false,"id":14,"time_span":30},{"get_ready":10,"switch_side":false,"id":120,"time_span":30},{"get_ready":10,"switch_side":false,"id":37,"time_span":30},{"get_ready":10,"switch_side":false,"id":23,"time_span":30},{"get_ready":10,"switch_side":false,"id":132,"time_span":30},{"get_ready":10,"switch_side":false,"id":15,"time_span":30},{"get_ready":10,"switch_side":false,"id":131,"time_span":30}],"calorie":55,"type":"Custom","id":27},{"name":"TOTAL BODY","level":"Intermediate","pic_pad":"total_body.webp","pic_phone":"total_body.webp","brief":"","order":10,"time":10,"exercises":[{"get_ready":10,"switch_side":false,"id":97,"time_span":30},{"get_ready":10,"switch_side":false,"id":156,"time_span":30},{"get_ready":10,"switch_side":false,"id":108,"time_span":30},{"get_ready":10,"switch_side":false,"id":72,"time_span":30},{"get_ready":10,"switch_side":false,"id":33,"time_span":30},{"get_ready":10,"switch_side":false,"id":79,"time_span":30},{"get_ready":10,"switch_side":false,"id":44,"time_span":30},{"get_ready":10,"switch_side":false,"id":34,"time_span":30},{"get_ready":10,"switch_side":false,"id":105,"time_span":30},{"get_ready":10,"switch_side":false,"id":127,"time_span":30},{"get_ready":10,"switch_side":false,"id":35,"time_span":30},{"get_ready":10,"switch_side":false,"id":87,"time_span":30},{"get_ready":10,"switch_side":false,"id":107,"time_span":30},{"get_ready":10,"switch_side":false,"id":84,"time_span":30},{"get_ready":10,"switch_side":false,"id":47,"time_span":30}],"calorie":78,"type":"Custom","id":26}]
"""
            let data = content2.data(using: .utf8)
            let response = try decoder.decode([Json4Swift_Base].self, from: data!)
            print("reponse: \(response[0].brief)") //Output - EMT
        } catch { print(error) }
    }
}

extension ExerciseVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: DoExerciseCell.self, indexPath: indexPath) {
                cell.setUpCell(exercise: exer, isPlaying: isPlaying, resizeCellClosure: { isPlay in
                    self.isPlaying = isPlay
                    tableView.beginUpdates()
                    cell.updateCell(isPlaying: isPlay)
                    tableView.endUpdates()
                } )
                cell.animate(imageView: cell.imgGuide, images: cell.listImage)
                
                return cell
            }
        }
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: ExerciseCell.self, indexPath: indexPath) {
            cell.setUpCell(ex: exer)
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0, let cell = cell as? DoExerciseCell {
            cell.updateCell(isPlaying: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return isPlaying ? self.view.safeAreaLayoutGuide.layoutFrame.size.height: (self.view.safeAreaLayoutGuide.layoutFrame.size.height - 170)
        }
        return 80
    }
    
}
