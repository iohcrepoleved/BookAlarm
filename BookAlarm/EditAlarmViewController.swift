//
//  EditAlarmViewController.swift
//  BookAlarm
//
//  Created by 최아람 on 2023/02/22.
//

import Foundation
import UIKit



class EditAlarmViewController : UIViewController
{
    
    
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    weak var delegate: EditAlarmViewDelegate?
    var alarm: Alarm?
    var indexPath : IndexPath?
    var pickedTime : ((_ time: Date,_ keyword: String) -> Void)?
    var alarms : [Alarm] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alarms = alarmList()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView(){
        guard let alarm = self.alarm else {return}
        print(alarm)
        self.keywordTextField.text = alarm.keyword
        self.timePicker.date = alarm.date
    }
    
    func alarmList() -> [Alarm] {
        guard let data = UserDefaults.standard.value(forKey: "alarms") as? Data,
              let alarms = try? PropertyListDecoder().decode([Alarm].self, from: data) else {return []}
        return alarms
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath = self.indexPath else {return}
        self.delegate?.didDelete(indexPath: indexPath)
        self.dismiss(animated: true)
        
    }
    
    @IBAction func tapCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapSaveButton(_ sender: UIBarButtonItem) {
        pickedTime?(timePicker.date, keywordTextField.text!)
        self.dismiss(animated: true)
    }
}
