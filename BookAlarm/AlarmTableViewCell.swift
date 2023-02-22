//
//  AlarmTableViewCell.swift
//  MusicAlarm
//
//  Created by 최아람 on 2023/02/15.
//

import UIKit
import UserNotifications

class AlarmTableViewCell: UITableViewCell {
    let userNotificationCenter = UNUserNotificationCenter.current()

    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func alarmSwitchValueChanged(_ sender: UISwitch) {
        guard let data = UserDefaults.standard.value(forKey: "alarms") as? Data,
              var alarms = try? PropertyListDecoder().decode([Alarm].self, from: data) else {return}
        
        alarms[sender.tag].isOn = sender.isOn
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alarms), forKey: "alarms")
    
        if sender.isOn {
            userNotificationCenter.addNotificationRequest(by: alarms[sender.tag])
        }else {
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alarms[sender.tag].id])
        }
    }
}
