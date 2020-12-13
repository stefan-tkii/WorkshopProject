//
//  ViewController.swift
//  WorkshopProject
//
//  Created by Stefan Kjoropanovski on 12/11/20.
//  Copyright © 2020 Stefan Kjoropanovski-Resen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
      
    @IBOutlet weak var registerView: UIView!
      
    @IBOutlet weak var selectView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectView.selectedSegmentIndex = 0
        loginView.alpha = 1
        registerView.alpha = 0
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0 {
            loginView.alpha = 1
            registerView.alpha = 0
        }
        else {
            loginView.alpha = 0
            registerView.alpha = 1
        }
    }
    
}
