//
//  UIUserSearchBar.swift
//  IOS2-Midterm-Winter2022-GitHub
//
//  Created by Daniel Carvalho on 2022-03-12.
//

import UIKit

protocol UICitySearchBarDelegate {
    
    func citySearchBar( cityToSearch : String )
    
    func citySearchBarValueChanged ( cityToSearch : String )
    
}



class UICitySearchBar: UIView, UITextFieldDelegate {
    
    public var delegate : UICitySearchBarDelegate?
    
    private let txtCityName : UITextField = {
        
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "enter the city name to fetch the time zone"
        textField.clearButtonMode = .whileEditing
        textField.textContentType = .username
        textField.autocapitalizationType = .none
        textField.backgroundColor = .white.withAlphaComponent(0.60)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
        
    }()
    
    private let activityIndicator : UIActivityIndicatorView = {
        
        let act = UIActivityIndicatorView()
        act.color = .white
        act.translatesAutoresizingMaskIntoConstraints = false
        act.isHidden = true
        
        return act
        
    }()
    
    private let imgSearch : UIImageView = {
        
        let img = UIImageView()
        img.image = UIImage(systemName: "magnifyingglass")
        img.tintColor = .lightGray
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
        
    }()
    
    public var placeHolder : String = "" {
        didSet {
            self.txtCityName.placeholder = placeHolder
        }
    }
    
    public var text : String = "" {
        didSet {
            self.txtCityName.text = text
        }
    }

    public func startSearch() {
        
        imgSearch.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        txtCityName.isEnabled = false
        
    }
        

    public func endSearch() {
        
        imgSearch.isHidden = false
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        txtCityName.isEnabled = true
        
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white.withAlphaComponent(0.50)
        
        self.addSubviews(txtCityName, activityIndicator, imgSearch)
        
        imgSearch.enableTapGestureRecognizer(target: self, action: #selector(imgSearchTapped))
        
        txtCityName.addTarget(self, action: #selector(txtUsernameChanged), for: .editingChanged)
        
        txtCityName.delegate = self
        
        applyConstraints()
        
    }
    
    @objc private func imgSearchTapped() {
        
        if self.txtCityName.text!.isEmpty {
            return
        }

        if self.delegate != nil {

            self.startSearch()

            let city = self.txtCityName.text!
            
            delegate!.citySearchBar(cityToSearch: city)
        }
                
        
    }
    
    @objc private func txtUsernameChanged() {
        
        if self.txtCityName.text!.isEmpty {
            self.imgSearch.tintColor = .lightGray
        } else {
            self.imgSearch.tintColor = .black
        }
        
        if self.delegate != nil {
            self.delegate!.citySearchBarValueChanged(cityToSearch: self.txtCityName.text!)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.imgSearchTapped()
        return true
        
    }
    
    
    private func applyConstraints() {

        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.txtCityName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.txtCityName.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.txtCityName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -45).isActive = true
        self.txtCityName.heightAnchor.constraint(equalToConstant: 40).isActive = true

        self.activityIndicator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.txtCityName.centerYAnchor).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true

        self.imgSearch.trailingAnchor.constraint(equalTo: self.activityIndicator.trailingAnchor).isActive = true
        self.imgSearch.centerYAnchor.constraint(equalTo: self.activityIndicator.centerYAnchor).isActive = true
        self.imgSearch.heightAnchor.constraint(equalToConstant: 22).isActive = true
        self.imgSearch.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        
        
        
    }
    
    


}
