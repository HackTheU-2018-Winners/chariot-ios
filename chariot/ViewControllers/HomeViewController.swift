//
//  HomeViewController.swift
//  chariot
//
//  Created by Bradley Walters on 9/8/18.
//  Copyright © 2018 Chariot App. All rights reserved.
//

import Firebase
import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private var snapshot: QuerySnapshot?

    override func viewDidLoad() {
        welcomeLabel.text = "Welcome, \(Auth.auth().currentUser!.displayName!)"

        tableView.delegate = self
        tableView.dataSource = self

        let db = Firestore.firestore()
        db.collection("Charities").addSnapshotListener { [weak self] snapshot, error in
            self?.snapshot = snapshot
            self?.tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapshot?.documents.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!

        let document = self.snapshot!.documents[indexPath.row]
        cell.textLabel?.text = document.data()["Name"] as? String
        return cell
    }
}
