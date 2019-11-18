//
//  CoreDataController.swift
//  BestPlaceToLive
//
//  Created by Luqmaan Khan on 11/15/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {
   
    var moc: NSManagedObjectContext
    static var shared = CoreDataController()
    
    init(context: NSManagedObjectContext? = CoreDataStack.shared.mainContext) {
        self.moc = context!
    }
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        }
        catch {
            NSLog("Error saving to persistent store: \(error)")
            moc.reset()
        }
    }
    
    func addCitySearch(id: String, cityName: String, filters: [String], cityPhoto: String?) {
        _ = CitySearch(id: id, cityName: cityName, cityPhoto: cityPhoto ?? "", filters: filters )
        saveToPersistentStore()
    }
    
    func deleteCitySearch(citySearch: CitySearch) {
        moc.delete(citySearch)
        saveToPersistentStore()
    }
    
    func updateCitySearch(citySearch: CitySearch, cityName: String, filters: [String], cityPhoto: String? = nil) {
        citySearch.cityName = cityName
        citySearch.filters = filters
        citySearch.cityPhoto = cityPhoto
        saveToPersistentStore()
    }
    
    func fetchSingleCitySearchFromPersistence(identifier: String, context: NSManagedObjectContext) -> CitySearch? {
        let fetchRequest: NSFetchRequest<CitySearch> = CitySearch.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", identifier)
        var result: CitySearch? = nil
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error retreiving single city search from coredata: \(error)")
            }
        return result
    }
}

