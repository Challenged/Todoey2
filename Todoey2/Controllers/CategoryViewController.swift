//
//  CategoryViewController.swift
//  Todoey2
//
//  Created by Rustam on 5/26/19.
//  Copyright © 2019 Rustam Duspayev. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    var categories: Results<Category>?

    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

//        let newCategory = Category()
//        newCategory.name = "Generic"
//        categoryArray.append(newCategory)
//
//        let newCategory2 = Category()
//        newCategory2.name = "Work"
//        categoryArray.append(newCategory2)
//
//        let newCategory3 = Category()
//        newCategory3.name = "NewSkills"
//        categoryArray.append(newCategory3)
//
//        let newCategory4 = Category()
//        newCategory4.name = "Grocery"
//        categoryArray.append(newCategory4)

        loadCategories()

            }


    // MARK: - Table view data source methods

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }

    // MARK: - Table view delegate methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added Yet"

        guard let categoryColor = UIColor(hexString: categories?[indexPath.row].color ?? FlatWhite().hexValue()) else { fatalError() }

        cell.backgroundColor = categoryColor

        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Data manipulation methods

    func loadCategories () {
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }

    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error adding category to Realm \(error)")
        }
        tableView.reloadData()
    }

    // MARK: - Add new category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("Success ", textField.text!)

            let newCategory = Category()

            if let newCategoryName = textField.text {
                newCategory.name = newCategoryName
                newCategory.color = RandomFlatColor().hexValue()
            }
             self.save(category: newCategory)

        }

//        let action2 = UIAlertAction(title: "Ok", style: .default) { _ in
//            NSLog("The \"OK\" alert occured.")
//        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            print(alertTextField.text!)
            textField = alertTextField
        }
        alert.addAction(action)
//        alert.addAction(action2)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Delete Data from SwipeCell
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let category2Delete = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(category2Delete)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }

    }
    
}
