//
//  AlarmListViewController.swift
//  MusicAlarm
//
//  Created by 최아람 on 2023/02/15.
//

import Foundation
import UIKit
import UserNotifications


class AlarmListViewController : UITableViewController {
    var alarms : [Alarm] = []
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "AlarmTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AlarmTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alarms = alarmList()
    }
    
    @IBAction func tapAddAlarmButton(_ sender: UIBarButtonItem) {
        guard let addAlertVC = storyboard?.instantiateViewController(identifier: "AddAlarmViewController") as? AddAlarmViewController else {return}
        
        addAlertVC.pickedTime = { [weak self] date, keyword in
            guard let self = self else {return}
            var alarmList = self.alarmList()
            let newAlarm = Alarm(date: date, isOn: true, keyword: keyword)
            
            alarmList.append(newAlarm)
            alarmList.sort{$0.date<$1.date}
            
            self.alarms = alarmList
            
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alarms), forKey: "alarms")
            
            
            self.userNotificationCenter.addNotificationRequest(by: newAlarm)

            self.tableView.reloadData()
        }
        self.present(addAlertVC, animated: true)
        
    }
    
    func alarmList() -> [Alarm] {
        guard let data = UserDefaults.standard.value(forKey: "alarms") as? Data,
              let alarms = try? PropertyListDecoder().decode([Alarm].self, from: data) else {return []}
        return alarms
    }
    
    
}

extension AlarmListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "원하는 시간에 책을 추천받아 보세요!"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as? AlarmTableViewCell else {return UITableViewCell()}
        
        cell.alarmSwitch.isOn = alarms[indexPath.row].isOn
        cell.timeLabel.text = alarms[indexPath.row].time
        cell.ampmLabel.text = alarms[indexPath.row].ampm
        cell.alarmSwitch.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            self.alarms.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alarms), forKey: "alarms")
            
            self.tableView.reloadData()
            
            return
        default:
            break
        }
    }
    
}
