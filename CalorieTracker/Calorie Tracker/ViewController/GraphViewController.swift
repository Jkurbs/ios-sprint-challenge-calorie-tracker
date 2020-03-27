//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Kerby Jean on 3/27/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart
import SCLAlertView

class GraphViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
    var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var graphView = GraphView()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Functions
    
    func setupViews() {
        self.view.backgroundColor = .white
        self.title = "Calorie Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCalorie))
        navigationController?.navigationBar.tintColor = .systemGreen
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: .calorieCellId)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        view.addSubview(graphView)
        
        NSLayoutConstraint.activate([
            
            graphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            graphView.widthAnchor.constraint(equalTo: view.widthAnchor),
            graphView.heightAnchor.constraint(equalToConstant: view.frame.height / 3),
            
            tableView.topAnchor.constraint(equalTo: graphView.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        updateGraph()
    }
    
    @objc func addCalorie() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: false,
            shouldAutoDismiss: true,
            contentViewColor: UIColor(white: 0.8, alpha: 1.0),
            titleColor: .darkGray
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.iconTintColor = view.tintColor
        let textField = alert.addTextField("Enter your name")
        textField.tintColor = .systemGreen
        alert.addButton("Add", backgroundColor: .systemGreen) {
            if let result = textField.text, let value = Double(result) {
                Calorie(value: value)
                do {
                    try? CoreDataStack.shared.save()
                }
                self.updateGraph()
            }
        }
        alert.addButton("Cancel", backgroundColor: .systemGray) {
            alert.dismiss(animated: true, completion: nil)
        }
        alert.showTitle("Add Calorie", subTitle: "", style: .edit)
    }
    
    func updateGraph() {
        if let calories = self.fetchedResultsController.fetchedObjects {
            NotificationCenter.default.post(name: .graphValue, object: nil, userInfo: ["calories": calories])
        }
    }
}

// MARK: - UITableViewDelegate/UITableViewDataSource

extension GraphViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .calorieCellId) else { fatalError() }
        let calorie = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "Calories: \(calorie.value) \(calorie.date ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension GraphViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
