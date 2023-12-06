//
//  manageCateViewController.swift
//  EmptyApp
//
//  Created by ZYY on 11/8/23.
//  Copyright © 2023 rab. All rights reserved.
//

import UIKit
import CoreData

class manageCateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addBtn: UIBarButtonItem!
            
    @IBOutlet var subView: UIView!
        
    @IBOutlet var editView: UIView!
    
    @IBOutlet weak var addCancelBtn: UIBarButtonItem!
    
    @IBOutlet weak var cateIdText: UITextField!
    
    @IBOutlet weak var cateIdText2: UITextField!
    @IBOutlet weak var cateNameText: UITextField!
    @IBOutlet weak var cateNameText2: UITextField!
    @IBOutlet weak var selectCancel: UIBarButtonItem!
    
    @IBOutlet weak var viewTable: UITableView!
    
    /* Coredata Operations */
    var managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var selectCate: Categories? = nil
    var cateModel = [Categories]()
    var courseModel = [Courses]()
    
    func loadDataByCoredata() {
        let fetchColleges: NSFetchRequest<Categories> = Categories.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchColleges.sortDescriptors = [sortDescriptor]
        do {
            self.cateModel = try (self.managedContext.fetch(fetchColleges)) as [Categories]
        } catch {
            fatalError("Fail to load college data! \(error)")
        }
    }
    
    func checkDuplicate(_ id: Int) -> Bool {
        self.cateModel = Utils.loadCategoryDataByCoredata()
        return cateModel.contains{ $0.id == id }
    }
    
    func populateTable() {
        self.cateModel = Utils.loadCategoryDataByCoredata()
        viewTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cateModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "1", for: indexPath)
        let name = cateModel[indexPath.row]
        cell.textLabel?.text = "ID:\(name.id) | \(name.name ?? "No name")"
        return cell
    }
    
    /* Update item */
    @IBAction func updateCancel(_ sender: Any) {
        editView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCate = cateModel[indexPath.row]
        cateIdText2.text = String(self.selectCate!.id)
        cateNameText2.text = self.selectCate?.name
        
        editView.layer.shadowColor = UIColor.black.cgColor
        editView.layer.shadowOpacity = 0.5
        editView.layer.shadowOffset = CGSize(width: 0, height: 2)
        editView.layer.shadowRadius = 4
        view.addSubview(editView)
    }
    
    @IBAction func updateItem(_ sender: Any) {
        if cateIdText2.text == "" {
            popAlert("Alert", "Category ID can not be nil")
            return
        }
        
        var catId: Int = Int.max
        if let input_int = Int(cateIdText2.text!){
            catId = input_int
        }else {
            popAlert("Alert", "Not a valid integer")
            return
        }
        
        if self.selectCate?.id != Int16(catId) {
            popAlert("Alert", "Category ID can not be changed")
            return
        }
        
        if cateNameText2.text == "" {
            popAlert("Alert", "Category name can not be nil")
            return
        }
        
        do {
            self.selectCate?.name = cateNameText2.text!
            try managedContext.save()
            
        } catch {
            print("Error updating entity: \(error)")
        }
        
        popAlert("Info", "Course Category is edited successfully")
        editView.removeFromSuperview()
        cateIdText.text = ""
        cateNameText.text = ""
        populateTable()
    }
    
    /* Add item */
    @IBAction func addCancel(_ sender: Any) {
        cateIdText.text = ""
        cateNameText.text = ""
        subView.removeFromSuperview()
    }
    
    @IBAction func addCategory(_ sender: Any) {
        cateIdText.text = ""
        cateNameText.text = ""
        subView.layer.shadowColor = UIColor.black.cgColor
        subView.layer.shadowOpacity = 0.5
        subView.layer.shadowOffset = CGSize(width: 0, height: 2)
        subView.layer.shadowRadius = 4
        view.addSubview(subView)
    }
    
    @IBAction func confirmAdd(_ sender: Any) {
        if cateIdText.text == "" {
            popAlert("Alert", "Category ID can not be nil")
            return
        }
        
        var id: Int = Int.max
        if let input_int = Int(cateIdText.text!){
            id = input_int
        } else {
            popAlert("Alert", "Not a valid integer.")
            return
        }
        
        if checkDuplicate(id) == true {
            popAlert("Alert", "Category ID exists!")
            return
        }
        
        if cateNameText.text == "" {
            popAlert("Alert", "Category name can not be nil")
            return
        }

        if let new_cat = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: managedContext) as? Categories {
            new_cat.name = cateNameText.text
            new_cat.id = Int16(id)
            do {
                try managedContext.save()
            } catch {
                fatalError("Add failed \(error)")
            }
        }
        
        popAlert("Info", "New Category is added")
        subView.removeFromSuperview()
        cateIdText.text = ""
        cateNameText.text = ""
        populateTable()
    }
    
    func popAlert(_ title: String, _ msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTable.delegate = self
        viewTable.delegate = self
        viewTable.dataSource = self
        viewTable.register(UITableViewCell.self, forCellReuseIdentifier: "1")
        
        cateIdText.keyboardType = .numberPad
        cateIdText2.isUserInteractionEnabled = false
        populateTable()
        // Do any additional setup after loading the view.
    }

    /* Delete item */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteConfirmationAlert(indexPath: indexPath)
        }
    }
    
    func showDeleteConfirmationAlert(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteItem(at: indexPath)
        }

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        selectCate = cateModel[indexPath.row]
        self.courseModel = Utils.loadCourseDataByCoredata()
        if courseModel.contains(where: {$0.course_category_id == selectCate?.id}) {
            popAlert("Error", "Category can not be deleted because it contains course")
            return
        }
        do {
            managedContext.delete(self.selectCate!)
            try self.managedContext.save()
        } catch {
            fatalError("Delete failed. Error: \(error)")
        }
        populateTable()
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
