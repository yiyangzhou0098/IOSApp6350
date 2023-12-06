//
//  Utils.swift
//  EmptyApp
//
//  Created by ZYY on 11/7/23.
//  Copyright © 2023 rab. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CollegeModel: Decodable {
    let name: String
    let id: String
    let address: String
    let logo: String
}

class Utils: NSObject{
    static let shared = Utils()
    static var managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    
    static func getCollegeDataFromAPI(apiurl: String, completion: @escaping ([CollegeModel]?) -> Void) {
        let apiurl = URL(string: apiurl)!
        URLSession.shared.dataTask(with: apiurl) { data, _, error in

            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check if data is present
            guard let data = data else {
                print("No data received")
                return
            }
            
            print("Received data: \(data)")
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("Received data:\n\(dataString)")
            }
            
            do {
                let colleges = try JSONDecoder().decode([CollegeModel].self, from: data)
                
                for col in colleges {
                    let newCol = Colleges(context: managedContext)
                    newCol.name = col.name
                    newCol.id = Int16(col.id)!
                    newCol.address = col.address
                    
                    if let logo = URL(string: col.logo),
                       let image = try? Data(contentsOf: logo) {
                        newCol.image = image
                    }
                }
                
                do {
                    try managedContext.save()
                } catch {
                    print("Error saving to CoreData: \(error)")
                }

            } catch {
                print("JSONSerialization error:", error)
            }
        }.resume()
    }
    
    static func loadCollegeDataByCoredata() -> [Colleges] {
        let fetchData: NSFetchRequest<Colleges> = Colleges.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchData.sortDescriptors = [sortDescriptor]
        do {
            let collegeModel = try (self.managedContext.fetch(fetchData)) as [Colleges]
            return collegeModel
        } catch {
            fatalError("Fail to load college data! \(error)")
        }
    }
    
    static func loadProgramDataByCoredata() -> [Programs] {
        let fetchData: NSFetchRequest<Programs> = Programs.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchData.sortDescriptors = [sortDescriptor]
        do {
            let programModel = try (self.managedContext.fetch(fetchData)) as [Programs]
            return programModel
        } catch {
            fatalError("Fail to load program data! \(error)")
        }
    }
    
    static func loadCourseDataByCoredata() -> [Courses] {
        let fetchData: NSFetchRequest<Courses> = Courses.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchData.sortDescriptors = [sortDescriptor]
        do {
            let courseModel = try (self.managedContext.fetch(fetchData)) as [Courses]
            return courseModel
        } catch {
            fatalError("Fail to load course data! \(error)")
        }
    }
    static func loadCategoryDataByCoredata() -> [Categories] {
        let fetchData: NSFetchRequest<Categories> = Categories.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchData.sortDescriptors = [sortDescriptor]
        do {
            let categoryModel = try (self.managedContext.fetch(fetchData)) as [Categories]
            return categoryModel
        } catch {
            fatalError("Fail to load Categories data! \(error)")
        }
    }
    
}
