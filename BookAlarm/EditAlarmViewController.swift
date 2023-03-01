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
    @IBOutlet weak var orderTextField: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    
    weak var delegate: EditAlarmViewDelegate?
    var alarm: Alarm?
    var indexPath : IndexPath?
    var pickedTime : ((_ time: Date,_ keyword: String,_ orderCondition: String,_ searchCondition: String) -> Void)?
    let orderList = ["정확도순", "출간일순"]
    let searchList = ["책 제목", "출판사", "저자명", "책 소개"]
    var alarms : [Alarm] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alarms = alarmList()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        setOrderPickerView()
        setSearchPickerView()
    }
    
    private func configureView(){
        guard let alarm = self.alarm else {return}
        self.keywordTextField.text = alarm.keyword
        self.timePicker.date = alarm.date
        self.searchTextField.text = alarm.searchCondition
        self.orderTextField.text = alarm.orderCondition
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
        guard keywordTextField.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "키워드를 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        pickedTime?(timePicker.date, keywordTextField.text!, orderTextField.text!, searchTextField.text!)
        self.dismiss(animated: true)
    }
    
    private func setOrderPickerView() {
        let orderPickerView = UIPickerView()
        orderPickerView.tag = 0
        orderTextField.inputView = orderPickerView
        orderPickerView.dataSource = self
        orderPickerView.delegate = self
    }
    
    private func setSearchPickerView() {
        let searchPickerView = UIPickerView()
        searchPickerView.tag = 1
        searchTextField.inputView = searchPickerView
        searchPickerView.dataSource = self
        searchPickerView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


extension EditAlarmViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return self.orderList.count
        }else {
            return self.searchList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return self.orderList[row]
        }else {
            return self.searchList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            self.orderTextField.text = self.orderList[row]
        }else {
            self.searchTextField.text = self.searchList[row]
        }
        self.view.endEditing(true)
        
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    
}
