//
//  UIView_addSubViews.swift
//  IOS2-MapKit
//
//  Created by Daniel Carvalho on 2022-02-18.
//

import Foundation
import UIKit


extension UIView {
    

    func addSubviews( _ subviews : UIView... ) {
        
        for subView in subviews {
            self.addSubview(subView)
        }
        
    }
    
    
}
