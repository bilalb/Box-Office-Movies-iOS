//
//  TrailerTableViewCell.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 09/08/2019.
//  Copyright © 2019 Boxotop. All rights reserved.
//

import WebKit
import UIKit

class TrailerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var webView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configureActivityIndicatorView()
        
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        
        containerView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.fillSuperview()
        
        containerView.bringSubviewToFront(activityIndicatorView)
    }

    func configureActivityIndicatorView() {
        if #available(iOS 13.0, *) {
            activityIndicatorView.style = .medium
        } else {
            activityIndicatorView.style = .gray
        }
    }
}

// MARK: - WKNavigationDelegate
extension TrailerTableViewCell: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
    }
}
