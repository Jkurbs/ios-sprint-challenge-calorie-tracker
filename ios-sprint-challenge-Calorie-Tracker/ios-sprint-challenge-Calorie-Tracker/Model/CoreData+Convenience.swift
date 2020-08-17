//
//  CoreData+Convenience.swift
//  ios-sprint-challenge-Calorie-Tracker
//
//  Created by David Williams on 8/16/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    
    @discardableResult convenience init(value: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.value = value
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let formattedDate = dateFormatter.string(from: Date())
        self.date = formattedDate
    }
}
