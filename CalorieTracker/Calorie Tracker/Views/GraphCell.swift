//
//  GraphCell.swift
//  Calorie Tracker
//
//  Created by Kerby Jean on 3/27/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import UIKit
import SwiftChart

class GraphCell: UITableViewCell {
    
    var chart: Chart!
    
    static var id: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        chart = Chart(frame: CGRect.zero)
        contentView.addSubview(chart)
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chart.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            chart.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView(_:)), name: .graphValue, object: nil)
    }
    
    @objc private func updateView(_ notification: Notification) {
        guard let userInfo =  notification.userInfo, let calories = userInfo["calories"] as? [Calorie] else { return }
        let values = calories.compactMap { $0.value }
        let series = ChartSeries(values)
        series.color = ChartColors.greenColor()
        series.area = true
        chart.add(series)
    }
}
