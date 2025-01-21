//
//  CityModel+CoreDataProperties.swift
//  AroundEgypt
//
//  Created by MagyElias on 21/01/2025.
//
//

import Foundation
import CoreData


extension CityModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityModel> {
        return NSFetchRequest<CityModel>(entityName: "CityModel")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String

}

extension CityModel : Identifiable {

}
