//
//  BulettinTableViewController.swift
//  BulletinDVM
//
//  Created by Adam on 11/06/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit

class BulettinTableViewController: UITableViewController {

    // MARK: - Properties
    @IBOutlet weak var bulletinMessageTextField: UITextField!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BulletinController.shared.fetchBulletins { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    // MARK: - Actions

    @IBAction func PostBtnTapped(_ sender: UIButton) {
        guard let messageText = bulletinMessageTextField.text else { return }
        guard !messageText.isEmpty else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        BulletinController.shared.createBulletin(with: messageText) { (success) in
            if success {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                    self.bulletinMessageTextField.text = ""
                    self.bulletinMessageTextField.resignFirstResponder()
                }
                } else {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.bulletinMessageTextField.text = ""
                        self.bulletinMessageTextField.resignFirstResponder()
                }
            }
        }
    }
    // MARK: - TableViewDelegate and Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BulletinController.shared.bulletins.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bullettinCell", for: indexPath)
        
        let bulletin = BulletinController.shared.bulletins[indexPath.row]
        cell.textLabel?.text = bulletin.message
        cell.detailTextLabel?.text = dateFormatter.string(from: bulletin.timestamp)

        return cell
    }
}
