//
//  AddAlarmViewController.swift
//  MusicAlarm
//
//  Created by 최아람 on 2023/02/15.
//

import Foundation
import UIKit


class AddAlarmViewController : UIViewController {
    var pickedTime : ((_ time: Date, _ keyword: String, _ orderCondition: String,_ searchCondition: String) -> Void)?
    let orderList = ["정확도순", "출간일순"]
    let searchList = ["책 제목", "출판사", "저자명", "책 소개"]
    
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var orderTextField: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOrderPickerView()
        setSearchPickerView()
    }
    
    @IBAction func tabCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tabSaveButton(_ sender: UIBarButtonItem) {
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
        orderTextField.text = "정확도순"
        let orderPickerView = UIPickerView()
        orderPickerView.tag = 0
        orderTextField.inputView = orderPickerView // 피커 뷰를 텍스트 필드 inputMode 로 지정
        orderPickerView.dataSource = self
        orderPickerView.delegate = self
    }
    
    private func setSearchPickerView() {
        searchTextField.text = "책 제목"
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



extension AddAlarmViewController : UIPickerViewDelegate, UIPickerViewDataSource {
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
