//
//  ViewController.swift
//  leapYear
//
//  Created by 羅承志 on 2021/6/4.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lunarCalendarLabel: UILabel!
    @IBOutlet weak var weekSegmented: UISegmentedControl!
    @IBOutlet weak var constellationPickerView: UIPickerView!
    @IBOutlet weak var adYearLabel: UILabel!
    @IBOutlet weak var adYearSwitch: UISwitch!
    
    //MARK: Picker View
    var constellations = [Constellation(name: "牡羊座", startDate: "3/21", stopDate: "4/19"), Constellation(name: "金牛座", startDate: "04/20", stopDate: "05/20"), Constellation(name: "雙子座", startDate: "05/21", stopDate: "06/20"), Constellation(name: "巨蟹座", startDate: "06/21", stopDate: "07/22"), Constellation(name: "獅子座", startDate: "07/23", stopDate: "08/22"), Constellation(name: "處女座", startDate: "08/23", stopDate: "09/22"), Constellation(name: "天秤座", startDate: "09/23", stopDate: "10/22"), Constellation(name: "天蠍座", startDate: "10/23", stopDate: "11/21"), Constellation(name: "射手座", startDate: "11/22", stopDate: "12/21"), Constellation(name: "摩羯座", startDate: "12/22", stopDate: "01/19"), Constellation(name: "水瓶座", startDate: "01/20", stopDate: "02/18"), Constellation(name: "雙魚座", startDate: "02/19", stopDate: "03/20")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updated()
    }

    func leapYear(year: Int) -> Bool {
        if (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0 && year % 3200 != 0) {
            return true
        } else {
            return false
        }
    }
    
    func updated() {
        //陽曆
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .none
        format.calendar = Calendar(identifier: .chinese)
        format.locale = Locale(identifier: "zh_TW")
        let date = datePicker.date
        let dateSting = format.string(from: date)
        lunarCalendarLabel.text = "農曆：\(dateSting)"
        //print(dateSting)
        
        //MARK: 判斷星期幾
        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: datePicker.date)
        weekSegmented.selectedSegmentIndex = dateComponent.weekday! - 1
        
        //MARK: 判斷閏年
        if let year = dateComponent.year {
            adYearLabel.text = "\(year)"
            adYearSwitch.isOn = leapYear(year: year)
        }
        //MARK: 判斷星座
        for (i, constellation) in constellations.enumerated() {
            if constellation.checkInterval(dateComponent: dateComponent) {
                constellationPickerView.selectRow(i, inComponent: 0, animated: true)
                break
            }
        }
    }
    
    @IBAction func lunarCalendar(_ sender: UIDatePicker) {
        //根據日期調整顯示的星期、閏年和星座
        updated()
    }
    
    //宣告picker的橫列有幾個
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //宣告直列要顯示的數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return constellations.count
    }
    //宣告pickerView要顯示的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return constellations[row].name
    }
}

