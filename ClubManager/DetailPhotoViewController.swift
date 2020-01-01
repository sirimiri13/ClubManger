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
    var album : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        self.viewWillAppear(true)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AlbumCollectionViewController") as! AlbumCollectionViewController
        vc.forwardView = "DetailPhoto"
        vc.albumName = album
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: false)
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
