//
//  UICityInfoView.swift
//  IOS2-FinalExam-Winter2022-Weather
//
//  Created by Daniel Carvalho on 2022-03-20.
//

import UIKit

class UICityInfoView: UIView {
    
    private static func defaultLabel( text : String, textColor : UIColor = .black, textAlignment : NSTextAlignment = .center, fontSize : CGFloat = 12, fontBold : Bool = false, numberOfLines : Int = 1 ) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.textAlignment = textAlignment
        lbl.textColor = textColor
        lbl.numberOfLines = numberOfLines
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = fontBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        return lbl
    }
    
    private let vContainer : UIView = {
        let container = UIView()
        container.backgroundColor = .white.withAlphaComponent(0.90)
        container.layer.cornerRadius = 30
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let imgWeather : UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    
    private var lblCity : UILabel = defaultLabel(text: "(unknow)", textColor: .black, textAlignment: .center, fontSize: 20.0, fontBold: true)
                
    private var lblRegion : UILabel = defaultLabel(text: "(unknow)", textColor: .lightGray, textAlignment: .center)
    
    private let lblTimeZone : UILabel = defaultLabel(text: "(unknow)", textColor: .gray, fontSize: 18)
    
    private let lblDate : UILabel = defaultLabel(text: "(unknow)", textColor: .systemBlue, fontSize: 18)
    private let lblTime : UILabel = defaultLabel(text: "(unknow)", textColor: .systemRed, fontSize: 22, fontBold: true)
    
    private let lblTempF : UILabel = defaultLabel(text: "??", textColor: .gray, fontSize: 20, fontBold: true)
    private let lblCondition : UILabel = defaultLabel(text: "condition", textColor: .gray, fontSize: 12, numberOfLines: 2)

    
    private var localDateTime = Date()
    
    private var timer = Timer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func show(city : String, region : String, timeZone : String, temperature : Double, condition : String, conditionImage : String?) {
        
        self.lblCity.text = city
        self.lblRegion.text = region
        self.lblTimeZone.text = timeZone
        
        if conditionImage != nil {
            self.imgWeather.fetchUImageFromURL(url: URL(string: "https:\(conditionImage!)")!)
            self.imgWeather.isHidden = false
        } else {
            self.imgWeather.isHidden = true
        }
        
        self.lblTempF.text = String(format: "%.0f", temperature ) + "\u{00B0}F"
        self.lblCondition.text = condition
        
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.clockTick) , userInfo: nil, repeats: true)
        
        self.showDateTime()
        
        self.isHidden = false
        
    }
    
    @objc private func clockTick() {
        
        self.localDateTime = self.localDateTime.addingTimeInterval(1)
        
        DispatchQueue.main.async {
            
            self.showDateTime()
            
        }
        
    }
    
    
    private func showDateTime() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: self.lblTimeZone.text!)
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        self.lblDate.text = dateFormatter.string(from: self.localDateTime)
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        self.lblTime.text = dateFormatter.string(from: self.localDateTime)
        
    }
    
    public func close() {
        
        self.isHidden = true
        
        self.timer.invalidate()
        
    }
    
    
    private func initialize() {
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        self.addSubview(vContainer)
        self.vContainer.addSubviews(lblCity,
                                    lblRegion,
                                    lblTimeZone,
                                    lblDate,
                                    lblTime,
                                    imgWeather,
                                    lblTempF,
                                    lblCondition)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        
        vContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            vContainer.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                vContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                    vContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                    
                    lblCity.leadingAnchor.constraint(equalTo: vContainer.leadingAnchor, constant: 40).isActive = true
                    lblCity.topAnchor.constraint(equalTo: vContainer.topAnchor, constant: 10).isActive = true
                lblCity.centerXAnchor.constraint(equalTo: vContainer.centerXAnchor).isActive = true
                

                
                lblRegion.topAnchor.constraint(equalTo: lblCity.bottomAnchor).isActive = true
                    lblRegion.trailingAnchor.constraint(equalTo: lblCity.trailingAnchor, constant: -10).isActive = true
                lblRegion.heightAnchor.constraint(equalToConstant: 24).isActive = true
                lblRegion.centerXAnchor.constraint(equalTo: lblCity.centerXAnchor).isActive = true
                
                lblTimeZone.leadingAnchor.constraint(equalTo: lblRegion.leadingAnchor).isActive = true
                lblTimeZone.topAnchor.constraint(equalTo: lblRegion.bottomAnchor, constant: 10).isActive = true
                lblTimeZone.trailingAnchor.constraint(equalTo: lblRegion.trailingAnchor).isActive = true
                
                lblDate.leadingAnchor.constraint(equalTo: lblTimeZone.leadingAnchor).isActive = true
                lblDate.topAnchor.constraint(equalTo: lblTimeZone.bottomAnchor, constant: 10).isActive = true
                lblDate.trailingAnchor.constraint(equalTo: lblTimeZone.trailingAnchor).isActive = true
                
                lblTime.leadingAnchor.constraint(equalTo: lblDate.leadingAnchor).isActive = true
                lblTime.topAnchor.constraint(equalTo: lblDate.bottomAnchor, constant: 5).isActive = true
                lblTime.trailingAnchor.constraint(equalTo: lblDate.trailingAnchor).isActive = true
                
                imgWeather.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
                imgWeather.topAnchor.constraint(equalTo: lblDate.topAnchor).isActive = true
                imgWeather.heightAnchor.constraint(equalToConstant: 60).isActive = true
                imgWeather.widthAnchor.constraint(equalToConstant: 60).isActive = true

        lblTempF.topAnchor.constraint(equalTo: lblDate.topAnchor).isActive = true
        lblTempF.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        lblTempF.widthAnchor.constraint(equalTo: imgWeather.widthAnchor).isActive = true
                
                lblCondition.topAnchor.constraint(equalTo: lblTempF.bottomAnchor).isActive = true
        lblCondition.trailingAnchor.constraint(equalTo: lblTempF.trailingAnchor).isActive = true
                lblCondition.widthAnchor.constraint(equalTo: lblTempF.widthAnchor).isActive = true
                lblCondition.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
}
