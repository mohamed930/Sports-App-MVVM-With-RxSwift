//
//  Progress.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import UIKit
import RappleProgressHUD

extension UIViewController {
    
    func ShowProgress (Title: String) {
        RappleActivityIndicatorView.startAnimatingWithLabel(Title, attributes: RappleModernAttributes)
    }
    
    
    func DismissProgress() {
        RappleActivityIndicatorView.stopAnimation()
    }
    
    func MakeRound(myView:AnyObject,v:CACornerMask) {
        //myView.clipsToBounds = true
        if #available(iOS 13.0, *) {
            myView.layer.cornerRadius = 27.0
        } else {
            // Fallback on earlier versions
        }
        
        /*
            top-right:    layerMaxXMinYCorner
            top-left:     layerMinXMinYCorner
            button-right: layerMaxXMaxYCorner
            button-left:  layerMinXMaxYCorner
         */
        if #available(iOS 13.0, *) {
            myView.layer.maskedCorners = v
        } else {
            // Fallback on earlier versions
        }
    }
    
    func PlaceHolder (textField: UITextField, PlaceHolder: String, Color: UIColor) {
        
        textField.textAlignment = .left
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.attributedPlaceholder = NSAttributedString(string: PlaceHolder,
                attributes: [NSAttributedString.Key.foregroundColor: Color])
        
    }
}
