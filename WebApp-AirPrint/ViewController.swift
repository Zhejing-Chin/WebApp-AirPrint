//
//  ViewController.swift
//  WebApp-AirPrint
//
//  Created by Zhe Jing on 28/07/2020.
//  Copyright © 2020 Gogain Chin. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UIPopoverPresentationControllerDelegate {
    
    var website: String!
//  "http://thaiphp.ganoexcel.com/index.php"
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var printerButton: UIBarButtonItem!
        
    @IBOutlet var webPage: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webPage.navigationDelegate = self
        webPage.uiDelegate = self
        
        webPage.load(URLRequest(url: URL(string: website)!))
        view.addSubview(webPage)
//        backButton.isEnabled = false
//        backButton.tintColor = UIColor.clear
        printerButton.isEnabled = false
        printerButton.tintColor = UIColor.clear
    }
    
    //MARK:- Button func
    @IBAction func backTapped(_ sender: Any) {
        if(self.webPage.canGoBack) {
         self.webPage.goBack()
        }
        
        if(self.webPage.url!.absoluteString == website){
            performSegue(withIdentifier: "main", sender: self)
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        self.webPage.reload()
    }
    
    //MARK:- Check URL
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        if webView.url!.absoluteString.range(of: "index.php") != nil
//        {
//            backButton.isEnabled = false
//            backButton.tintColor = UIColor.clear
//        }
//        else {
//            backButton.isEnabled = true
//            backButton.tintColor = nil
//        }
    }
    
    //MARK:- WKUIDelegate
    //open up print preview page
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
            view.addSubview(webView)
            
            printerButton.isEnabled = true
            
            let script = WKUserScript(source: "window.print = function(){ window.webkit.messageHandlers.print.postMessage('print') }", injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
            configuration.userContentController.removeScriptMessageHandler(forName: "print")
            configuration.userContentController.addUserScript(script)
            configuration.userContentController.add(self, name: "print")
            debugPrint(navigationAction.request)
        }
        
        return nil
    }
   
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "print" {
            debugPrint(message.name)
            printCurrentPage()
            self.webPage.goBack()
        }
        else {
            debugPrint(message.name)
        }
    }
    
    //MARK:- Print
    func printCurrentPage() {
        let printController = UIPrintInteractionController.shared
        let printFormatter = self.webPage.viewPrintFormatter()
        printController.printFormatter = printFormatter

        let completionHandler: UIPrintInteractionController.CompletionHandler = { (printController, completed, error) in
            if !completed {
                if error != nil {
                    debugPrint("[PRINT] Failed")
                } else {
                    debugPrint("[PRINT] Canceled")
                }
            }
        }

       if UIDevice.current.userInterfaceIdiom == .pad {
            printController.present(from: printerButton, animated: true, completionHandler: completionHandler)
       } else {
            printController.present(animated: true, completionHandler: completionHandler)
       }
    }
    
    
}
