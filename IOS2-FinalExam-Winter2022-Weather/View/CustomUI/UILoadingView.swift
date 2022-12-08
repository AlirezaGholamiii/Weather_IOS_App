//
//  UILoadingView.swift
//  IOS2-Midterm-Winter2022-GitHub
//
//  Created by Daniel Carvalho on 2022-03-12.
//

import UIKit

class UILoadingView: UIView {
    
    private let viewContainer : UIView = {

        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false

        return view

    }()
    
    private let lblMessage : UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    private let activityIndicator : UIActivityIndicatorView = {
        
        let act = UIActivityIndicatorView()
        act.color = .white
        act.translatesAutoresizingMaskIntoConstraints = false
        
        return act
        
    }()
    
    public func show( message : String ) {
        
        if message.count == 0 {
            hide()
            return
        }
        
        self.lblMessage.text = message
        self.activityIndicator.startAnimating()
        self.isHidden = false
        super.bringSubviewToFront(self)
        
    }
    
    public func hide() {
        
        self.activityIndicator.stopAnimating()
        self.isHidden = true
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white.withAlphaComponent(0.20)
        
        self.addSubview(viewContainer)
        self.viewContainer.addSubviews(lblMessage, activityIndicator)
        
        applyConstraints()
        
    }
    
    private func applyConstraints() {

        
        self.viewContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        self.viewContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        self.viewContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.viewContainer.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.viewContainer.centerXAnchor).isActive = true
        self.activityIndicator.topAnchor.constraint(equalTo: self.viewContainer.topAnchor, constant: 5).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalTo: self.activityIndicator.heightAnchor).isActive = true
        
        self.lblMessage.leadingAnchor.constraint(equalTo: self.viewContainer.leadingAnchor, constant: 10).isActive = true
        self.lblMessage.topAnchor.constraint(equalTo: self.viewContainer.topAnchor, constant: 40).isActive = true
        self.lblMessage.trailingAnchor.constraint(equalTo: self.viewContainer.trailingAnchor, constant: -10).isActive = true
        self.lblMessage.bottomAnchor.constraint(equalTo: self.viewContainer.bottomAnchor, constant: -10).isActive = true

        

        
    }
    
    
    
}
