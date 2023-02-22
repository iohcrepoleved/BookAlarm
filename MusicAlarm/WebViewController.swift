//
//  WebViewController.swift
//  MusicAlarm
//
//  Created by 최아람 on 2023/02/20.
//

import UIKit
import WebKit

class WebViewController : UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var url : String = ""
    
    override func viewDidLoad() {
            super.viewDidLoad()
            loadWebPage(url)
        }

        func loadWebPage(_ url: String) {
            guard let myUrl = URL(string: url) else {
                return
            }
            let request = URLRequest(url: myUrl)
            webView.load(request)
        }
}
