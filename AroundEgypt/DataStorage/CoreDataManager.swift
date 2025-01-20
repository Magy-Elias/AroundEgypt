////
////  CoreDataManager.swift
////  AroundEgypt
////
////  Created by moweex on 20/01/2025.
////
//
//import CoreData
//
//class CoreDataManager {
//    static let shared = CoreDataManager()
//
//    private let inMemoryStore: Bool
//    private let persistentContainer: NSPersistentContainer
//    
//    init(isInMemoryStore: Bool = false) {
//        var forceInMemoryStore: Bool = isInMemoryStore
//#if TESTING
//        forceInMemoryStore = true
//#endif
//        self.inMemoryStore = forceInMemoryStore
//        self.persistentContainer = PersistenceController.shared.container
//    }
//    
//    var context: NSManagedObjectContext {
//        persistentContainer.viewContext
//    }
//    
//    func saveContext() {
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                print("Failed to save Core Data context: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func saveRecentExperiences(_ experiences: [ExperienceResponse]) {
//        for experience in experiences {
//            let entity = RecentExperiences(context: context)
//            entity.id = experience.id
//            entity.title = experience.title
//            entity.coverPhoto = experience.coverPhoto
//            entity.experienceDescription = experience.description
//            entity.viewsNo = Int64(experience.viewsNo ?? 0)
//            entity.likesNo = Int64(experience.likesNo ?? 0)
//            entity.city = experience.city
//        }
//        saveContext()
//    }
//    
//    func fetchRecentExperiences() -> [ExperienceResponse] {
//        let fetchRequest: NSFetchRequest<RecentExperiences> = RecentExperiences.fetchRequest()
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            return results.map { experience in
//                ExperienceResponse(
//                    id: experience.id,
//                    title: experience.title,
//                    coverPhoto: experience.coverPhoto,
//                    description: experience.experienceDescription,
//                    viewsNo: Int(experience.viewsNo),
//                    likesNo: Int(experience.likesNo),
//                    city: experience.city
//                )
//            }
//        } catch {
//            print("Failed to fetch recent experiences: \(error.localizedDescription)")
//            return []
//        }
//    }
//
//    func saveRecommendedExperiences(_ experiences: [ExperienceResponse]) {
//        for experience in experiences {
//            let entity = RecommendedExperiences(context: context)
//            entity.id = experience.id
//            entity.title = experience.title
//            entity.coverPhoto = experience.coverPhoto
//            entity.experienceDescription = experience.description
//            entity.viewsNo = Int64(experience.viewsNo ?? 0)
//            entity.likesNo = Int64(experience.likesNo ?? 0)
//            entity.city = experience.city
//        }
//        saveContext()
//    }
//    
//    func fetchRecommendedExperiences() -> [ExperienceResponse] {
//        let fetchRequest: NSFetchRequest<RecommendedExperiences> = RecommendedExperiences.fetchRequest()
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            return results.map { experience in
//                ExperienceResponse(
//                    id: experience.id,
//                    title: experience.title,
//                    coverPhoto: experience.coverPhoto,
//                    description: experience.experienceDescription,
//                    viewsNo: Int(experience.viewsNo),
//                    likesNo: Int(experience.likesNo),
//                    city: experience.city
//                )
//            }
//        } catch {
//            print("Failed to fetch recommended experiences: \(error.localizedDescription)")
//            return []
//        }
//    }
//}
//
