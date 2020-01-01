//
//  DetailPhotoViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 1/1/20.
//  Copyright © 2020 Lam Huong. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        self.viewWillAppear(true)
        // Do any additional setup after loading the view.
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
