//
//  CoreDataManager.swift
//  ChessBoardGame
//
//  Created by Shidong Lin on 9/25/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    lazy var container: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "ChessBoardGame")
        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        })
        return persistentContainer
    }()

    func saveWinCount(forPlayer player: String, count: Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerWinCount")
        request.predicate = NSPredicate(format: "player == %@", player)
        do {
            let objects = try container.viewContext.fetch(request)
            if let objects = objects as? [NSManagedObject], let firstObject = objects.first {
                firstObject.setValue(count, forKey: "winCount")
                firstObject.setValue(player, forKey: "player")
            } else {
                let newObject = NSEntityDescription.insertNewObject(forEntityName: "PlayerWinCount", into: container.viewContext)
                newObject.setValue(count, forKey: "winCount")
                newObject.setValue(player, forKey: "player")
            }
            try container.viewContext.save()
        } catch(let error) {
            assertionFailure(error.localizedDescription)
        }
    }

    func fetchWinCount(forPlayer player: String) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerWinCount")
        request.predicate = NSPredicate(format: "player == %@", player)
        do {
            let objects = try container.viewContext.fetch(request)
            if let objects = objects as? [NSManagedObject], let firstObject = objects.first, let count = firstObject.value(forKey: "winCount") as? Int {
                return count
            }
        } catch(let error) {
            assertionFailure(error.localizedDescription)
        }
        return 0
    }
}
