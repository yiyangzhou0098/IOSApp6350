//
//  manageProgramViewController.swift
//  EmptyApp
//
//  Created by ZYY on 11/8/23.
//  Copyright © 2023 rab. All rights reserved.
//

import UIKit
import CoreData

class manageProgramViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
            
    @IBOutlet var subView: UIView!
    
    @IBOutlet var editView: UIView!
    
    @IBOutlet weak var addCancelBtn: UIBarButtonItem!
    
    @IBOutlet weak var collegeIdText: UITextField!
    
    @IBOutlet weak var collegeIdText2: UITextField!
    
    @IBOutlet weak var programNameText: UITextField!
    
    @IBOutlet weak var programNameText2: UITextField!
    
    @IBOutlet weak var programIdText: UITextField!
            
    @IBOutlet weak var programIdText2: UITextField!
    
    @IBOutlet weak var selectCancel: UIBarButtonItem!
    
    @IBOutlet var updateBar: UIToolbar!
    
    @IBOutlet var addBar: UIToolbar!
    
    @IBOutlet weak var viewTable: UITableView!
    
    var selectColId: Int = -1
        
    /* Coredata Operations */
    var managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var selectProgram: Programs? = nil
    var programModel = [Programs]()
    var collegeModel = [Colleges]()
    var courseModel = [Courses]()
    
    func checkDuplicate(_ id: Int) -> Bool {
        self.programModel = Utils.loadProgramDataByCoredata()
        return programModel.contains{ $0.id == id }
    }
    
    func populateTable() {
        self.programModel = Utils.loadProgramDataByCoredata()
        viewTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        programModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "1", for: indexPath)
        let item = programModel[indexPath.row]
        cell.textLabel?.text = "ID:\(item.id) | \(item.name ?? "No name") | College ID: \(item.college_id)"
        return cell
    }

    /* Update program */
    @IBAction func updateCancel(_ sender: Any) {
        editView.layer.shadowColor = UIColor.black.cgColor
        editView.layer.shadowOpacity = 0.5
        editView.layer.shadowOffset = CGSize(width: 0, height: 2)
        editView.layer.shadowRadius = 4
        editView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectProgram = programModel[indexPath.row]
        programIdText2.text = String(self.selectProgram!.id)
        programNameText2.text = self.selectProgram?.name
        collegeIdText2.text = String(self.selectProgram!.college_id)
        
        editView.layer.shadowColor = UIColor.black.cgColor
        editView.layer.shadowOpacity = 0.5
        editView.layer.shadowOffset = CGSize(width: 0, height: 2)
        editView.layer.shadowRadius = 4
        view.addSubview(editView)
    }
    
    @IBAction func updateItem(_ sender: Any) {
        if programIdText2.text == "" {
            popAlert("Alert", "Program ID can not be nil")
            return
        }
        
        var proId: Int = Int.max
        if let input_int = Int(programIdText2.text!){
            proId = input_int
        }else {
            popAlert("Alert", "Not a valid integer")
            return
        }
        
        if self.selectProgram?.id != Int16(proId) {
            popAlert("Alert", "Program ID can not be changed")
            return
        }
        
        if programNameText2.text == "" {
            popAlert("Alert", "Program name can not be nil")
            return
        }
        
        if collegeIdText2.text == "" {
            popAlert("Alert", "Program Collge ID can not be nil")
            return
        }
        
        var colId: Int = Int.max
        if let input_int = Int(collegeIdText2.text!){
            colId = input_int
        }else {
            popAlert("Alert", "Not a valid integer")
            return
        }
        
        self.collegeModel = Utils.loadCollegeDataByCoredata()
        if !self.collegeModel.contains(where: { $0.id == colId }) {
            popAlert("Alert", "College ID not found")
            return
        }
        
        self.courseModel = Utils.loadCourseDataByCoredata()
        do {
            self.selectProgram?.name = programNameText2.text!
            self.selectProgram?.college_id = Int16(colId)
            if self.selectProgram?.college_id != Int16(colId) {
                for cou in self.courseModel {
                    if cou.program_id == proId {
                        cou.college_id = Int16(colId)
                    }
                }
            }
            try managedContext.save()
        } catch {
            fatalError("Updated program failed \(error)")
        }
        popAlert("Info", "Program is edited successfully")
        
        programIdText.text = ""
        programNameText.text = ""
        collegeIdText.text = ""
        editView.removeFromSuperview()
        populateTable()
    }
    
    /* Add item */
    @IBAction func addCancel(_ sender: Any) {
        subView.removeFromSuperview()
    }
    
    @IBAction func confirmAdd(_ sender: Any) {
        if programIdText.text == "" {
            popAlert("Alert", "Program ID can not be nil")
            return
        }
                
        var id: Int = Int.max
        if let input_int = Int(programIdText.text!){
            id = input_int
        } else {
            popAlert("Alert", "Not a valid integer.")
            return
        }
        
        if checkDuplicate(id) == true {
            popAlert("Alert", "Program ID exists!")
            return
        }
        
        if programNameText.text == "" {
            popAlert("Alert", "Program name can not be nil")
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
        if !collegeModel.contains(where: { $0.id == colId}) {
            popAlert("Alert", "College ID not found")
            return
        }
        
        if let newProgram = NSEntityDescription.insertNewObject(forEntityName: "Programs", into: managedContext) as? Programs {
            newProgram.id = Int16(id)
            newProgram.name = programNameText.text
            newProgram.college_id = Int16(colId)
            do {
                try managedContext.save()
            } catch {
                fatalError("New program added faild, \(error)")
            }
        }
        popAlert("Info", "New program is added")
        subView.removeFromSuperview()
        programIdText.text = ""
        programNameText.text = ""
        collegeIdText.text = ""
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
        
        programIdText.keyboardType = .numberPad
        collegeIdText.keyboardType = .numberPad
        collegeIdText2.keyboardType = .numberPad
        programIdText2.isUserInteractionEnabled = false
        
        populateTable()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addProgram(_ sender: Any) {
        subView.layer.shadowColor = UIColor.black.cgColor
        subView.layer.shadowOpacity = 0.5
        subView.layer.shadowOffset = CGSize(width: 0, height: 2)
        subView.layer.shadowRadius = 4
        view.addSubview(subView)
        programIdText.text = ""
        programNameText.text = ""
        collegeIdText.text = ""
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
        selectProgram = programModel[indexPath.row]
        self.courseModel = Utils.loadCourseDataByCoredata()
        if courseModel.contains(where: {$0.program_id == selectProgram?.id}) {
            popAlert("Error", "Program can not be deleted because it contains course")
            return
        }
        do {
            managedContext.delete(self.selectProgram!)
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
