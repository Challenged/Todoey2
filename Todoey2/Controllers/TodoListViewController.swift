//
//  ViewController.swift
//  Todoey2
//
//  Created by Rustam on 5/15/19.
//  Copyright © 2019 Rustam Duspayev. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()   //["Find Mike", "Buy Eggs", "Destroy Demogorgon"]

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)

        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)

        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
            }
        }


    //MARK - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)

//         could also use (to create new cell(s) each time we display them, as opposed to dequeuing and reusing, disappearing cells will be distroyed, and to reappear when scroll back, a new cell will be created):
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")

        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title

        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse

        cell.accessoryType = item.done ? .checkmark : .none

//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }

        return cell
    }

    //MARK - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true) // making gray highlight go away after ~1 sec

        //adding or removing checkmarks on the items ==> commented code ported to TableView Datasource Method "cellForRowAt" with modifications to include the Item class

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        tableView.reloadData()

//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
    }

    //MARK - Add New Items Button

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen upon "Add Item" pressed
            print("Success \(textField.text ?? "XX")")

            let newItem = Item()
            if let newItemText = textField.text {
                newItem.title = newItemText
                self.itemArray.append(newItem)
            }

//            if let newItem = textField.text {
//                self.itemArray.append(newItem)
//            }
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
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

