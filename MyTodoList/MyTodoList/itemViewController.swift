//
//  itemViewController.swift
//  MyTodoList
//
//  Created by nju on 2021/10/16.
//

import UIKit

protocol AddItemDelegate{
    func addItem(item: todoItem)
}
protocol EditItemDelegate{
    func editItem(newItem:todoItem, itemIndex:Int)
}

class itemViewController: UIViewController {

    @IBOutlet weak var Cardview: UIView!
    @IBOutlet weak var cancelBUtton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var theTitle: UITextField!
    @IBOutlet weak var isChecked: UISwitch!
    
    var addItemDelegate: AddItemDelegate?
    var editItemDelegate: EditItemDelegate?
    var itemToEdit: todoItem?
    var itemIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let blur = UIBlurEffect(style: .light)
//        let blurView = UIVisualEffectView(effect: blur)
//        blurView.frame = CGRect(x:0, y:0,width:428,height:838)
//        blurView.layer.cornerRadius = 30
        
//        blurView.layer.masksToBounds = true
//        super.view.addSubview(blurView)
//        //self.view.addSubview(blurView)
        // Do any additional setup after loading the view.
        Cardview.layer.cornerRadius = 25
        Cardview.layer.masksToBounds = true
        doneButton.isEnabled = false
        isChecked.isOn = false
        
        if itemToEdit != nil{
            doneButton.isEnabled = true
            self.theTitle.text = itemToEdit!.title
            self.isChecked.isOn = itemToEdit!.is_Checked
        }
    }
    
    @IBAction func cancel_dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done_dismiss(_ sender: Any) {
        
        if itemToEdit == nil{
            self.addItemDelegate?.addItem(item: todoItem(title: theTitle.text!, is_Checked: isChecked.isOn))
        }else{
            self.editItemDelegate?.editItem(newItem: todoItem(title: theTitle.text!, is_Checked:isChecked.isOn), itemIndex: self.itemIndex)
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension itemViewController:UITextFieldDelegate{
    func textField(_ textField:UITextField, shouldChangeCharactersIn range:NSRange, replacementString string:String) -> Bool{
        let oldText = textField.text!
        let stringRange = Range(range , in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
}
