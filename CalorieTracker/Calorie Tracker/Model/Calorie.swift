//
//  Calorie.swift
//  Calorie Tracker
//
//  Created by Kerby Jean on 3/27/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import Foundation

struct Calorie {
    
    let value: Double
    let date: String
    
    init(value: Double) {
        self.value = value
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let formattedDate = dateFormatter.string(from: Date())
        self.date = formattedDate
    }
}
