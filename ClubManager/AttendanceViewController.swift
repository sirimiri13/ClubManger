//
//  AttendanceViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/3/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SCLAlertView

class cellAttendance: UITableViewCell{

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
}

struct MemberAttendance {
    var name: String
    var id : String
}


class AttendanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    @IBOutlet weak var tableAttendaceView: UITableView!
    var forwardView : String = ""
    let mail = Auth.auth().currentUser?.email
    var eventName : String = ""
    var collect : String = ""
    var idList : [String] = []
    let db = Firestore.firestore()
    var idSuggest: [String] = []
    var autoCompleteCharacterCount = 0
    var timer = Timer()
    var memberAttendance = [MemberAttendance]()
    //var memInList = [MemberAttendance]()
   // var countMem = 0
    var count = 0
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var eventNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCollection()
        idTextField.delegate = self
        setUpElement()
        setEvent()
        setID()

        
        // Do any additional setup after loading the view.
    }
    
    func setUpElement(){
    if (forwardView == "AttendanceTableViewController")
    {
        if (collect == "user"){
            idTextField.alpha = 0
            checkButton.alpha = 0
        }
    }
        
        Utilities.styleTextField(idTextField)
        Utilities.styleFilledButton(checkButton)
        Utilities.styleHollowButton(doneButton)
        
    }
    
    func setEvent(){
        eventNameLabel.text = eventName
        if (forwardView == "AttendanceTableViewController") {
            for i in 0...count{
                self.pickMember(i: i)
                tableAttendaceView.reloadData()
            }
        }
    }
      
        
    
    func checkCollection(){
        db.collection("user").getDocuments { (querySnapshot, error) in
                 for acc in querySnapshot!.documents{
                     if (acc.documentID == self.mail){
                        self.collect = "user"
                    }
            }
        }
        if (collect == "")
            {
                collect = "admin"
            }
       
    }
    
    func setID(){
        db.collection("user").getDocuments { (querySnapshot, err) in
            //var newListID :[String] = []
            for user in querySnapshot!.documents{
                let ID = user.data()["ID"] as! String
                self.idSuggest.append(ID)
            }
        }
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { //1
          var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string) // 2
          subString = formatSubstring(subString: subString)
          
          if subString.count == 0 { // 3 when a user clears the textField
              resetValues()
          } else {
              searchAutocompleteEntriesWIthSubstring(substring: subString) //4
          }
          return true
      }
      func formatSubstring(subString: String) -> String {
          let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized //5
          return formatted
      }
      
      
      
      func resetValues() {
          autoCompleteCharacterCount = 0
          idTextField.text = ""
      }
   
    func searchAutocompleteEntriesWIthSubstring(substring: String) {
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(userText: substring) //1
        
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //2
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions) // 3
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery) //4
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery) //5
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //7
                self.idTextField.text = substring
            })
            autoCompleteCharacterCount = 0
        }
    }
   
    
     func getAutocompleteSuggestions(userText: String) -> [String]{
            var possibleMatches: [String] = []
            for item in idSuggest { //2
                let myString:NSString! = item as NSString
                let substringRange :NSRange! = myString.range(of: userText)
                
                if (substringRange.location == 0)
                {
                    possibleMatches.append(item)
                }
            }
            return possibleMatches
        }
        
        func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
            let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
            colouredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSRange(location: userQuery.count,length:autocompleteResult.count))
            self.idTextField.attributedText = colouredString
        }
        func moveCaretToEndOfUserQueryPosition(userQuery : String) {
            if let newPosition = self.idTextField.position(from: self.idTextField.beginningOfDocument, offset: userQuery.count) {
                self.idTextField.selectedTextRange = self.idTextField.textRange(from: newPosition, to: newPosition)
            }
            let selectedRange: UITextRange? = idTextField.selectedTextRange
            idTextField.offset(from: idTextField.beginningOfDocument, to: (selectedRange?.start)!)
        }
        func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
            var autoCompleteResult = possibleMatches[0]
            autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
            autoCompleteCharacterCount = autoCompleteResult.count
            return autoCompleteResult
        }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func checkTapped(_ sender: Any) {
       if (forwardView == "AttendanceTableViewController") {
        print(self.count)
        }
        var id : String = ""
        db.collection("user").getDocuments { (querySnapshot, err) in
            for user in querySnapshot!.documents{
                let ID = user.data()["ID"] as! String
                if (ID == self.idTextField.text){
                    let fName = user.data()["firstName"] as! String
                    let lName = user.data()["lastName"] as! String
                    let name = lName + " " + fName
                    let newMember  = MemberAttendance(name: name, id: ID)
                    self.memberAttendance.append(newMember)
                    id = "ID" + String(self.count)
                    let newID = self.idTextField.text!
                    self.tableAttendaceView.reloadData()
                    self.idTextField.text = ""
                    self.db.collection("event").document(self.eventName).updateData([id: newID])
                    self.db.collection("event").document(self.eventName).updateData(["count": self.count + 1])
                    self.count += 1
                }
               
            }
        }
    }
    
//func setInfoTable(){
//    print(count)
//    for i in 0..<count{
//        pickMember(i: i)
//        tableAttendaceView.reloadData()
//    }
//}
//
    func pickMember(i: Int){
        let index = "ID" + String(i)
        db.collection("event").document(eventName).getDocument { (querySnapshot, err) in
            let idMem = querySnapshot?.data()![index] as! String
            self.db.collection("user").getDocuments { (querySnapshot_user, err) in
                for info in querySnapshot_user!.documents{
                    if idMem == info.data()["ID"] as! String {
                        let fName = info.data()["firstName"] as! String
                        let lName = info.data()["lastName"] as! String
                        let name = lName + " " + fName
                        let newMem = MemberAttendance(name: name, id: idMem)
                        self.memberAttendance.append(newMem)
                        self.tableAttendaceView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AttendanceTableViewController") as! AttendanceTableViewController
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: false)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberAttendance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableAttendaceView.dequeueReusableCell(withIdentifier: "cellAttendance", for: indexPath) as! cellAttendance
       
            cell.nameLabel.text = memberAttendance[indexPath.row].name
            cell.idLabel.text = memberAttendance[indexPath.row].id
        
        return cell
        
    }

}
