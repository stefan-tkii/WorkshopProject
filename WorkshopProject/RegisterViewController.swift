//
//  RegisterViewController.swift
//  WorkshopProject
//
//  Created by Stefan Kjoropanovski on 12/12/20.
//  Copyright © 2020 Stefan Kjoropanovski-Resen. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var fullnameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var accountTypeSwitch: UISwitch!
    
    @IBOutlet weak var specialistLabel: UILabel!
    
    @IBOutlet weak var workerTypeSwitch: UISwitch!
    
    @IBOutlet weak var expertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func onAccountTypeValueChanged(_ sender: UISwitch)
    {
        if(sender.isOn)
        {
            specialistLabel.isHidden = false
            expertLabel.isHidden = false
            workerTypeSwitch.isHidden = false
        }
        else
        {
            specialistLabel.isHidden = true
            expertLabel.isHidden = true
            workerTypeSwitch.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        specialistLabel.isHidden = true
        expertLabel.isHidden = true
        workerTypeSwitch.isHidden = true
        accountTypeSwitch.isOn = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        fullnameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
    }
    
    func displayAlert(_ title: String, _ message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doRegister(_ sender: UIButton)
    {
        if(emailTextField.text!.isEmpty || fullnameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || phoneTextField.text!.isEmpty)
        {
            displayAlert("Form error", "All input fields are required!")
            return
        }
        if(passwordTextField.text != confirmPasswordTextField.text)
        {
            displayAlert("Password error", "Passwords do not match!")
            return
        }
        
        /*
        if(checkIfAccountExists(emailTextField.text!))
        {
            displayAlert("Account error", "An account with that email already exists.")
            return
        }
        */
        
        //Zabeleska: Parse sam proveruva dali akaunt so dadeniot username vekje postoi :)
        
        let user = PFUser()
        user.email = emailTextField.text
        user.username = emailTextField.text
        user.password = passwordTextField.text
        user["phone"] = phoneTextField.text
        user["fullName"] = fullnameTextField.text
        if accountTypeSwitch.isOn
        {
            user["type"] = "Worker"
        }
        else
        {
            user["type"] = "Regular"
        }
        if (!workerTypeSwitch.isHidden)
        {
            if(workerTypeSwitch.isOn)
            {
                user["workerType"] = "Expert"
            }
            else
            {
                user["workerType"] = "Specialist"
            }
        }
        user.signUpInBackground(block: {
            (result, error) in
            if((error == nil) && (result == true))
            {
                self.performSegue(withIdentifier: "nextLogin", sender: self)
            }
            else
            {
                if let err = error {
                    self.displayAlert("Error", err.localizedDescription)
                }
                else {
                    print("Unknown error!")
                }
            }
        })
    }
    
    /*
    func checkIfAccountExists(_ email: String) -> Bool
    {
        var result = false
        let findExistingUserAccountQuery = PFUser.query()
        findExistingUserAccountQuery?.whereKey("email", equalTo: email)
        findExistingUserAccountQuery?.findObjectsInBackground(block: {
            (objects: [PFObject]?, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            else {
                if(objects!.count > 0)
                { result = true }
                else
                { result = false }
            }
        })
        return result
    }
 */
    
}
