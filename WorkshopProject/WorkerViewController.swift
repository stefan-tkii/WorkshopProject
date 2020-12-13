//
//  WorkerViewController.swift
//  WorkshopProject
//
//  Created by Stefan Kjoropanovski on 12/12/20.
//  Copyright © 2020 Stefan Kjoropanovski-Resen. All rights reserved.
//

import UIKit

class WorkerViewController: UIViewController {
    
    var workerInfo: String = ""

    @IBOutlet weak var workerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.workerLabel.text = self.workerInfo
    }
    
}
