//
//  HomeViewController.swift
//  HW8
//
//  Created by ZYY on 11/18/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
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
    
    @IBOutlet weak var searchView: UITableView!
    
    @IBOutlet weak var searchText: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        searchView.delegate = self
        searchView.dataSource = self
        searchView.register(UITableViewCell.self, forCellReuseIdentifier: "1")
        // Do any additional setup after loading the view.
    }
    
    var programModel = [Programs]()
    var collegeModel = [Colleges]()
    var courseModel = [Courses]()
    var cateModel = [Categories]()
    
    var filterCollege: [Colleges] = []
    var filterProgram: [Programs] = []
    var filterCourse: [Courses] = []
    var filterCategory: [Categories] = []
    var filterAll: [String] = []
    
    func emptyFilter() {
        filterAll.removeAll()
        filterCollege.removeAll()
        filterCourse.removeAll()
        filterCategory.removeAll()
        filterProgram.removeAll()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        emptyFilter()
        searchView.reloadData()
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
