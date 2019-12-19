//
//  PostViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/18/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    
    var titlePost: String = ""
    var contentPost: String = ""
    var timePost: String = ""
    var addressPost: String = ""
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElement()
        setLabel()

    }
    func setUpElement(){
        Utilities.styleFilledButton(cancelButton)
    }

    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func setLabel(){
        titleLabel.text = titlePost
        contentLabel.text = contentPost
        timeLabel.text = timePost
        addressLabel.text = addressPost
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
