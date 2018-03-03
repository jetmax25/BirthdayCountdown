//
//  BirthdayChooserViewController.swift
//  Birthday Countdown
//
//  Created by Anna Stavropoulos on 8/4/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit

class BirthdayChooserViewController: UIViewController, UIPickerViewDelegate {


    @IBOutlet weak var dayChooser: UIPickerView!
    @IBOutlet weak var monthChooser: UIPickerView!
    
    #if BIRTHDAY
    let monthData = [
        ["Month" : "January", "numDays" : 31],
        ["Month" : "February", "numDays" : 28],
        ["Month" : "March", "numDays" : 31],
        ["Month" : "April", "numDays" : 30],
        ["Month" : "May", "numDays" : 31],
        ["Month" : "June", "numDays" : 30],
        ["Month" : "July", "numDays" : 31],
        ["Month" : "August", "numDays" : 31],
        ["Month" : "September", "numDays" : 30],
        ["Month" : "October", "numDays" : 31],
        ["Month" : "November", "numDays" : 30],
        ["Month" : "December", "numDays" : 30]
    ]
    #elseif SpanishBirthday
    let monthData = [
        ["Month" : "enero", "numDays" : 31],
        ["Month" : "febrero", "numDays" : 28],
        ["Month" : "marzo", "numDays" : 31],
        ["Month" : "abril", "numDays" : 30],
        ["Month" : "mayo", "numDays" : 31],
        ["Month" : "junio", "numDays" : 30],
        ["Month" : "julio", "numDays" : 31],
        ["Month" : "agosto", "numDays" : 31],
        ["Month" : "septiembre", "numDays" : 30],
        ["Month" : "octubre", "numDays" : 31],
        ["Month" : "noviembre", "numDays" : 30],
        ["Month" : "diciembre", "numDays" : 30]
    ]
    #endif
    var viewModel = DatePickViewModel()
    
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setUpBlurryBackgroundImage(imageName: "BirthdayBackground.jpg")
    }
    
    @IBAction func chooseBirthday(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(viewModel.chosenDate, forKey: "Date")
        
        var storyboard = UIStoryboard(name: "DateCountdown", bundle: nil)
        let diff = Calendar.current.dateComponents([.day], from:  NSCalendar.current.startOfDay(for: Date()), to: viewModel.chosenDate)
        if diff.day == 0 {
            storyboard = UIStoryboard(name: "Birthday", bundle: nil)
        }
        let controller = storyboard.instantiateInitialViewController()
        self.present(controller!, animated: true, completion: nil)
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
            return monthData.count
        } else {
            return monthData[monthChooser.selectedRow(inComponent: 0)]["numDays"] as! Int
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont.boldSystemFont(ofSize: 36)
            pickerLabel?.textColor = .red
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        if pickerView.tag == 0 {
            pickerLabel?.text =  monthData[row]["Month"] as? String
        } else {
            pickerLabel?.text = "\(row + 1)"
        }
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
            dayChooser.reloadComponent(0)
            viewModel.setDay(day: dayChooser.selectedRow(inComponent: 0) + 1)
            viewModel.setMonth(month: row + 1)
        } else {
            viewModel.setDay(day: row + 1)
        }
    }
}
