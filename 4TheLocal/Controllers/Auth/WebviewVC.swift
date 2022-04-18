//
//  WebviewVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 24/8/21.
//

import UIKit
import Combine
import WebKit
import SVProgressHUD

class WebviewVC: UIViewController {
    static let identifire = "WebviewVC"
    
    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var webview: WKWebView!
    
    var subscriptions = Set<AnyCancellable>()
    var titleTxt: String!
    var link: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavView()
        initView()
    }

}


extension WebviewVC{
    
    func initView(){
        SVProgressHUD().show()
        let link = URL(string: self.link)!
        let request = URLRequest(url: link)
        webview.navigationDelegate = self
        webview.load(request)
    }
    
    func setupNavView(){
        topNav.titleLbl.text = titleTxt ?? ""
        topNav.rightBtn.isHidden = true
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
}


extension WebviewVC: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
    }
}
