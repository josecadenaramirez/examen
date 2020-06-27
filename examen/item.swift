//
//  item.swift
//  examen
//
//  Created by José Cadena on 26/06/20.
//  Copyright © 2020 examen.com. All rights reserved.
//

import Foundation
import UIKit
import CoreData

typealias JSON = [String:Any]
class item {
    var name:String
    var price:Float
    var location:String
    var img:String
    
    init(json:JSON) {
        name = json["productDisplayName"] as? String ?? "Default"
        price = json["listPrice"] as? Float ?? 0.0
        location = json["location"] as? String ?? "Default"
        img = json["lgImage"] as? String ?? ""
    }
    
    class func getItems(_ json:JSON) ->[item]{
        guard let status = json["plpResults"] as? JSON else{return[]}
        guard let items = status["records"] as? [JSON] else {return []}
        return items.compactMap({item(json: $0)})
    }
}

class saveSearch{
    public static func save(str:String){
        let new = History(context: CoreDataStack.context)
        new.name = str
        CoreDataStack.saveContext()
        
    }
    
    public static func getHistory()->[History]{
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(History.name), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let histories = try CoreDataStack.context.fetch(fetchRequest)
            return histories
        } catch {
            return []
        }
    }
}




class CoreDataStack {
  
  static let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "history")
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  static var context: NSManagedObjectContext { return persistentContainer.viewContext }
  
  class func saveContext () {
    let context = persistentContainer.viewContext
    
    guard context.hasChanges else {
      return
    }
    
    do {
      try context.save()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}

