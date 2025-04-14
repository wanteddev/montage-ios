//
//  BaseViewController.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/04/06.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit
import Montage

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseSetup()
        baseBind()
    }
    
    func baseSetup() {
        view.backgroundColor = .semantic(.backgroundNormal)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func baseBind() {}
}
