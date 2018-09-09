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
    }

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        switch (authDataResult, error) {
        case (.some(let result), .none):
            let db = Firestore.firestore()
            db.collection("Donors").document(result.user.uid).setData([
                "name": result.user.displayName ?? ""
            ])

            let homeViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "tabs")
            present(homeViewController, animated: true)

        case (_, .some(let error)):
            guard (error as NSError).code != 1 else {
                return
            }

            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)

        default: break
        }
    }
}
