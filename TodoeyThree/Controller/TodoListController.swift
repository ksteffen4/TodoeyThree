//
//  ViewController.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/9/22.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListController: SwipeTableViewController {

    let realm = try! Realm()
    var todoList: Results<Item>?
    
    var category: Category? {
        didSet {
            loadListData()
        }
    }
    
    var categoryViewControler: CategoryViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentCategory = category {
            navigationItem.title = currentCategory.name
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let controller = categoryViewControler {
            controller.setNavBar()
        }
        super.viewWillDisappear(animated)
    }
    
    
    //MARK: - TableViewDataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoList?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            let category = item.parentCategory.first!
            let baseColor = UIColor(hexString: category.color)!
            let percent = 0.5 * Double(indexPath.row)/Double(todoList!.count)
            let bgColor = baseColor.darken(byPercentage: percent)!
            let textColor = ContrastColorOf(bgColor, returnFlat: true)
            cell.backgroundColor = bgColor
            cell.textLabel?.textColor = textColor
        } else {
            cell.textLabel?.text = "Empty list entry"
            cell.accessoryType = .none
        }
        return cell
    }
    
    //MARK: - TableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let item = todoList?[row] {
            do {
                try realm.write {
                    item.done.toggle()
                }
            } catch {
                print("Error modifying item data \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
  
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Task", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let text = alert.textFields?.first?.text, text != "" {
                if let currentCategory = self.category {
                    do {
                        try self.realm.write {
                            let item = Item()
                            item.title = text
                            item.date = Date().description
                            currentCategory.items.append(item)
                        }
                    } catch {
                        print("Error saving item data:")
                    }
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { textField in
            textField.placeholder = "Create new task"
            
        }
        present(alert, animated: true, completion: nil)
    }
    

    //MARK: - Database reads and writes

    func loadListData(searchText: String? = nil) {
        todoList = category?.items
            .sorted(byKeyPath: "date", ascending: true)
        if let text = searchText {
            todoList = todoList?.filter("title CONTAINS[cd] %@", text)
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        let index = indexPath.row
        if let item = todoList?[index] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item from todoList: \(error)")
            }
        }
    }
}
//MARK: - UISearchBarDelegate methods
    
extension TodoListController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text != "" {
            loadListData(searchText: text)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadListData()
        }
    }
    
}
