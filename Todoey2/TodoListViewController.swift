//
//  ViewController.swift
//  Todoey2
//
//  Created by Rustam on 5/15/19.
//  Copyright © 2019 Rustam Duspayev. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    //MARK - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
//        could also use:
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    //MARK - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true) // making gray highlight go away after ~1 sec

        //adding or removing checkmarks on the items
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }

    //MARK - Add New Items Button

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen upon "Add Item" pressed
            print("Success \(textField.text ?? "XX")")
            if let newItem = textField.text {
                self.itemArray.append(newItem)
            }
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            print(alertTextField.text!)
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

