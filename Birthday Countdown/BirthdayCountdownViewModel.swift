//
//  BirthdayCountdownViewModel.swift
//  Birthday Countdown
//
//  Created by Anna Stavropoulos on 8/6/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import Foundation

struct BirthdayCountdownViewModel {
    let chosenDate : Date
    let calendar = NSCalendar.current
    
    init(chosenDate : Date) {
        self.chosenDate = chosenDate
    }
    
    func getDays() -> Int {
        return getTimeDifference(component: .day).day!
    }
    
    func getHours() -> Int {
        return getTimeDifference(component: .hour).hour!
    }
    
    func getMinutes() -> Int {
        return getTimeDifference(component: .minute).minute!
    }
    
    func getSeconds() -> Int {
        return getTimeDifference(component: .second).second!
    }
    
    private func getTimeDifference( component : Calendar.Component) -> DateComponents
    {
        let currentTime = Date()
        return calendar.dateComponents([component], from: currentTime, to: chosenDate)
    }
}
