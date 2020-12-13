//
//  LoginViewController.swift
//  WorkshopProject
//
//  Created by Stefan Kjoropanovski on 12/12/20.
//  Copyright © 2020 Stefan Kjoropanovski-Resen. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func doLogin(_ sender: UIButton)
    {
        if(emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty)
        {
            displayAlert("Input error", "Email and/or password fields must not be empty!")
            return
        }
        PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: {
            (user, error) in
            if let loggedInUser = user {
                if((loggedInUser["type"] as! String) == "Regular")
                {
                    self.performSegue(withIdentifier: "regularView", sender: self)
                }
                else if((loggedInUser["type"] as! String) == "Worker")
                {
                    self.performSegue(withIdentifier: "workerView", sender: self)
                }
                else {
                    fatalError("Error data info is incorrect.")
                }
            }
            else {
                if let err = error {
                    self.displayAlert("Error", err.localizedDescription)
                }
                else {
                    print("Unkown error.")
                }
            }
        })
    }
    
    func displayAlert(_ title: String, _ message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "regularView")
        {
            var dest = segue.destination as! RegularViewController
            dest.userInfo = self.emailTextField.text!
            dest.navigationItem.hidesBackButton = true
        }
        else if(segue.identifier == "workerView")
        {
            var dest = segue.destination as! WorkerViewController
            dest.workerInfo = "Welcome back " + self.emailTextField.text!
            dest.navigationItem.hidesBackButton = true
        }
        else
        {
            print("Error unkown segue.")
        }
    }
    
}
