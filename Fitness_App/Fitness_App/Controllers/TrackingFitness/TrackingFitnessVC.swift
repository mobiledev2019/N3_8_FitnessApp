//
//  TrackingFitnessVC.swift
//  Fitness_App
//
//  Created by Anh Phuong on 4/22/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import Charts
class TrackingFitnessVC: UIViewController {


   
    @IBOutlet weak var viewChart: BarChartView!
    
    class func newNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: TrackingFitnessVC(nibName: "TrackingFitnessVC", bundle: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarChart()
        setChart()
    }
    
    private func setupBarChart() {
        viewChart.noDataText = "No data"
        viewChart.xAxis.labelPosition = .bottom
     //   set gia tri max, min
        viewChart.leftAxis.axisMinimum = 0.0
        viewChart.leftAxis.axisMaximum = 100.0
        // k cho phong to
        viewChart.scaleYEnabled = false
        viewChart.scaleXEnabled = false
        viewChart.pinchZoomEnabled = false
        viewChart.doubleTapToZoomEnabled = false
        
        // cham vao k highlight
        viewChart.highlighter = nil
        
        // an truc
        viewChart.rightAxis.enabled = false  // xoa hien thi label ben phai
        viewChart.xAxis.drawGridLinesEnabled = false
        // animation
        viewChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        //background
        viewChart.gridBackgroundColor = UIColor(hexa: "#F4F5FA")
        viewChart.drawGridBackgroundEnabled = true
    }
    private func setChart() {
        let results = createData()
        var resultsEntries = [ChartDataEntry]()
        var resultsDay = [String]()
        for (index,result) in results.enumerated() {
            let resultEntry = BarChartDataEntry(x:Double(index),y: result.complete ?? 0.0)
            resultsEntries.append(resultEntry)
            resultsDay.append(result.date ?? " nothing")
        }
        // Create bar chart data set containing salesEntries
        let chartDataSet = BarChartDataSet(values: resultsEntries, label: "Complete")
        chartDataSet.colors = [UIColor(hexa: "#00CED1")]
        
        // Create bar chart data with data set and array with values for x axis
        let chartData = BarChartData(dataSets: [chartDataSet])
        viewChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:resultsDay)
        // Set bar chart data to previously created data
        viewChart.data = chartData
        
    }
    
    //func test
    func createData() -> [Result]{
        var results: [Result] = []
        let dates: [String] = ["t2", "t3", "t4", "t5", "t6", "t7", "cn"]
        for da in dates {
            let result = Result(date: da, complete: Double(arc4random_uniform(100)))
            results.append(result)
        }
        return results
    }
}
