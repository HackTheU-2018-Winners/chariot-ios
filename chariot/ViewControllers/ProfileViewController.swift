//
//  ProfileViewController.swift
//  chariot
//
//  Created by Bradley Walters on 9/9/18.
//  Copyright © 2018 Chariot App. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = 64
        profileImageView.clipsToBounds = true
    }
}
