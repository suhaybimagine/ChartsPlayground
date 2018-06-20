//
//  BarViewController.swift
//  ChartsPlayground
//
//  Created by Suhayb Ahmad on 6/19/18.
//  Copyright © 2018 Imagine Technologies. All rights reserved.
//

import UIKit
import Charts

class BarViewController: UIViewController {
    
    @IBOutlet weak var barChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let marker = BalloonMarker(color: UIColor.blue,
                                   font: UIFont.boldSystemFont(ofSize: 11),
                                   textColor: UIColor.white,
                                   insets: UIEdgeInsets(top: 5, left: 5, bottom: 16, right: 5))
        marker.valueFormatter = MarkerValueFormatter(block: { (value) -> String in
            let nf = NumberFormatter()
            nf.maximumFractionDigits = 0
            nf.numberStyle = .percent
            
            return nf.string(from: NSNumber(value: value))!
        })
        
        let dataSet = BarChartDataSet(values: [
            BarChartDataEntry(x: 2012, y: 1),
            BarChartDataEntry(x: 2013, y: 0.5),
            BarChartDataEntry(x: 2014, y: 0.3),
            BarChartDataEntry(x: 2015, y: 1.4),
            BarChartDataEntry(x: 2016, y: 1.6),
            BarChartDataEntry(x: 2017, y: 2.1),
            BarChartDataEntry(x: 2018, y: 3.4)
            ], label: "Cost")
        
        dataSet.setColor(UIColor.lightGray)
        dataSet.highlightColor = UIColor.orange
        dataSet.drawValuesEnabled = false
    
        let barData = BarChartData(dataSet: dataSet)
        
        barChart.legend.enabled = false
        barChart.chartDescription?.enabled = false
        barChart.backgroundColor = UIColor.clear
        barChart.marker = marker
        barChart.data = barData
        
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        
        barChart.setExtraOffsets(left: 5, top: 0, right: 20, bottom: 20)
        barChart.rightAxis.enabled = false
        barChart.leftAxis.drawAxisLineEnabled = false
        barChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, _) -> String in
            
            let nf = NumberFormatter()
            nf.maximumFractionDigits = 0
            nf.numberStyle = .percent
            
            return nf.string(from: NSNumber(value: value))!
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        barChart.animate(xAxisDuration: 0.4, easingOption: .easeInCubic)
        
    }
    
    @IBAction func dimissView(_ sender:Any ) -> Void {
        
        self.dismiss(animated: true, completion: nil)
    }
}
