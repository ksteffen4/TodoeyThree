//
//  ViewController.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/9/22.
//

import UIKit

class TodoListController: UITableViewController {

    let defaults = UserDefaults.standard

    var todoList: [TodoListItem] = [
        TodoListItem("Buy Eggos", false),
        TodoListItem("Slay Dragon", true),
        TodoListItem("Drive Car", false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        loadListData()
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
        let row = indexPath.row
        todoList[row].isChecked.toggle()
        saveListData()
    }
  
    //MARK: - Add Item button pressed method
    
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Task", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let text = alert.textFields?.first?.text, text != "" {
                let item = TodoListItem(text, false)
                self.todoList.append(item)
                self.saveListData()
            }
        }
        alert.addAction(action)
        
        alert.addTextField { textField in
            textField.placeholder = "Create new task"
            
        }
        present(alert, animated: true, completion: nil)
    }
    


    //MARK: - Database reads and writes

    
    func loadListData() {
        if let strings = defaults.array(forKey: "todoListStrings") as? [String],
           let bools = defaults.array(forKey: "todoListBools") as? [Bool] {
            todoList = []
            for index in 0..<(strings.count) {
                todoList.append(TodoListItem(strings[index], bools[index]))
            }
        } else {
            print("Load from defaults failed")
        }
    }
    
    func saveListData() {
        let strings = todoList.map { $0.task}
        let bools = todoList.map { $0.isChecked}
        defaults.set(strings, forKey: "todoListStrings")
        defaults.set(bools, forKey: "todoListBools")
        tableView.reloadData()
    }
}

