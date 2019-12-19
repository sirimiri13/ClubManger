//
//  CreatePostViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/3/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import SCLAlertView
import FirebaseAuth
import Firebase





class CreatePostViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
  
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    let user = Auth.auth().currentUser?.email
    let db = Firestore.firestore()
    var timePicked : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HiddenKeyBoard()
       setUpElement()
        // Do any additional setup after loading the view.
        timePicker.addTarget(self, action: #selector(CreatePostViewController.dataPickerChanged(_:)), for: .valueChanged)
    }
    @objc func dissmissKeyboard() {
               view.endEditing(true)
           }
    func setUpElement(){
        Utilities.styleTextField(titleTextField)
        Utilities.styleTextField(addressTextField)
        contentTextView.layer.borderWidth = 1
        Utilities.styleFilledButton(postButton)
        Utilities.styleHollowButton(backButton)
        errorLabel.alpha = 0
    }
    
    /*@objc func dateChanged(birthdayPicker: UIDatePicker){
           let time = DateIntervalFormatter
        time. = "MMM dd, yyyy"
           birthdayText.text = birthdayFormatter.string(from: birthdayPicker.date)
       }*/
       
    
    @objc func dataPickerChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        timePicked = selectedDate
    }
   
    

    @IBAction func postTapped(_ sender: Any) {
        let check = checkComplete()
        if check == true {
        let today = Date()
               let formatter3 = DateFormatter()
               formatter3.dateFormat = "HH:mm E, d MMM y"
               let timePost = formatter3.string(from: today)
               let time = timePicked
               let title = titleTextField.text
               let address = addressTextField.text
               let content = contentTextView.text
                   db.collection("post").document(title!).setData(["title": title, "address": address ,"time": time, "content": content, "timePost": timePost])  {(error) in
                       let alert = SCLAlertView()
                       alert.showSuccess("", subTitle:  "POSTED!")
                   self.titleTextField.text = ""
                   self.addressTextField.text = ""
                   self.contentTextView.text = ""
                    self.errorLabel.alpha = 0
                   }
               }
               
        }
    
    func checkComplete()->Bool{
        if (titleTextField.text == "" || addressTextField.text == ""  || contentTextView.text == ""){
            errorLabel.alpha = 1
            errorLabel.text = "Please complete info"
            return false
        }
        else {
            return true
        }
    
    }
    func transitionHome(){
           let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.postTableView) as? PostTableViewController
           view.window?.rootViewController = mainView
           view.window?.makeKeyAndVisible()
       }

}

extension CreatePostViewController{
    func HiddenKeyBoard(){
        
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textDismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    @objc func textDismissKeyboard(){
        view.endEditing(true)
    }
}
