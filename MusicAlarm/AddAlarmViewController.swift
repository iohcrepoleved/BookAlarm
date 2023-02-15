//
//  AddAlarmViewController.swift
//  MusicAlarm
//
//  Created by 최아람 on 2023/02/15.
//

import Foundation
import UIKit

class AddAlarmViewController : UIViewController {
    var pickedTime : ((_ time: Date) -> Void)?
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func tabCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tabSaveButton(_ sender: UIBarButtonItem) {
        pickedTime?(timePicker.date)
        self.dismiss(animated: true)
    }
}
