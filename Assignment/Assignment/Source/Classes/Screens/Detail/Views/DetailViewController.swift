//
//  DetailViewController.swift
//  Assignment
//
//  Created by Avinash on 29/07/18.
//  Copyright © 2018 Avinash. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!

    var viewModel: DetailViewModel!
    
    var viewState = ViewState.normal {
        didSet{
            switch viewState {
            case .loading:
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else {return}
                    
                    weakSelf.activityIndicator.startAnimating()
                    weakSelf.activityIndicator.isHidden = false
                    weakSelf.errorLabel.isHidden = true
                    weakSelf.webView.isHidden = false
                }
            
            case .error(let message):
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else {return}
                    
                    weakSelf.activityIndicator.stopAnimating()
                    weakSelf.activityIndicator.isHidden = true
                    weakSelf.errorLabel.text = message
                    weakSelf.errorLabel.isHidden = false
                    weakSelf.webView.isHidden = true
                }
            default:
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else {return}
                    
                    weakSelf.activityIndicator.stopAnimating()
                    weakSelf.activityIndicator.isHidden = true
                    weakSelf.errorLabel.isHidden = true
                    weakSelf.webView.isHidden = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        self.title = viewModel.screenTitle
        webView.uiDelegate = self
        webView.navigationDelegate = self
        viewState = .loading
        
        
        viewModel.getPageURL(for:viewModel.pageID) { (result) in
            switch result {
                case .success:
                    self.loadWebView(url: self.viewModel.pageURL)
                
            case .failure(_):
                self.viewState = .error("Failed to load URL")
            }
        }
    }
    
    func loadWebView(url: String) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            self.viewState = .loading
            self.webView.load(request)
        }
    }
}

extension DetailViewController: WKUIDelegate,WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.viewState = .loaded
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.viewState = .error("Failed to load URL")
    }
}
