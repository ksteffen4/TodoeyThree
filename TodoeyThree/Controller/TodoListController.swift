//
//  ViewController.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/9/22.
//

import UIKit

class TodoListController: UITableViewController {
    
    var todoList: [TodoListItem] = [
        TodoListItem("Buy Eggos", false),
        TodoListItem("Slay Dragon", true),
        TodoListItem("Drive Car", false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - TableViewDataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row].task
        cell.accessoryType = todoList[indexPath.row].isChecked ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\"\(todoList[indexPath.row].task)\" selected")
        let row = indexPath.row
        todoList[row].isChecked.toggle()
        tableView.cellForRow(at: indexPath)?.accessoryType = todoList[row].isChecked ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
    //MARK: - Add Item button pressed method
    
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Task", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            print("Done")
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    


    //MARK: - Database reads and writes

    
    func loadListData() {
        
    }
    
    func saveListData() {
        
    }
}

