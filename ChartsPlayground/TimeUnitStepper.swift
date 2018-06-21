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
    
    var refDate = Date()
    
    var value:Int = 0
    var start:Date = Date()
    var end:Date = Date()
    var duration:TimeInterval = 0
    private var _unit:TimeUnit = .day
    
    var unit:TimeUnit {
        
        set{
            let prev = self._unit
            self._unit = newValue
            self.recalculateValue(prev)
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
            
            date1 = Calendar.current.startOfDay(for: refDate)
            component = .day
            
        case .week:
            
            date1 = Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: refDate)
            )!
            
            component = .weekOfYear
            
        case .month:
            
            date1 = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: refDate)
            )!
            
            component = .month
            
        case .quarter:
            
            var comps = Calendar.current.dateComponents([.year, .month], from: refDate)
            let months = Double( comps.month! )
            comps.month = Int( (ceil( months / 3.0 ) - 1 ) * 3 ) + 1
            
            date1 = Calendar.current.date(from: comps)!
            component = .month
            dv = 3
            
        case .year:
            
            date1 = Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: refDate)
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
        case .quarter:
            df.dateFormat = "QQQ, yyyy"
        case .year:
            df.dateFormat = "yyyy"
        }
        
        switch self.unit {
        case .week, .month, .quarter:
            date = self.start.addingTimeInterval(self.duration / 2.0)
        default:
            break
        }
        
        self.timeLabel.text = df.string(from: date)
    }
    
    private func recalculateValue(_ prev:TimeUnit ) -> Void {
        
        if prev == .quarter {
            self.start = Calendar.current.date(byAdding: .day, value: 1, to: self.start)!
            self.end = self.start.addingTimeInterval(self.duration)
        }
        
        switch self.unit {
        case .day:
            self.value = Calendar.current.dateComponents([.day], from: refDate, to: self.start).day!
        case .week:
            self.value = Calendar.current.dateComponents([.weekOfYear], from: refDate, to: self.start).weekOfYear!
        case .month:
            self.value = Calendar.current.dateComponents([.month], from: refDate, to: self.start).month!
        case .quarter:
            
            var comps = Calendar.current.dateComponents([.year, .month], from: refDate)
            var months = Double(comps.month!)
            comps.month = Int( (ceil( months / 3.0 ) - 1 ) * 3 ) + 1
            
            let date1 = Calendar.current.date(from: comps)!
            
            comps = Calendar.current.dateComponents([.year, .month], from: self.start)
            months = Double(comps.month!)
            comps.month = Int( (ceil( months / 3.0 ) - 1 ) * 3 ) + 1
            
            let date2 = Calendar.current.date(from: comps)!
            self.value = Int( floor( Double(Calendar.current.dateComponents([.month], from: date1, to: date2).month!) / 3.0 ) )
            
        case .year:
            self.value = Calendar.current.dateComponents([.year], from: refDate, to: self.start).year!
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
