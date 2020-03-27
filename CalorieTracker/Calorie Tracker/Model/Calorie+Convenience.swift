//
//  Calorie+Convenience.swift
//  Calorie Tracker
//
//  Created by Kerby Jean on 3/27/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import CoreData
import Foundation

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
