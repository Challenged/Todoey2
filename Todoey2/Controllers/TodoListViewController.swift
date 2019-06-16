//
//  ViewController.swift
//  Todoey2
//
//  Created by Rustam on 5/15/19.
//  Copyright © 2019 Rustam Duspayev. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    var todoItems: Results<Item>?   //["Find Mike", "Buy Eggs", "Destroy Demogorgon"]

    var selectedCategory: Category? {
        didSet {
//            loadItems()
        }
    }

//    let defaults = UserDefaults.standard

//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggs"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)

//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//            }

        loadItems()

//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        }


    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

//         could also use (to create new cell(s) each time we display them, as opposed to dequeuing and reusing, disappearing cells will be distroyed, and to reappear when scroll back, a new cell will be created):
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")

        if let item = todoItems?[indexPath.row] {

        cell.textLabel?.text = item.title

        //Ternary operator ==>
        //value = condition (a logical statement OR boolean) ? valueIfTrue : valueIfFalse

        cell.accessoryType = item.done ? .checkmark : .none

//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }

        return cell
    }

    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true) // making gray highlight go away after ~1 sec

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
    }

    //MARK: - Add New Items Button

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen upon "Add Item" pressed
            print("Success \(textField.text ?? "XX")")

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        if let newItemText = textField.text {
                            newItem.title = newItemText
                            currentCategory.items.append(newItem)
                        }
                    }
                } catch {
                    print("Error saving todo item \(error)")
                }
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

    //MARK: - Model Manipulation Methods
//    func saveItems() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
//
////        let encoder = PropertyListEncoder()
////
////        do {
////            let data = try encoder.encode(itemArray)
////            try data.write(to: dataFilePath!)
////        } catch {
////            print("Error encoding Item array \(error)")
////        }
//        tableView.reloadData()
//    }

    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    // Mark: - Delete Data from SwipeCell

    override func updateModel(at indexPath: IndexPath) {
        if let item2Delete = selectedCategory?.items[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item2Delete)
                }
            } catch {
                print("Error deleting todo item \(error)")
            }
        }
    }

}

// MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems!.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        print(searchBar.text!)
//
//        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: searchPredicate)

        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

