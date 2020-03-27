//
//  GraphCell.swift
//  Calorie Tracker
//
//  Created by Kerby Jean on 3/27/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import UIKit
import SwiftChart

class GraphView: Chart {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NotificationCenter.default.addObserver(self, selector: #selector(updateView(_:)), name: .graphValue, object: nil)
    }
    
    @objc private func updateView(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let calories = userInfo["calories"] as? [Calorie] else { return }
        let values = calories.compactMap { $0.value }
        removeAllSeries()
        let series = ChartSeries(values)
        series.color = ChartColors.greenColor()
        series.area = true
        add(series)
    }
}
