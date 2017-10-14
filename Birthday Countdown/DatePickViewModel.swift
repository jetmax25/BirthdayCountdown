//
//  DatePickViewModel.swift
//  Birthday Countdown
//
//  Created by Anna Stavropoulos on 8/5/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import Foundation

struct DatePickViewModel {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var datePickModel = DatePickModel()
    var chosenDate : Date!
    let currentComponents : DateComponents!
    
    init() {
        dateFormatter.dateFormat = "YYYY-MM-dd"
        currentComponents = calendar.dateComponents([.year, .month, .day], from: datePickModel.currentDate)
        chosenDate = dateFormatter.date(from: "\(currentComponents.year!)-01-01" )!
        setDate()
    }

    private mutating func setDate() {
        var year = currentComponents.year!
        if currentComponents.month! > datePickModel.month || (currentComponents.day! > datePickModel.day && currentComponents.month! == datePickModel.month) {
            year = year + 1
        }
        
        let dateString = "\(year)-\(datePickModel.month)-\(datePickModel.day)"
        self.chosenDate = dateFormatter.date(from: dateString)!
        return
    }
    
    mutating func setDay(day : Int) {
        datePickModel.day = day
        setDate()
    }
    
    mutating func setMonth(month : Int) {
        datePickModel.month = month
        setDate()
    }
}
