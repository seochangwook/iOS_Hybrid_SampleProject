//
//  ViewController.swift
//  LOTTEHOTELFMS
//
//  Created by seo on 04/10/2019.
//  Copyright © 2019 seo. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler{
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var outputtext: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("viewDidLoad Call")
        
        initWebview_then_callFromJs()
        loadUrl()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("viewDidAppear Call")
        
        checkNetworkConnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backbutton(_ sender: UIButton) {
        if(webView.canGoBack){
            webView.goBack()
        } else{
            print("no back page")
        }
    }
    
    @IBAction func forwardbutton(_ sender: UIButton) {
        if(webView.canGoForward){
            webView.goForward()
        } else{
            print("no forward page")
        }
    }
    
    @IBAction func refreshbutton(_ sender: UIButton) {
        print("refresh page")
        
        webView.reload()
    }
    
    @IBAction func homebutton(_ sender: UIButton) {
        print("home page reload")
        
        webView.load(URLRequest(url: URL(string: "http://172.30.1.7:8080/prototype/main.do")!))
    }
    
    @IBAction func jscallbutton(_ sender: UIButton) {
        /// Javascript Function Setting
        let testhybridfunc = "testhybrid()"
        
        ///Native -> JS Call
        webView.evaluateJavaScript(testhybridfunc, completionHandler: {(result, error) in
            if let result = result {
                print(result)
            }
        })
    }
    
    @IBAction func jscallparambutton(_ sender: UIButton) {
        ///Parameter Setting
        let name : String = "seochangwook"
        let age : Int = 28
        let address : String = "경기도 수원시"
        
        /// Javascript Function Setting (Param)
        let testhybridparamfunc = "testhybridparam('\(name)', '\(age)', '\(address)')"
        
        /// Native -> JS Call (Param)
        webView.evaluateJavaScript(testhybridparamfunc, completionHandler: {(result, error) in
            if let result = result {
                print(result)
            }
        })
    }
    
    func initWebview_then_callFromJs(){
        ///Javascript Call Function Controller
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        contentController.add(self, name : "hello")
        contentController.add(self, name : "test")
        
        config.userContentController = contentController
        
        webView = WKWebView(frame: CGRect.init(x: 0, y: 86, width: 375, height: 404), configuration: config)
    }
    
    func loadUrl(){
        view.addSubview(webView)
        
        ///WKWebview 셋팅
        let url = URL(string: "http://172.30.1.7:8080/prototype/main.do")
        let request = URLRequest(url: url!)
            
        webView.load(request)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    func checkNetworkConnect(){
        ///Alert를 사용한 Network의 Check는 viewDidAppear에서 수행
        if Reachability.isConnectedToNetwork(){
            print("Network Connect")
        } else{
            print("Network Not Connect")
            
            let networkCheckAlert = UIAlertController(title: "Network ERROR", message: "앱을 종료합니다.", preferredStyle: UIAlertController.Style.alert)
            
            networkCheckAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("App exit")
                
                exit(0)
            }))
            
            self.present(networkCheckAlert, animated: true, completion: nil)
        }
    }
    
    /// WKScriptMessageHandler Callback (Javascript -> Native Call (Param))
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "hello"){
            var data = message.body
            outputtext.text = data as! String
        } else if(message.name == "test"){
            var data = message.body
            outputtext.text = data as! String
        }
    }
    
    ///WKUIDelegate 3가지 필수 Callback 함수
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {(action) in
            completionHandler()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))

        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in
            completionHandler(nil)
        }))

        self.present(alertController, animated: true, completion: nil)
    }
    ///----------
    
    ///WKNavigationDelegate 중복적으로 리로드 방지 (iOS 9 이후지원)
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}
