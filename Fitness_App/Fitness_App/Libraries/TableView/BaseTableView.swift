//
//  BaseTableView.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {
    
    // MARK: - Closure
    var didChangeContentSize: ((_ size: CGSize) -> Void)?
    
    // MARK: - Override functions
    override var contentSize: CGSize {
        didSet {
            didChangeContentSize?(contentSize)
        }
    }
    
    // MARK: - Register functions
    func setup(input: UITableViewDataSource & UITableViewDelegate) {
        delegate = input
        dataSource = input
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    func registerNibCellFor<T: UITableViewCell>(type: T.Type) {
        let nibName = UIView.getNameFor(type: type)
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func registerClassCellFor<T: UITableViewCell>(type: T.Type) {
        let nibName = UIView.getNameFor(type: type)
        register(type, forCellReuseIdentifier: nibName)
    }
    
    func registerNibHeaderFooterFor<T: UIView>(type: T.Type) {
        let nibName = UIView.getNameFor(type: type)
        register(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    func registerClassHeaderFooterFor<T: UIView>(type: T.Type) {
        let nibName = UIView.getNameFor(type: type)
        register(type, forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    // MARK: - Get component functions
    func reusableCell<T: UITableViewCell>(type: T.Type, indexPath: IndexPath? = nil) -> T? {
        let nibName = UIView.getNameFor(type: type)
        if let indexPath = indexPath {
            return self.dequeueReusableCell(withIdentifier: nibName, for: indexPath) as? T
        }
        return self.dequeueReusableCell(withIdentifier: nibName) as? T
    }
    
    func cell<T: UITableViewCell>(type: T.Type, section: Int, row: Int) -> T? {
        guard let indexPath = validIndexPath(section: section, row: row) else { return nil }
        return self.cellForRow(at: indexPath) as? T
    }
    
    func reusableHeaderFooterFor<T: UIView>(type: T.Type) -> T? {
        let nibName = UIView.getNameFor(type: type)
        return self.dequeueReusableHeaderFooterView(withIdentifier: nibName) as? T
    }
    
    func tableHeader<T: UIView>(type: T.Type) -> T? {
        return tableHeaderView as? T
    }
    
    func tableFooter<T: UIView>(type: T.Type) -> T? {
        return tableFooterView as? T
    }
    
    // MARK: - UI functions
    func scrollToTop(animated: Bool = true) {
        setContentOffset(.zero, animated: animated)
    }
    
    func scrollToBottom(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        let lastRowNumber = numberOfRows(inSection: numberOfSections - 1)
        guard lastRowNumber > 0 else { return }
        let indexPath = IndexPath(row: lastRowNumber - 1, section: numberOfSections - 1)
        scrollToRow(at: indexPath, at: .top, animated: animated)
    }
    
    func reloadCellAt(section: Int = 0, row: Int) {
        if let indexPath = validIndexPath(section: section, row: row) {
            reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func reloadSectionAt(index: Int) {
        reloadSections(IndexSet(integer: index), with: .fade)
    }
    
    func change(bottomInset value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    // MARK: - Supporting functions
    func validIndexPath(section: Int, row: Int) -> IndexPath? {
        guard section >= 0 && row >= 0 else { return nil }
        let rowCount = numberOfRows(inSection: section)
        guard rowCount > 0 && row < rowCount else { return nil }
        return IndexPath(row: row, section: section)
    }
}
