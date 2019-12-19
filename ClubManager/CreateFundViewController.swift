//
//  CreateFundViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/3/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SCLAlertView

class CreateFundViewController: UIViewController {
  
    let db = Firestore.firestore()
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var contentFund: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
          self.HiddenKeyBoard()
        
        // Do any additional setup after loading the view.
        setUpElement()
    }
    @objc func dissmissKeyboard() {
               view.endEditing(true)
           }
    
    func setUpElement(){
        Utilities.styleTextField(amountTextField)
        contentFund.layer.borderWidth = 1
        Utilities.styleFilledButton(collectButton)
        Utilities.styleFilledButton(payButton)
        Utilities.styleHollowButton(backButton)
        errorLabel.alpha = 0
    }
    @IBAction func collectTapped(_ sender: Any) {
        let check = checkComplete()
        if (check == true){
            db.collection("fund").document("total").getDocument { (querySnapshot, err) in
                let amount = querySnapshot?.data()!["amount"] as! String
                let collect = self.amountTextField.text
                let amountInt = amount.convertStringToInt()
                let collectInt = collect!.convertStringToInt()
                let newAmount = amountInt + collectInt
                let newAmountString = String(newAmount)
                self.db.collection("fund").document("total").updateData(["amount": newAmountString]){(err) in
                    self.setFund(choice: "collect")
                }
            }
        }
        
    }
    
    
    @IBAction func payTapped(_ sender: Any) {
        let check = checkComplete()
        if (check == true){
            db.collection("fund").document("total").getDocument { (querySnapshot, err) in
                       let amount = querySnapshot?.data()!["amount"] as! String
                       let pay = self.amountTextField.text
                       let amountInt = amount.convertStringToInt()
                       let payInt = pay!.convertStringToInt()
                       if (payInt > amountInt){
                           let alert = SCLAlertView()
                           alert.showError("", subTitle: "The amount of fund do not enough")
                       }
                       else {
                           let newAmount = amountInt - payInt
                           let newAmountString =  String(newAmount)
                           self.db.collection("fund").document("total").updateData(["amount": newAmountString]){(err) in
                               self.setFund(choice: "pay")
                           }
                       }
                       
                   }
        }
       
    }
    
    func checkComplete()->Bool{
        if (amountTextField.text == "" || contentFund.text == "")
        {
            errorLabel.alpha = 1
            errorLabel.text = "Please complete info"
            return false
        }
        return true
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    func setFund(choice: String){
        let document = contentFund.text
        let amount = amountTextField.text
        if (choice == "collect"){
            let collectAmount = "+" + amount!
            db.collection("fund").document(document!).setData(["amount": collectAmount, "reason": document]) {(err) in
                let alert = SCLAlertView()
                self.amountTextField.text = ""
                self.contentFund.text = ""
                self.errorLabel.alpha = 0
                alert.showSuccess("", subTitle: "The fund is created")
            }
        }
        else{
            let payAmount = "-" + amount!
            db.collection("fund").document(document!).setData(["amount": payAmount, "reason": document]) {(err) in
                let alert = SCLAlertView()
                self.amountTextField.text = ""
                self.contentFund.text = ""
                self.errorLabel.alpha = 0
                alert.showSuccess("", subTitle: "The fund is created")
            }
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

}
extension String {
    func convertStringToInt() -> Int {
        return Int(Double(self) ?? 0.0)
    }
}

extension CreateFundViewController{
    func HiddenKeyBoard(){
        
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textDismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    @objc func textDismissKeyboard(){
        view.endEditing(true)
    }
}
