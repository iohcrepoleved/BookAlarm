//
//  AddAlarmViewController.swift
//  MusicAlarm
//
//  Created by 최아람 on 2023/02/15.
//

import Foundation
import UIKit


class AddAlarmViewController : UIViewController {
    var pickedTime : ((_ time: Date,_ keyword: String) -> Void)?
    
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tabCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tabSaveButton(_ sender: UIBarButtonItem) {
        pickedTime?(timePicker.date, keywordTextField.text!)
        self.dismiss(animated: true)
    }
}
