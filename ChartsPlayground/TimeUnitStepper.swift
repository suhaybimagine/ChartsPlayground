//
//  TimeUnitStepper.swift
//  ChartsPlayground
//
//  Created by Suhayb Ahmad on 6/20/18.
//  Copyright © 2018 Imagine Technologies. All rights reserved.
//

import UIKit

enum TimeUnit {
    case day
    case week
    case month
    case quarter
    case year
}

class TimeUnitStepper: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.calculateTime()
        self.displayTime()
    }
    
    
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var nextButton:UIButton!
    @IBOutlet weak var prevButton:UIButton!
    
    var value:Int = 0
    var start:Date = Date()
    var end:Date = Date()
    var duration:TimeInterval = 0
    private var _unit:TimeUnit = .day
    
    var unit:TimeUnit {
        
        set{
            self._unit = newValue
            self.recalculateValue()
            self.calculateTime()
            self.displayTime()
        }
        
        get {
            return self._unit
        }
    }
    
    private func calculateTime() -> Void {
        
        var date1:Date, date2:Date
        var component:Calendar.Component, dv = 1
                
        switch self.unit {
        case .day:
            
            date1 = Calendar.current.startOfDay(for: Date())
            component = .day
            
        case .week:
            
            date1 = Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
            )!
            
            component = .weekOfYear
            
        case .month:
            
            date1 = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: Date())
            )!
            
            component = .month
            
        case .quarter:
            
            var comps = Calendar.current.dateComponents([.year, .month], from: Date())
            let months = comps.month!
            comps.month = months - (months % 3)
            
            date1 = Calendar.current.date(from: comps)!
            component = .month
            dv = 3
            
        case .year:
            
            date1 = Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: Date())
            )!
            
            component = .year
        }
        
        date1 = Calendar.current.date(byAdding: component, value: self.value * dv, to: date1)!
        date2 = Calendar.current.date(byAdding: component, value: dv, to: date1)!
        
        self.start = date1
        self.end = date2
        self.duration = date2.timeIntervalSince1970 - date1.timeIntervalSince1970
    }
    
    private func displayTime() -> Void {
        
        let df = DateFormatter()
        var date = self.start
        
        switch self.unit {
        case .day:
            df.dateFormat = "EEE dd, MM / yyyy"
        case .week:
            df.dateFormat = "ww, yyyy"
        case .month:
            df.dateFormat = "MMM, yyyy"
            date = self.start.addingTimeInterval(self.duration / 2.0)
        case .quarter:
            df.dateFormat = "QQQ, yyyy"
            date = self.start.addingTimeInterval(self.duration / 2.0)
        case .year:
            df.dateFormat = "yyyy"
        }
        
        self.timeLabel.text = df.string(from: date)
    }
    
    private func recalculateValue() -> Void {
        
        switch self.unit {
        case .day:
            self.value = Calendar.current.dateComponents([.day], from: Date(), to: self.start).day!
        case .week:
            self.value = Calendar.current.dateComponents([.weekOfYear], from: Date(), to: self.start).weekOfYear!
        case .month:
            self.value = Calendar.current.dateComponents([.month], from: Date(), to: self.start).month!
        case .quarter:
            self.value = Int( ceil(Double(Calendar.current.dateComponents([.month], from: Date(), to: self.start).month!) / 3.0) )
        case .year:
            self.value = Calendar.current.dateComponents([.year], from: Date(), to: self.start).year!
        }
    }
    
    @IBAction func nextTime(_ sender: Any) {
        
        self.value += 1
        self.calculateTime()
        self.displayTime()
    }
    
    @IBAction func pastTime(_ sender: Any) {
        
        self.value -= 1
        self.calculateTime()
        self.displayTime()
    }
}
