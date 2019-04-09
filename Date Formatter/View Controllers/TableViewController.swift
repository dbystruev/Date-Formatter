//
//  TableViewController.swift
//  Date Formatter
//
//  Created by Denis Bystruev on 09/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    let locales = ["en", "ru"]
    let styles = [".none", ".short", ".medium", ".long", ".full"]
    
    var hideStatusBar = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

}

// MARK: - prefersStatusBarHidden
extension TableViewController {
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
}

// MARK: - UITableViewDataSource
extension TableViewController /* : UITableViewDataSource */ {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return styles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        configure(cell: cell, for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateStyleName = styles[section]
        return "dateStyle: \(dateStyleName)"
    }
}

// MARK: - Custom Methods
extension TableViewController {
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        
        let dateStyleIndex = indexPath.section
        let timeStyleIndex = indexPath.row
        let formatter = DateFormatter()
        
        let dateStyle = DateFormatter.Style(rawValue: UInt(dateStyleIndex))!
        let timeStyle = DateFormatter.Style(rawValue: UInt(timeStyleIndex))!
        
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        
        formatter.locale = Locale(identifier: "ru")
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateStyleName = styles[dateStyleIndex]
        let timeStyleName = styles[timeStyleIndex]
        formatter.locale = Locale(identifier: "ru")
        
        let dates = locales.reduce("") { result, locale in
            formatter.locale = Locale(identifier: locale)
            let date = formatter.string(from: Date())
            return "\(result)\n\(locale): \(date)"
        }
        
        cell.textLabel?.text = "dateStyle: \(dateStyleName)\ttimeStyle: \(timeStyleName)"
        cell.detailTextLabel?.text = dates
        cell.detailTextLabel?.numberOfLines = 0
    }
}

// MARK: - UIScrollViewDelegate
extension TableViewController /* : UIScrollViewDelegate */ {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideStatusBar = true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let topIndexPath = IndexPath(row: 0, section: 0)
        
        guard let visibleRows = tableView.indexPathsForVisibleRows else { return }
        
        if visibleRows.contains(topIndexPath) {
            hideStatusBar = false
        }
    }
}
