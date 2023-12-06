//
//  enterMenuViewController.swift
//  EmptyApp
//
//  Created by ZYY on 11/7/23.
//  Copyright © 2023 rab. All rights reserved.
//

import UIKit
import CoreData

class enterMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterAll.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "1", for: indexPath)
        let name = filterAll[indexPath.row]
        cell.textLabel?.text = name
        return cell
    }
    
    
    @IBOutlet weak var collegeBtn: UIBarButtonItem!
    
    @IBOutlet weak var programBtn: UIBarButtonItem!
    
    @IBOutlet weak var courseBtn: UIBarButtonItem!
    
    @IBOutlet weak var courseCateBtn: UIBarButtonItem!
    
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    @IBOutlet weak var searchView: UITableView!
    
    @IBOutlet weak var searchText: UISearchBar!
    
    var filterCollege: [Colleges] = []
    var filterProgram: [Programs] = []
    var filterCourse: [Courses] = []
    var filterCategory: [Categories] = []
    var filterAll: [String] = []
        
    var programModel = [Programs]()
    var collegeModel = [Colleges]()
    var courseModel = [Courses]()
    var cateModel = [Categories]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        searchView.delegate = self
        searchView.dataSource = self
        searchView.register(UITableViewCell.self, forCellReuseIdentifier: "1")
        // Do any additional setup after loading the view.
    }
    
    
    func emptyFilter() {
        filterAll.removeAll()
        filterCollege.removeAll()
        filterCourse.removeAll()
        filterCategory.removeAll()
        filterProgram.removeAll()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            emptyFilter()
        }
        self.cateModel = Utils.loadCategoryDataByCoredata()
        self.collegeModel = Utils.loadCollegeDataByCoredata()
        self.courseModel = Utils.loadCourseDataByCoredata()
        self.programModel = Utils.loadProgramDataByCoredata()
        
        filterCollege = searchText.isEmpty ? collegeModel : collegeModel.filter { college in
            return college.name!.lowercased().contains(searchText.lowercased())
        }
        
        filterProgram = searchText.isEmpty ? programModel : programModel.filter { program in
            return program.name!.lowercased().contains(searchText.lowercased())
        }
        
        filterCourse = searchText.isEmpty ? courseModel : courseModel.filter { course in
            return course.name!.lowercased().contains(searchText.lowercased())
        }
        
        filterCategory = searchText.isEmpty ? cateModel : cateModel.filter { cate in
            return cate.name!.lowercased().contains(searchText.lowercased())
        }
                
        if filterCollege.count != 0 {
            for element in filterCollege {
                filterAll.append(element.name!)
            }
        }
        if filterProgram.count != 0 {
            for element in filterProgram {
                filterAll.append(element.name!)
            }
        }
        if filterCategory.count != 0 {
            for element in filterCategory {
                filterAll.append(element.name!)
            }
        }
        if filterCourse.count != 0 {
            for element in filterProgram {
                filterAll.append(element.name!)
            }
        }
    
        searchView.reloadData()
    }
    
    
//    @IBAction func manageCollege(_ sender: Any) {
//        let manageCollegeViewController = manageCollegeViewController(coder: <#NSCoder#>)
//        manageCollegeViewController.modalPresentationStyle = .overFullScreen
//        self.present(manageCollegeViewController, animated: true)
//    }
//
//    @IBAction func manageProgram(_ sender: Any) {
//        let manageProgramViewController = manageProgramViewController()
//        manageProgramViewController.modalPresentationStyle = .overFullScreen
//        self.present(manageProgramViewController, animated: true)
//    }
//
//    @IBAction func manageCourse(_ sender: Any) {
//        let manageCourseViewController = manageCourseViewController()
//        manageCourseViewController.modalPresentationStyle = .overFullScreen
//        self.present(manageCourseViewController, animated: true)
//    }
//
//    @IBAction func manageCategory(_ sender: Any) {
//        let manageCateViewController = manageCateViewController()
//        manageCateViewController.modalPresentationStyle = .overFullScreen
//        self.present(manageCateViewController, animated: true)
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
