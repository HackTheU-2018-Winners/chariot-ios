//
//  LoginViewController.swift
//  chariot
//
//  Created by Bradley Walters on 9/8/18.
//  Copyright © 2018 Chariot App. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI

class LoginViewController: UIViewController, FUIAuthDelegate {

    @IBAction func loginTapped(_ sender: Any) {
        let authUI = FUIAuth.defaultAuthUI()!
        authUI.delegate = self
        authUI.providers = [FUIGoogleAuth()]
        present(authUI.authViewController(), animated: true)

        let homeViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "home")
        navigationController?.setViewControllers([homeViewController], animated: true)
    }

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        switch (authDataResult, error) {
        case (.some(let result), .none):
            let db = Firestore.firestore()
            db.collection("Donors").document(result.user.uid).setData([
                "name": result.user.displayName ?? ""
            ])

        case (_, .some(let error)):
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)

        default: break
        }
    }
}
