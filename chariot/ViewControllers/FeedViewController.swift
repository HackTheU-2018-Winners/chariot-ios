//
//  FeedViewController.swift
//  chariot
//
//  Created by Jared Amen on 9/9/18.
//  Copyright © 2018 Chariot App. All rights reserved.
//

import UIKit
import Firebase

class FeedEvent {
    enum EventType {
        case newOrganization
        case organizationUpdate
        case newCampaign
        case organizationMessage
        case newBin

        init?(string: String) {
            switch string {
            case "new_org":
                self = .newOrganization
            case "org_update":
                self = .organizationUpdate
            case "new_campaign":
                self = .newCampaign
            case "org_message":
                self = .organizationMessage
            case "new_bin":
                self = .newBin
            default: return nil
            }
        }
    }

    enum EventIcon: String {
        case bin
        case house
        case food
        case asuu

        var image: UIImage {
            switch self {
            case .bin:
                return UIImage(named: "binIcon")!
            case .house:
                return UIImage(named: "iconTabBarDonate")!
            case .food:
                return UIImage(named: "iconTabBarDonate")!
            case .asuu:
                return UIImage(named: "iconTabBarDonate")!
            }
        }
    }

    let type: EventType
    let icon: EventIcon
    let message: String
    let date: Date = Date()

    init(document: QueryDocumentSnapshot) {
        type = EventType(string: document.data()["type"] as! String)!
        icon = EventIcon(rawValue: document.data()["icon"] as! String)!
        message = document.data()["message"] as! String
//        date = (document.get("created_at") as! Timestamp).dateValue()
    }
}

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    func populate(with event: FeedEvent) {
        iconImageView.image = event.icon.image
        messageLabel.text = event.message
        dateLabel.text = FeedTableViewCell.dateFormatter.string(from: event.date)
    }
}

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    private var events: [FeedEvent] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 84

        Firestore.firestore().collection("Events").addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("event snapshot error \(String(describing: error))")
                return
            }

            self?.events = self?.events(from: snapshot) ?? []
            self?.tableView.reloadData()
        }
    }

    private func events(from snapshot: QuerySnapshot) -> [FeedEvent] {
        return snapshot.documents.map(FeedEvent.init(document:))
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FeedTableViewCell

        let event = events[indexPath.row]

        cell.populate(with: event)

        return cell
    }
}
