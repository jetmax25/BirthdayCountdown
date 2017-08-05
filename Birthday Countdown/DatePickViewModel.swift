//
//  DatePickViewModel.swift
//  Birthday Countdown
//
//  Created by Anna Stavropoulos on 8/5/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import Foundation

class DatePickViewModel {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var datePickModel = DatePickModel()
    var chosenDate : Date = NSDate() as Date
    
    init() {
        dateFormatter.dateFormat = "YYYY-MM-dd"
    }

    private func setDate() {
        var year = calendar.component(.year, from: datePickModel.currentDate)
        let dateString = "\(year)-\(datePickModel.month)-\(datePickModel.day)"
        var chosenDate = dateFormatter.date(from: dateString)
        if chosenDate! < Date() {
            year = year + 1
            let dateString = "\(year)-\(datePickModel.month)-\(datePickModel.day)"
            chosenDate = dateFormatter.date(from: dateString)!
        }
        self.chosenDate = chosenDate!
    }
    
    func setDay(day : Int) {
        datePickModel.day = day
        setDate()
    }
    
    func setMonth(month : Int) {
        datePickModel.month = month
        setDate()
    }
}
