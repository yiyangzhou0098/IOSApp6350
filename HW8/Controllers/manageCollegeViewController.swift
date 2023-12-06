//
//  manageCollegeViewController.swift
//  EmptyApp
//
//  Created by ZYY on 11/7/23.
//  Copyright © 2023 rab. All rights reserved.
//

import UIKit
import CoreData

class manageCollegeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var addCollege: UIView!
    
    @IBOutlet weak var addCollegeBtn: UIBarButtonItem!
            
    @IBOutlet var subView: UIView!
        
    @IBOutlet weak var addCancelBtn: UIBarButtonItem!
    
    @IBOutlet weak var collegeIdText: UITextField!
    @IBOutlet weak var collegeIdTest2: UITextField!
    
    @IBOutlet weak var collegeNameText: UITextField!
    @IBOutlet weak var collegeNameText2: UITextField!
    
    @IBOutlet weak var collegeAddressText: UITextField!
    @IBOutlet weak var collegeAddressText2: UITextField!
        
    @IBOutlet var updateBar: UIToolbar!
        
    @IBOutlet weak var viewTable: UITableView!

    @IBOutlet weak var chooseImageBtn: UIButton!
    @IBOutlet weak var chooseImageBtn2: UIButton!
    
    @IBOutlet weak var collegeImageView: UIImageView!
    @IBOutlet weak var collegeImageView2: UIImageView!
    
    @IBOutlet weak var customTableViewCell: UITableViewCell!
    
    @IBOutlet var editView: UIView!
    
    override var shouldAutorotate: Bool {
        return false
    }

    // Specify the supported interface orientations
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
            
    /* Coredata Operations */
    var managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var selectCollege: Colleges? = nil
    var programModel = [Programs]()
    var collegeModel = [Colleges]()
    
    func checkDuplicate(_ id: Int) -> Bool {
        self.collegeModel = Utils.loadCollegeDataByCoredata()
        return collegeModel.contains{ $0.id == id }
    }
    
    func populateTable() {
        self.collegeModel = Utils.loadCollegeDataByCoredata()
        viewTable.reloadData()
    }

    /* Image Picker */
    @IBAction func chooseImageTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            collegeImageView.image = editedImage
            collegeImageView2.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            collegeImageView.image = originalImage
            collegeImageView2.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /* Api import json data*/
    @IBAction func updateFromApi(_ sender: Any) {
        Utils.getCollegeDataFromAPI(apiurl: "https://6429924debb1476fcc4c36b2.mockapi.io/company", completion: {_ in
            self.populateTable()
        })
        sleep(2)
        populateTable()
    }
    
    
    /* Show all Items in table  */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collegeModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let college = collegeModel[indexPath.row]
        cell.idCell.text = "ID:\(college.id)"
        cell.nameCell.text = "\(college.name ?? "No name")"
        cell.addrCell.text = "\(college.address ?? "No address")"
        cell.imageCell.image = UIImage(data: college.image ?? Data())
        return cell
    }
    
    
    /* Update College */
    @IBAction func updateCancel(_ sender: Any) {
        editView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCollege = collegeModel[indexPath.row]
        collegeIdTest2.text = String(self.selectCollege!.id)
        collegeNameText2.text = self.selectCollege?.name
        collegeAddressText2.text = self.selectCollege?.address
        collegeImageView2.image = UIImage(data: self.selectCollege!.image!)
        
        editView.layer.shadowColor = UIColor.black.cgColor
        editView.layer.shadowOpacity = 0.5
        editView.layer.shadowOffset = CGSize(width: 0, height: 2)
        editView.layer.shadowRadius = 4
        view.addSubview(editView)
    }
    
    @IBAction func updateItem(_ sender: Any) {
        if collegeIdTest2.text == "" {
            popAlert("Alert", "College ID can not be nil")
            return
        }
                
        var colId: Int = Int.max
        if let input_int = Int(collegeIdTest2.text!){
            colId = input_int
        }else {
            popAlert("Alert", "Not a valid integer")
            return
        }
                
        let id: Int = Int(collegeIdTest2.text!)!
        if id != Int16(self.selectCollege!.id) {
            popAlert("Alert", "ID can not be changed")
            return
        }
        
        if collegeNameText2.text == "" {
            popAlert("Alert", "College name can not be nil")
            return
        }
        
        if collegeAddressText2.text == "" {
            popAlert("Alert", "College address can not be nil")
            return
        }
        
        do {
            self.selectCollege?.name = self.collegeNameText2.text!
            self.selectCollege?.address = self.collegeAddressText2.text!
            self.selectCollege?.image = self.collegeImageView2.image?.jpegData(compressionQuality: 1.0)
            try managedContext.save()
            
        } catch {
            print("Error updating entity: \(error)")
        }
        
        popAlert("Info", "College is edited successfully")
        collegeIdTest2.text = ""
        collegeNameText2.text = ""
        collegeAddressText2.text = ""
        collegeImageView2.image = nil
        editView.removeFromSuperview()
        populateTable()
    }
    
    /* Delete items handler */
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
        selectCollege = collegeModel[indexPath.row]
        self.programModel = Utils.loadProgramDataByCoredata()
        if programModel.contains(where: {$0.college_id == selectCollege?.id}) {
            popAlert("Error", "College can not be deleted because it contains program")
            return
        }
        do {
            managedContext.delete(self.selectCollege!)
            try self.managedContext.save()
        } catch {
            fatalError("Delete failed. Error: \(error)")
        }
        populateTable()
    }
    
    /* Add items handler */
    @IBAction func addCancel(_ sender: Any) {
        collegeImageView.image = nil
        subView.removeFromSuperview()
    }

    @IBAction func addCollege(_ sender: Any) {
        subView.layer.shadowColor = UIColor.black.cgColor
        subView.layer.shadowOpacity = 0.5
        subView.layer.shadowOffset = CGSize(width: 0, height: 2)
        subView.layer.shadowRadius = 4
        
        collegeIdText.text = ""
        collegeNameText.text = ""
        collegeAddressText.text = ""
        collegeImageView.image = nil
        view.addSubview(subView)
    }
    
    @IBAction func confirmAdd(_ sender: Any) {
        if collegeIdText.text == "" {
            popAlert("Alert", "College ID can not be nil")
            return
        }
        var id: Int = Int(collegeIdText.text!)!
        if checkDuplicate(id) == true {
            popAlert("Alert", "College ID exists!")
            return
        }
        
        if collegeNameText.text == "" {
            popAlert("Alert", "College name can not be nil")
            return
        }
        
        if collegeAddressText.text == "" {
            popAlert("Alert", "College address can not be nil")
            return
        }
        
        if let newCollege = NSEntityDescription.insertNewObject(forEntityName: "Colleges", into: managedContext) as? Colleges {
            newCollege.name = collegeNameText.text
            newCollege.address = collegeAddressText.text
            newCollege.id = Int16(id)
            newCollege.image = collegeImageView.image?.jpegData(compressionQuality: 1.0)
            do {
                try self.managedContext.save()
            } catch {
                fatalError("Add new college failed. Error: \(error)")
            }
        }
        popAlert("Info", "New college is added")
        subView.removeFromSuperview()
        collegeIdText.text = ""
        collegeNameText.text = ""
        collegeAddressText.text = ""
        collegeImageView.image = nil
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
        viewTable.dataSource = self
        collegeIdText.keyboardType = .numberPad
        collegeIdTest2.isUserInteractionEnabled = false
        populateTable()
    }

     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

/* Custom cell class */
class CustomTableViewCell: UITableViewCell {
    
    var managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!

    @IBOutlet weak var imageCell: UIImageView!
    
    @IBOutlet weak var nameCell: UILabel!
    
    @IBOutlet weak var addrCell: UILabel!
    
    @IBOutlet weak var idCell: UILabel!
    
}
