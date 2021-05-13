//
//  WebsiteViewController.swift
//  stonks
//
//  Created by  on 4/21/21.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController, WKNavigationDelegate {
    
    var article: [String:Any]!
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = article["url"] as! String
        let articleURL = URL(string: url)
        
        webView.load(URLRequest(url: articleURL!))
        webView.allowsBackForwardNavigationGestures = true
        
        //print(article["url"])

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
