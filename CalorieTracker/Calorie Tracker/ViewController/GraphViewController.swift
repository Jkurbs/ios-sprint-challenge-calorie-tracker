//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Kerby Jean on 3/27/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import UIKit
import SwiftChart

class GraphViewController: UIViewController {
    
    var tableView: UITableView!
    
    var calories = [Calorie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Functions
    
    func setupViews() {
        self.view.backgroundColor = .white
        self.title = "Calorie Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCalorie))
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(GraphCell.self, forCellReuseIdentifier: GraphCell.id)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    @objc func addCalorie() {
        let alert = UIAlertController(title: "Add Calorie", message: nil, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.keyboardType = .numberPad
            newTextField.placeholder = "Add calorie"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in  })
        alert.addAction(UIAlertAction(title: "Add", style: .default) { action in
            if let textFields = alert.textFields, let textField = textFields.first, let result = textField.text, let value = Double(result) {
                let calorie = Calorie(value: value)
                self.calories.append(calorie)
                NotificationCenter.default.post(name: .graphValue, object: nil, userInfo: ["calories": self.calories])
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
}

extension GraphViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return calories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GraphCell.id, for: indexPath) as? GraphCell else { fatalError() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { fatalError() }
            let calorie = calories[indexPath.row]
            cell.textLabel?.text = "Calories \(calorie.value) \(calorie.date)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return view.frame.height/3
        }
        
        return 60.0
    }
}

