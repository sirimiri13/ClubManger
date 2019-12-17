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
  
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    let user = Auth.auth().currentUser?.email
    let db = Firestore.firestore()
    var timePicked : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       setUpElement()
        // Do any additional setup after loading the view.
        timePicker.addTarget(self, action: #selector(CreatePostViewController.dataPickerChanged(_:)), for: .valueChanged)
    }
    
    func setUpElement(){
        Utilities.styleTextField(titleTextField)
        Utilities.styleTextField(addressTextField)
        contentTextView.layer.borderWidth = 1
        Utilities.styleFilledButton(postButton)
        Utilities.styleHollowButton(backButton)
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
   
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
            
    }
    
    @IBAction func postTapped(_ sender: Any) {
        if (titleTextField.text != "" || addressTextField.text != "" || contentTextView.text != ""){
        let time = timePicked
        let title = titleTextField.text
        let address = addressTextField.text
        let content = contentTextView.text
        db.collection("post").document(title!).setData(["title": title, "address": address ,"time": time, "content": content])  {(error) in
                let alert = SCLAlertView()
                alert.showSuccess("", subTitle:  "POSTED!")
            self.titleTextField.text = ""
            self.addressTextField.text = ""
            self.contentTextView.text = ""
            }
        }
        else {
            let alert = SCLAlertView()
            alert.showWarning("", subTitle: "Please complete info")
        }
        
       
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func transitionHome(){
           let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.postTableView) as? PostTableViewController
           view.window?.rootViewController = mainView
           view.window?.makeKeyAndVisible()
       }

}
