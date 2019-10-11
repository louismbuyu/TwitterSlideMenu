//
//  MenuTVC.swift
//  TwitterMenu
//
//  Created by Louis Nelson Levoride on 10.10.19.
//  Copyright © 2019 LouisNelson. All rights reserved.
//

import UIKit

class MenuTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Menu Item \(indexPath.row)"
        return cell
    }
}
