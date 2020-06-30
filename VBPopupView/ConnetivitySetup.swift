//
//  ConnetivitySetup.swift
//  VBPopupView
//
//  Created by SOTSYS098 on 30/06/20.
//  Copyright © 2020 VishvaBhatt. All rights reserved.
//

import Foundation
import UIKit
import Reachability


enum ConnectionType {
    case wifi
    case mobileNetwork
    case noConnection
}

enum AnimationType {
    case Scale
    case Transform
}

let kBlurViewTag = 3998
let kPopupViewTag = 8993

final class ConnetivitySetup {
    
    //MARK:- Class Setup
    static let shared = ConnetivitySetup()
    
    private init() {
        if self.reachability == nil {
            if let rech = try? Reachability() {
                self.reachability = rech
            }else{
                fatalError("Rechability is not available")
            }
        }
    }
    
    //MARK:- Required Variables
    var reachability : Reachability?
    var blurEffectView = UIVisualEffectView()
    var isInternetAvalable = true
    var connectivityType : ConnectionType = .noConnection
    var animationTime : TimeInterval = 0.3
    var animationType : AnimationType = .Scale
    
    //MARK:- Required Methods
    func deinintReachabilityNotification() {
        guard let rech = self.reachability else {
            return
        }
        rech.stopNotifier()
    }
    
    
    func isInternetAvailable() -> Bool{
        guard let rech = self.reachability else {
            return false
        }
        switch rech.connection {
        case .cellular,.wifi: self.connectivityType = rech.connection == .wifi ? .wifi : .mobileNetwork; return true
        default:
            self.connectivityType = .noConnection
            return false
        }
    }
  
    func closePopupView() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        UIView.animate(withDuration: animationTime, animations: {
            window.viewWithTag(kPopupViewTag)?.alpha = 0.0
            self.blurEffectView.alpha = 0.0
        }) { (isCompleted) in
            window.viewWithTag(kPopupViewTag)?.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
        }
        
    }
    
    @objc func internetStatus(noti:Notification){
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        if let isInternetOn = noti.object as? Bool {
            if isInternetOn == true {
                if window.viewWithTag(kPopupViewTag) != nil {
                    self.closePopupView()
                    // HIDE LOADER IS ANY RUNNING
                }
            }
            else{
            }
        }
    }
    
    func showInternetError(){
          
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = .clear
        blurEffectView.alpha = 0.0
        blurEffectView.tag = kBlurViewTag
        
        if !(window.subviews.contains(where: {$0.tag == kBlurViewTag}) ) {
            window.addSubview(blurEffectView)
        }

        
        let popupView = AlertPopup.instanceFromNib
        popupView.frame = window.frame
        popupView.tag = kPopupViewTag
        popupView.setupAlertView(type: ShowAlertPopup.NoInternet)
        
        if !(window.subviews.contains(where: {$0.tag == kPopupViewTag}) ) {
            window.addSubview(popupView)
        }
        switch self.animationType {
        case .Scale:
            popupView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        default:
            break
        }
        UIView.animate(withDuration: 0.5 , animations:
            {
                self.blurEffectView.alpha = 0.85
                self.animationType = .Scale
                switch self.animationType {
                case .Scale:
                    popupView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                default:
                    break
                }
        },
                       completion: { finish in
        })
    }
    
    func checkReachability()  {
        guard let rech = self.reachability else {
            return
        }
        if self.isInternetAvailable() == false {
            self.showInternetError()
        }
        
        do {
            try rech.startNotifier()
        } catch {
            debugPrint("Unable to start notifier")
        }
        rech.whenReachable = { reachability in
            switch rech.connection {
            case .cellular,.wifi:
                self.connectivityType = rech.connection == .wifi ? .wifi : .mobileNetwork;
                self.isInternetAvalable = true
                debugPrint("Reachable via WiFi")
            default:
                self.connectivityType = .noConnection
                self.isInternetAvalable = false
                debugPrint("Not reachable")
            }
            
            self.closePopupView()
        }
        rech.whenUnreachable = { _ in
            debugPrint("Not reachable")
            self.isInternetAvalable = false
            self.showInternetError()
        }
        
    }
    
}
