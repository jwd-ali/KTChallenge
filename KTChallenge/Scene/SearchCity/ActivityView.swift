//
//  ActivityView.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import UIKit
class ActivityView: UIActivityIndicatorView {
    
    //MARK:- Initializer
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superView = self.superview {
            self.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: 0).isActive = true
            self.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: 0).isActive = true
        }
        startAnimating()
    }
}
