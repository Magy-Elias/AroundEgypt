//
//  CoreDataManager.swift
//  AroundEgypt
//
//  Created by MagyElias on 20/01/2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private let inMemoryStore: Bool
    private let persistentContainer: NSPersistentContainer
    
    init(isInMemoryStore: Bool = false) {
        var forceInMemoryStore: Bool = isInMemoryStore
#if TESTING
        forceInMemoryStore = true
#endif
        self.inMemoryStore = forceInMemoryStore
        self.persistentContainer = PersistenceController.shared.container
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save Core Data context: \(error.localizedDescription)")
            }
        }
    }
    
    func saveRecentExperiences(_ experiences: [ExperienceResponse]) {
        for experience in experiences {
            let entity = RecentExperiences(context: context)
            entity.id = experience.id
            entity.title = experience.title
            entity.coverPhoto = experience.coverPhoto
            entity.experienceDescription = experience.description
            entity.viewsNo = Int64(experience.viewsNo)
            entity.likesNo = Int64(experience.likesNo)

            // Save the associated City object
            let cityEntity = fetchOrCreateCity(city: experience.city)
            entity.city = cityEntity // Associate the city with the experience
        }
        saveContext()
    }
    
    func fetchRecentExperiences() -> [ExperienceResponse] {
        let fetchRequest: NSFetchRequest<RecentExperiences> = RecentExperiences.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { experience in
                let city = City(id: Int(experience.city.id), name: experience.city.name)
                return ExperienceResponse(
                    id: experience.id,
                    title: experience.title,
                    coverPhoto: experience.coverPhoto,
                    description: experience.experienceDescription,
                    viewsNo: Int(experience.viewsNo),
                    likesNo: Int(experience.likesNo),
                    city: city
                )
            }
        } catch {
            print("Failed to fetch recent experiences: \(error.localizedDescription)")
            return []
        }
    }

    func saveRecommendedExperiences(_ experiences: [ExperienceResponse]) {
        for experience in experiences {
            let entity = RecommendedExperiences(context: context)
            entity.id = experience.id
            entity.title = experience.title
            entity.coverPhoto = experience.coverPhoto
            entity.experienceDescription = experience.description
            entity.viewsNo = Int64(experience.viewsNo)
            entity.likesNo = Int64(experience.likesNo)
            
            // Save the associated City object
            let cityEntity = fetchOrCreateCity(city: experience.city)
            entity.city = cityEntity // Associate the city with the experience
        }
        saveContext()
    }
    
    func fetchRecommendedExperiences() -> [ExperienceResponse] {
        let fetchRequest: NSFetchRequest<RecommendedExperiences> = RecommendedExperiences.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { experience in
                let city = City(id: Int(experience.city.id), name: experience.city.name)
                return ExperienceResponse(
                    id: experience.id,
                    title: experience.title,
                    coverPhoto: experience.coverPhoto,
                    description: experience.experienceDescription,
                    viewsNo: Int(experience.viewsNo),
                    likesNo: Int(experience.likesNo),
                    city: city
                )
            }
        } catch {
            print("Failed to fetch recommended experiences: \(error.localizedDescription)")
            return []
        }
    }

    func fetchOrCreateCity(city: City) -> CityModel {
        let fetchRequest: NSFetchRequest<CityModel> = CityModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", city.id)
        
        do {
            let existingCities = try context.fetch(fetchRequest)
            if let existingCity = existingCities.first {
                return existingCity // Return existing city if found
            } else {
                // Create a new city if not found
                let cityEntity = CityModel(context: context)
                cityEntity.id = Int32(city.id)
                cityEntity.name = city.name
                return cityEntity
            }
        } catch {
            print("Error fetching or creating city: \(error.localizedDescription)")
            let cityEntity = CityModel(context: context) // Create a default city entity
            cityEntity.id = Int32(city.id)
            cityEntity.name = city.name
            return cityEntity
        }
    }
}
