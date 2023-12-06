//
//  Colleges.swift
//  HW8
//
//  Created by ZYY on 11/30/23.
//

import Foundation
import CoreData

//class Colleges: Decodable {
//
//    enum CodingKeys: String, CodingKey {
//        // Define CodingKeys based on your entity attributes
//        case name
//        case location
//        case id
//        case image
//        // Add other CodingKeys as needed
//    }
//
//    required convenience init(from decoder: Decoder) throws {
//        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
//            fatalError("Missing context")
//        }
//
//        // This assumes your entity has a "name" attribute, adjust accordingly
//        guard let entity = NSEntityDescription.entity(forEntityName: "Colleges", in: context) else {
//            fatalError("Failed to decode Colleges")
//        }
//
//        self.init(entity: entity, insertInto: context)
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.location = try container.decode(String.self, forKey: .location)
//        // Decode other properties as needed
//    }
//}
