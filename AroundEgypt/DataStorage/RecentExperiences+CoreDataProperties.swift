//
//  RecentExperiences+CoreDataProperties.swift
//  AroundEgypt
//
//  Created by MagyElias on 21/01/2025.
//
//

import Foundation
import CoreData


extension RecentExperiences {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentExperiences> {
        return NSFetchRequest<RecentExperiences>(entityName: "RecentExperiences")
    }

    @NSManaged public var city: CityModel
    @NSManaged public var coverPhoto: String
    @NSManaged public var experienceDescription: String
    @NSManaged public var id: String
    @NSManaged public var likesNo: Int64
    @NSManaged public var title: String
    @NSManaged public var viewsNo: Int64

}

extension RecentExperiences : Identifiable {

}
