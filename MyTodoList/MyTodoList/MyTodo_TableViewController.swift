//
//  MyTodo_TableViewController.swift
//  MyTodoList
//
//  Created by nju on 2021/10/16.
//

import UIKit

class MyTodo_TableViewController: UITableViewController {
    
    var items:[todoItem] = [
        //todoItem(title: "HomeWork", is_Checked: false),
        //todoItem(title: "Play Games", is_Checked: true)
    ]
    
    private func handleMoveToTrash(_ indexPath: IndexPath) {
            print("Moved to trash")
        items.remove(at: indexPath.section)
        self.tableView.deleteSections([indexPath.section], with: .fade)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.prefersLargeTitles = true
        loadItems()
        self.tableView.delegate = self
        //self.tableView.isEditing = true
    }

    // MARK: - Table view data source
    
    //处理表Cell格式----------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    //----------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! MyTodo_TableViewCell
        let item = items[indexPath.section]
        
        let richString1 = NSMutableAttributedString.init(string: item.title)
                richString1.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: richString1.length))
        
        //cell.title.text! = item.title
        //cell.status.text! = item.is_Checked ? "✅":"☑️"
        cell.status.text! = item.is_Checked ? "✔︎":"❏"
        cell.status.textColor = item.is_Checked ? UIColor .systemGreen: UIColor .systemRed
       
        if item.is_Checked{
            cell.title.attributedText = richString1
            cell.backgroundColor = UIColor .systemGray
        }
        else{
            cell.title.attributedText = nil
            cell.title.text = item.title
            cell.backgroundColor = UIColor .white
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "delete") { [weak self] (action, view, completionHandler) in
                                            self?.handleMoveToTrash(indexPath)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Archive action

        // Trash action
        let trash = UIContextualAction(style: .destructive,
                                       title: "delete") { [weak self] (action, view, completionHandler) in
                                        self?.handleMoveToTrash(indexPath)
                                        completionHandler(true)
        }
        trash.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [trash])
//        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row, and instead, show the state with a checkmark.
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let cell = (tableView.cellForRow(at: indexPath) as? MyTodo_TableViewCell) else { return }
        
        let richString1 = NSMutableAttributedString.init(string: cell.title.text!)
                richString1.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: richString1.length))
//        let richString2 = NSMutableAttributedString.init(string: cell.title.text!)
//                richString2.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 0), range: NSRange(location: 0, length: richString2.length))
        
        // Update the selected item to indicate whether the user packed it or not.
        let item = items[indexPath.section]
        let newItem = todoItem(title: item.title, is_Checked: !item.is_Checked)
        items.remove(at: indexPath.section)
        items.insert(newItem, at: indexPath.section)
 
        // Show a check mark next to packed items.
        //cell.title.text = item.title
        if newItem.is_Checked {
            cell.status.text! = "✔︎"
            cell.status.textColor = UIColor .systemGreen
            cell.title.attributedText = richString1
            cell.backgroundColor = UIColor .systemGray
        } else {
            cell.status.text! = "❏"
            cell.status.textColor = UIColor .systemRed
            cell.title.attributedText = nil
            cell.title.text = item.title
            cell.backgroundColor = UIColor .white
        }
        
        
//        if let viewController = storyboard?.instantiateViewController(identifier: "output") as? itemViewController {
//            navigationController?.pushViewController(viewController, animated: true)
//        }

    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            items.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .fade)
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let sourceItem = items[fromIndexPath.section];
        //let destinationItem = items[to.section];
    
        if fromIndexPath.section < to.section {
            items.insert(sourceItem, at: to.section + 1)
            items.remove(at: fromIndexPath.section)
        }else if fromIndexPath.section > to.section{
            items.remove(at: fromIndexPath.section)
            items.insert(sourceItem, at: to.section)
        }
        tableView.reloadData()
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    @IBAction func rerangeCell(_ sender: Any) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if self.tableView.isEditing == false{
            if segue.identifier == "addItem" {
                let addItemViewController = segue.destination as! itemViewController
                addItemViewController.addItemDelegate = self
            }else if segue.identifier == "editItem"{
                let editItemViewController = segue.destination as! itemViewController
                let cell = sender as! MyTodo_TableViewCell
                var IfChecked: Bool
                if cell.status.text! == "✔︎"{
                    IfChecked = true
                }
                else{
                    IfChecked = false
                }
                let item =
                todoItem(title: cell.title.text!, is_Checked: IfChecked)
                editItemViewController.itemToEdit = item
                editItemViewController.itemIndex = tableView.indexPath(for: cell)!.section
                editItemViewController.editItemDelegate = self
            }
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if self.tableView.isEditing == true && identifier == "editItem"{
            return false
        }
        return true
    }
    
    func checklive(_ newItem: todoItem,_ itemindex:Int) -> Bool{
        for index in 0..<items.count{
            if newItem.title == items[index].title{
                items[index].is_Checked = newItem.is_Checked
                if(itemindex == index){return true}
                return false
            }
        }
        return true
    }
}

//extension MyTodo_TableViewController: UITableViewDelegate {
//
//
//}

extension MyTodo_TableViewController: AddItemDelegate{
    func addItem(item: todoItem){
        if checklive(item,-1){
            self.items.append(item)
        }
        self.tableView.reloadData()
    }
}

extension MyTodo_TableViewController: EditItemDelegate{
    func editItem(newItem: todoItem, itemIndex: Int) {
        if checklive(newItem,itemIndex){ self.items[itemIndex] = newItem}
        else{ self.items.remove(at: itemIndex)}
        self.tableView.reloadData()
    }
}
extension MyTodo_TableViewController{
    func dataFilePath()->URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return path!.appendingPathComponent("TodoItem.json")
    }
    func saveAllItems(){
        do{
            let data = try JSONEncoder().encode(items)
            try data.write(to: dataFilePath(),options: .atomic)
        }catch{
            print("Can not save: \(error.localizedDescription)")
        }
    }
    func loadItems(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            do{
                items = try JSONDecoder().decode([todoItem].self, from: data)
            }catch{
                print("Can not load: \(error.localizedDescription)")
            }
        }
    }
}
