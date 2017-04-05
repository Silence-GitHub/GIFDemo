//
//  TableViewController.swift
//  GIFDemo
//
//  Created by Kaibo Lu on 2017/4/5.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    private var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Default"
        
        rightButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 70, height: 22)))
        rightButton.setTitleColor(navigationController?.navigationBar.tintColor, for: .normal)
        rightButton.titleLabel?.textAlignment = .right
        rightButton.setTitle("Change", for: .normal)
        rightButton.addTarget(self, action: #selector(rightButonClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)

        tableView.register(GIFCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = GIFCell.cellHeight
    }
    
    @objc private func rightButonClicked() {
        rightButton.isSelected = !rightButton.isSelected
        title = rightButton.isSelected ? "Async" : "Default"
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GIFCell
        let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif")
        if rightButton.isSelected {
            cell.gifView.setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Loading"))
        } else {
            cell.gifView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Loading"))
        }
        return cell
    }

}
