//
//  WorkersTableViewController.swift
//  WorkshopProject
//
//  Created by Stefan Kjoropanovski on 12/13/20.
//  Copyright © 2020 Stefan Kjoropanovski-Resen. All rights reserved.
//

import UIKit
import Parse

class WorkersTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var workersTableView: UITableView!
    
    var workersArray = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workersTableView.dataSource = self
        workersTableView.delegate = self
        getWorkers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func getWorkers()
    {
       let userQuery = PFQuery(className: "_User")
        userQuery.whereKey("type", equalTo: "Worker")
        userQuery.findObjectsInBackground(block: {
            (result: [PFObject]?, error: Error?) -> Void in
            if let foundUsers = result as? [PFUser]
            {
                self.workersArray = foundUsers
                self.workersTableView.reloadData()
            }
            else
            {
                if let err = error
                {
                    print(err.localizedDescription)
                }
                else
                {
                    print("Unkown error.")
                }
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workerCell", for: indexPath)
        let userObject: PFUser = self.workersArray[indexPath.row]
        let fullName = userObject.object(forKey: "fullName") as? String
        let workerType = userObject.object(forKey: "workerType") as? String
        print(fullName)
        print(workerType)
        cell.textLabel?.text = "Full name: " + fullName! + ",   type: " + workerType!
        return cell
    }
    
}
