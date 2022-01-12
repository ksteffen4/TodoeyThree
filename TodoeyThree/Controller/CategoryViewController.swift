//
//  CategoryViewController.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/10/22.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    // CoreData context
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    func setNavBar() {
        navigationController?.navigationBar.backgroundColor = .systemBlue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
        setNavBar()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row] ?? Category()
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        let bgHex = category.color
        let bgColor = UIColor(hexString: bgHex)!
        let fgColor = ContrastColorOf(bgColor, returnFlat: true)
        cell.backgroundColor = bgColor
        cell.textLabel?.textColor = fgColor
        setNavBar()
        return cell
    }
    
//MARK: - Add Category button method
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            if let text = alert.textFields?.first?.text, text != "" {
                let category = Category()
                category.name = text
                category.color = UIColor.randomFlat().hexValue()
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
        destinationVC.categoryViewControler = self
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.category = categories?[indexPath.row] ?? nil
            tableView.deselectRow(at: indexPath, animated: true)
            let color = UIColor(hexString: destinationVC.category!.color)!
            if let navBar = navigationController?.navigationBar {
                navBar.backgroundColor = color
                let contrast = ContrastColorOf(color, returnFlat: true)
                navBar.tintColor = contrast
                navBar.titleTextAttributes = [.foregroundColor: contrast]
                navBar.largeTitleTextAttributes = [.foregroundColor: contrast]
            }
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
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath) // doesn't really do anything now

        if let category = self.categories?[indexPath.row] {
            let items = category.items
            do {
                try self.realm.write {
                    for item in items {
                        self.realm.delete(item)
                    }
                    self.realm.delete(category)
                }
            } catch {
                print("Error deleting category from realm: \(error)")
            }
        }
    }

}

