//
//  AlertPopup.swift
//  PregnancyWorkout
//
//  Created by SOTSYS098 on 21/11/19.
//  Copyright © 2019 DaveChue. All rights reserved.
//

import UIKit

enum ShowAlertPopup {
    case NoInternet
}

@objc protocol AlertPopupDelegate {
    func closePopupView()
}

#if os(iOS) || os(tvOS)

extension NSObject {
    public var className: String {
        return type(of: self).className
    }
    
    public static var className: String {
        return String(describing: self)
    }
}

#endif


class AlertPopup: UIView {

    @IBOutlet weak var viewNoInternet: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnRetry: UIButton!

    var delegate : AlertPopupDelegate?
    var animationType : AnimationType = .Scale
    let animationTime = ConnetivitySetup.shared.animationTime
    let connectivityType = ConnetivitySetup.shared.connectivityType
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
      
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
          
    }
    
    class var instanceFromNib:AlertPopup {
        return UINib(nibName: AlertPopup.className, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AlertPopup
    }
    
    func setupAlertView(type:ShowAlertPopup) {
        self.viewNoInternet.isHidden = !(type == .NoInternet)
        switch type {
        case .NoInternet:
            let imageName = self.connectivityType == .wifi ? "wifi" : "Cellular"
            self.imageViewIcon.image = UIImage(imageLiteralResourceName: imageName)
        }
    }
    
    func dissmissMe(animationType:AnimationType) {
       self.endEditing(true)
       UIView.animate(withDuration: animationTime , animations:
           {
            self.alpha = 0.0
            self.transform = animationType == .Scale ? CGAffineTransform.init(scaleX: 0.1, y: 0.1) : CGAffineTransform(translationX: 0.0, y: self.frame.height)
       },
            completion: { finish in
            self.delegate?.closePopupView()
            self.removeFromSuperview()
       })
    }
   
    @IBAction func actionRetry(_ sender: Any) {
        if ConnetivitySetup.shared.isInternetAvalable == true {
            self.dissmissMe(animationType: animationType)
            UIView.animate(withDuration: animationTime, animations: {
                ConnetivitySetup.shared.blurEffectView.alpha = 0.0
            }) { (isCom) in
                ConnetivitySetup.shared.blurEffectView.removeFromSuperview()
            }
        }
        else{
            
        }
    }

    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dissmissMe(animationType: animationType)
    }
    
}
