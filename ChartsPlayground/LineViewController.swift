//
//  ViewController.swift
//  ChartsPlayground
//
//  Created by Suhayb Ahmad on 6/19/18.
//  Copyright © 2018 Imagine Technologies. All rights reserved.
//

import UIKit
import Charts

class LineViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var unitControl: UISegmentedControl!
    
    @IBOutlet weak var timeUnitStepper: TimeUnitStepper!
    @IBOutlet weak var lineChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let marker = BalloonMarker(color: UIColor.blue,
                                   font: UIFont.boldSystemFont(ofSize: 11),
                                   textColor: UIColor.white,
                                   insets: UIEdgeInsets(top: 5, left: 5, bottom: 16, right: 5))
        
        let dataSet = LineChartDataSet(values: [
            ChartDataEntry(x: 0, y: 100),
            ChartDataEntry(x: 1, y: 50),
            ChartDataEntry(x: 2, y: 30),
            ChartDataEntry(x: 3, y: 140),
            ChartDataEntry(x: 4, y: 160),
            ChartDataEntry(x: 5, y: 210),
            ChartDataEntry(x: 6, y: 340)
        ], label: "Cost")
        
        dataSet.setColor(UIColor.orange)
        dataSet.setCircleColor(UIColor.orange)
        dataSet.lineWidth = 3
        dataSet.circleHoleColor = UIColor.white
        dataSet.mode = .cubicBezier
        dataSet.cubicIntensity = 0.2
        dataSet.drawValuesEnabled = false
        dataSet.setDrawHighlightIndicators(false)
        
        let lineData = LineChartData(dataSet: dataSet)
        
        lineChart.legend.enabled = false
        lineChart.chartDescription?.enabled = false
        lineChart.backgroundColor = UIColor.clear
        lineChart.marker = marker
        lineChart.delegate = self
        lineChart.data = lineData
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, axis) -> String in
            let days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
            let vl = Int(value)
            return days[vl]
        })
        
        lineChart.setExtraOffsets(left: 5, top: 0, right: 20, bottom: 20)
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.drawAxisLineEnabled = false
        
    }
    
    var selectedIndex = 0
    
    @IBAction func switchSelection(_ sender: Any) {
        
        let alert = UIAlertController(title: "Select Report Type", message: "Select Report Type", preferredStyle: .actionSheet)
        
        let handler:((UIAlertAction) -> Void) = { (action) in
            self.selectedIndex = (action as! AlertAction).index
        }
        
        let option1 = AlertAction(title: "Option 1", style: .default, handler: handler)
        let option2 = AlertAction(title: "Option 2", style: .default, handler: handler)
        let option3 = AlertAction(title: "Option 3", style: .default, handler: handler)
        
        option1.index = 0
        option2.index = 1
        option3.index = 2
        
        switch self.selectedIndex {
        case 0:
            option1.setValue(#imageLiteral(resourceName: "baseline_check_black_24pt"), forKey: "image")
        case 1:
            option2.setValue(#imageLiteral(resourceName: "baseline_check_black_24pt"), forKey: "image")
        case 2:
            option3.setValue(#imageLiteral(resourceName: "baseline_check_black_24pt"), forKey: "image")
        default:
            break
        }
        
        alert.addAction(option1)
        alert.addAction(option2)
        alert.addAction(option3)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lineChart.animate(xAxisDuration: 0.4, easingOption: .easeInCubic)
    }
    
    @IBAction func unitChanged(_ sender: Any) {
        
        switch self.unitControl.selectedSegmentIndex {
        case 0:
            self.timeUnitStepper.unit = .day
        case 1:
            self.timeUnitStepper.unit = .week
        case 2:
            self.timeUnitStepper.unit = .month
        case 3:
            self.timeUnitStepper.unit = .quarter
        case 4:
            self.timeUnitStepper.unit = .year
        default:
            break
        }
    }
}

class AlertAction: UIAlertAction {
    
    var index:Int = -1
}

