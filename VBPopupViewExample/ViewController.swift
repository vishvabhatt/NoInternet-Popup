//
//  ViewController.swift
//  VBPopupViewExample
//
//  Created by SOTSYS098 on 30/06/20.
//  Copyright © 2020 VishvaBhatt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let connectivityType = "\(ConnetivitySetup.shared.connectivityType)"
        self.lbl.text = "Connectivity Type: \(connectivityType.capitalized)"
    }


}

