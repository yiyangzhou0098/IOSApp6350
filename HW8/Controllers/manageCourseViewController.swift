//
//  manageCourseViewController.swift
//  EmptyApp
//
//  Created by ZYY on 11/8/23.
//  Copyright © 2023 rab. All rights reserved.
//

import UIKit
import CoreData

class manageCourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
            
    @IBOutlet var subView: UIView!
        
    @IBOutlet var editView: UIView!
    
    @IBOutlet weak var addCancelBtn: UIBarButtonItem!
    
    @IBOutlet weak var collegeIdText: UITextField!
    
    @IBOutlet weak var courseNameText: UITextField!
    
    @IBOutlet weak var programIdText: UITextField!
            
    @IBOutlet weak var selectCancel: UIBarButtonItem!
    
    @IBOutlet weak var courseIdText: UITextField!
    
    @IBOutlet var updateBar: UIToolbar!
    
    @IBOutlet var addBar: UIToolbar!
    
    @IBOutlet weak var cateIdText: UITextField!
    
    @IBOutlet weak var courseIdText2: UITextField!
    
    @IBOutlet weak var courseNameText2: UITextField!

    @IBOutlet weak var collegeIdText2: UITextField!
    @IBOutlet weak var cateIdText2: UITextField!
    @IBOutlet weak var programIdText2: UITextField!
    @IBOutlet weak var viewTable: UITableView!
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courseModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "1", for: indexPath)
        let item = courseModel[indexPath.row]
        cell.textLabel?.text = "ID:\(item.id) | \(item.name ?? "No name") | College ID: \(item.college_id) | Program ID: \(item.program_id) | Category ID: \(item.course_category_id)"
        return cell
    }
    
    /* Coredata Operations */
    var managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var selectProgram: Programs? = nil
    var selectCollege: Colleges? = nil
    var selectCourse: Courses? = nil
    var programModel = [Programs]()
    var collegeModel = [Colleges]()
    var courseModel = [Courses]()
    var cateModel = [Categories]()
    
    func checkDuplicate(_ id: Int) -> Bool {
        self.courseModel = Utils.loadCourseDataByCoredata()
        return courseModel.contains{ $0.id == id }
    }
    
    func populateTable() {
        self.courseModel = Utils.loadCourseDataByCoredata()
        viewTable.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewTable.delegate = self
        viewTable.delegate = self
        viewTable.dataSource = self
        viewTable.register(UITableViewCell.self, forCellReuseIdentifier: "1")
        populateTable()

        programIdText.keyboardType = .numberPad
        collegeIdText.keyboardType = .numberPad
        courseIdText.keyboardType = .numberPad
        cateIdText.keyboardType = .numberPad

        cateIdText2.keyboardType = .numberPad
        programIdText2.isUserInteractionEnabled = false
        courseIdText2.isUserInteractionEnabled = false
        collegeIdText2.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }

    /* Update item */
    @IBAction func updateCancel(_ sender: Any) {
        editView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectCourse = courseModel[indexPath.row]
            programIdText2.text = String(self.selectCourse!.id)
            courseNameText2.text = self.selectCourse?.name
            collegeIdText2.text = String(self.selectCourse!.college_id)
            courseIdText2.text = String(self.selectCourse!.college_id)
            cateIdText2.text = String(self.selectCourse!.course_category_id)

            editView.layer.shadowColor = UIColor.black.cgColor
            editView.layer.shadowOpacity = 0.5
            editView.layer.shadowOffset = CGSize(width: 0, height: 2)
            editView.layer.shadowRadius = 4
            view.addSubview(editView)
        }
    
    @IBAction func updateItem(_ sender: Any) {
        if courseIdText.text == "" {
            popAlert("Alert", "Course ID can not be nil")
            return
        }
        
        var couId: Int = Int.max
        if let input_int = Int(courseIdText.text!){
            couId = input_int
        }else {
            popAlert("Alert", "Not a valid integer")
            return
        }
        
        if self.selectCourse?.id != Int16(couId) {
            popAlert("Alert", "Course ID can not be changed")
            return
        }
        
        if courseNameText.text == "" {
            popAlert("Alert", "Course name can not be nil")
            return
        }
        
        if cateIdText.text == "" {
            popAlert("Alert", "Course Category ID can not be nil")
            return
        }
        var catId: Int = Int.max
        if let input_int = Int(cateIdText.text!){
            catId = input_int
        }else {
            popAlert("Alert", "Not a valid integer")
            return
        }
        
        self.cateModel = Utils.loadCategoryDataByCoredata()
        if !self.cateModel.contains(where: { $0.id == catId}) {
            popAlert("Alert", "Category ID not found")
            return
        }
        
        do {
            self.selectCourse?.name = courseNameText.text!
            self.selectCourse?.course_category_id = Int16(catId)
            try managedContext.save()
            
        } catch {
            print("Error updating entity: \(error)")
        }
        
        popAlert("Info", "Course is updated successfully")
        editView.removeFromSuperview()
        populateTable()
    }
    
    func popAlert(_ title: String, _ msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /* Add Item */
    @IBAction func addCourse(_ sender: Any) {
        subView.layer.shadowColor = UIColor.black.cgColor
        subView.layer.shadowOpacity = 0.5
        subView.layer.shadowOffset = CGSize(width: 0, height: 2)
        subView.layer.shadowRadius = 4
        view.addSubview(subView)
        courseIdText.text = ""
        courseNameText.text = ""
        collegeIdText.text = ""
        programIdText.text = ""
        cateIdText.text = ""
    }
    
    @IBAction func addCancel(_ sender: Any) {
        subView.removeFromSuperview()
    }
    
    @IBAction func confirmAdd(_ sender: Any) {
        if courseIdText.text == "" {
            popAlert("Alert", "Course ID can not be nil")
            return
        }
        
        var id: Int = Int.max
        if let input_int = Int(courseIdText.text!){
            id = input_int
        } else {
            popAlert("Alert", "Not a valid integer.")
            return
        }
        
        if checkDuplicate(id) == true {
            popAlert("Alert", "Course ID exists!")
            return
        }
        
        if courseNameText.text == "" {
            popAlert("Alert", "Course name can not be nil")
            return
        }
        
        if collegeIdText.text == "" {
            popAlert("Alert", "College ID can not be nil")
            return
        }
        var colId: Int = Int.max
        if let input_int = Int(collegeIdText.text!){
            colId = input_int
        }else {
            popAlert("Alert", "Not a valid integer")
            return
        }
        
        self.collegeModel = Utils.loadCollegeDataByCoredata()
        if !self.collegeModel.contains(where: { $0.id == colId}) {
            popAlert("Alert", "College ID not found")
            return
        }
        
        if programIdText.text == "" {
            popAlert("Alert", "Program ID can not be nil")
            return
        }
        var proId: Int = Int.max
        if let input_int = Int(programIdText.text!){
            proId = input_int
        }else {
            popAlert("Alert", "Not a valid integer")
            return
        }
        
        self.programModel = Utils.loadProgramDataByCoredata()
        if !programModel.contains(where: { $0.id == proId}) {
            popAlert("Alert", "Program ID not found")
            return
        }
        
        if cateIdText.text == "" {
            popAlert("Alert", "Catrgory ID can not be nil")
            return
        }
        var catId: Int = Int.max
        if let input_int = Int(cateIdText.text!){
            catId = input_int
        }else {
            popAlert("Alert", "Not a valid integer")
            return
        }
        
        self.cateModel = Utils.loadCategoryDataByCoredata()
        if !self.cateModel.contains(where: { $0.id == catId}) {
            popAlert("Alert", "Category ID not found")
            return
        }
        
        for item in self.programModel {
            if item.id == proId {
                if item.college_id != colId {
                    popAlert("Alert", "College does not have the program id")
                    return
                }
            }
        }
        if let new_cou = NSEntityDescription.insertNewObject(forEntityName: "Courses", into: managedContext) as? Courses {
            new_cou.id = Int16(id)
            new_cou.name = courseNameText.text
            new_cou.college_id = Int16(colId)
            new_cou.program_id = Int16(proId)
            new_cou.course_category_id = Int16(catId)
            do {
                try managedContext.save()
            } catch {
                fatalError("New course added faild, \(error)")
            }
        }
        
        popAlert("Info", "New course is added")
        subView.removeFromSuperview()
        courseIdText.text = ""
        courseNameText.text = ""
        collegeIdText.text = ""
        programIdText.text = ""
        cateIdText.text = ""
        populateTable()
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
            selectCourse = courseModel[indexPath.row]
            do {
                managedContext.delete(self.selectCourse!)
                try self.managedContext.save()
            } catch {
                fatalError("Delete failed. Error: \(error)")
            }
            populateTable()
        }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

