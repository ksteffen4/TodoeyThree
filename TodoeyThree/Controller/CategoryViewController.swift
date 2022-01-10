//
//  CategoryViewController.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/10/22.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    // CoreData context
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
//MARK: - Add Category button method
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            if let text = alert.textFields?.first?.text, text != "" {
                let category = Category()
                category.name = text
                self.save(category: category)
            }
        }
        alert.addAction(action)
        
        alert.addTextField { textField in
            textField.placeholder = "Create new category"
            
        }
        present(alert, animated: true, completion: nil)

    }
    
    //MARK: - TableView delegate method for row selected
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TodoListSegue", sender: self)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.category = categories?[indexPath.row] ?? nil
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
//MARK: - Data management
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category data: \(error)")
        }
        loadCategories()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()

        
    }

}
