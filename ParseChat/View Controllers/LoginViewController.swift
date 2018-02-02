//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Joseph Davey on 1/29/18.
//  Copyright © 2018 Joseph Davey. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    let alertController = UIAlertController(title: "Username or password is empty", message: "", preferredStyle: .alert)
    let alertControllerInvalidUsername = UIAlertController(title: "Invalid username or password", message: "", preferredStyle: .alert)
    let alertControllerAccountExists = UIAlertController(title: "Account already exists for this username", message: "", preferredStyle: .alert)
    
    @IBOutlet weak var userNameBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
        //loginUser()
        if (!userNameBox.hasText || !passwordBox.hasText) {
            present(alertController, animated: true)
            print("Empty Fields")
            return
        }
        PFUser.logInWithUsername(inBackground: (userNameBox.text)!, password: (passwordBox.text)!) { (user: PFUser?, NSError) in
            if NSError != nil {
                self.present(self.alertControllerInvalidUsername, animated: true)
            } else {
                print("User is logged in")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
    @IBAction func signupButton(_ sender: Any) {
        //registerUser()
        if (!userNameBox.hasText || !passwordBox.hasText) {
            present(alertController, animated: true)
            print("Empty Fields")
            return
        }
        let newuser = PFUser()
        newuser.username = userNameBox.text
        newuser.password = passwordBox.text
        newuser.signUpInBackground { (success: Bool, NSError) in
            if success {
                print("User created")
            } else {
                print(NSError?.localizedDescription)
                self.present(self.alertControllerAccountExists, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action) in
            //handle the response here
        }
        alertController.addAction(OKAction)
        alertControllerInvalidUsername.addAction(OKAction)
        alertControllerAccountExists.addAction(OKAction)
        userNameBox.layer.cornerRadius = 10
        passwordBox.layer.cornerRadius = 10
        logInButton.layer.cornerRadius = 10
    }
    
    func registerUser() {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = userNameBox.text
        newUser.password = passwordBox.text
        
        if (!userNameBox.hasText || !passwordBox.hasText) {
            present(alertController, animated: true)
            print("Empty Fields")
            return
        }
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
            }
        }
    }

    func loginUser() {
        
        let username = userNameBox.text ?? ""
        let password = passwordBox.text ?? ""
        
        if (!userNameBox.hasText || !passwordBox.hasText) {
            present(alertController, animated: true)
            print("Empty Fields")
            return
        }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
