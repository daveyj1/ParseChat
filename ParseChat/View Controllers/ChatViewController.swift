//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Joseph Davey on 2/2/18.
//  Copyright © 2018 Joseph Davey. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var keyboardField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let alertController = UIAlertController(title: "Message could not be sent", message: "", preferredStyle: .alert)
    var messages: [PFObject] = []
    
    @IBAction func sendMessage(_ sender: Any) {
        if (keyboardField.text == "") {
            print("No message sent. Empty text field")
            return
        }
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = keyboardField.text ?? ""
        chatMessage["user"] = PFUser.current()
        print("USER \(chatMessage["user"])")
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                self.present(self.alertController, animated: true)
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        keyboardField.text = ""
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        present(viewController!, animated: true, completion: nil)
        print("User has been logged out")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardField.layer.cornerRadius = 10
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action) in
        }
        alertController.addAction(OKAction)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = .none
        
        getMessages()
    }
    
    @objc func getMessages() {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.findObjectsInBackground(block:  { (messages, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else if let messages = messages {
                self.messages = messages
                self.tableView.reloadData()
                //self.getMessages()
                print(messages)
            }
        })
    }
    
    @objc func onTimer() {
        getMessages()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let message = messages[indexPath.row]
        cell.messageLabel.text = " \(message["text"] as! String ?? "") "
        cell.messageLabel.sizeToFit()
        //cell.
        
        if let user = message["user"] as? PFUser {
            cell.usernameLabel.text = user.username
        } else {
            cell.usernameLabel.text = "🤖"
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
