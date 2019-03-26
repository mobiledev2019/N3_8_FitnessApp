//
//  BaseCollectionView.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

class BaseCollectionView: UICollectionView {

    // MARK: - Closure
    var didChangeContentSize: ((_ size: CGSize) -> Void)?
    
    // MARK: - Override functions
    override var contentSize: CGSize {
        didSet {
            didChangeContentSize?(contentSize)
        }
    }
    
    // MARK: - Register functions
    func setup(input: UICollectionViewDataSource & UICollectionViewDelegate) {
        delegate = input
        dataSource = input
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    func configLayout(scrollDirection: UICollectionView.ScrollDirection = .vertical,
                      sectionInset: UIEdgeInsets = .zero,
                      cellSpacing: CGFloat,
                      lineSpacing: CGFloat,
                      headerSize: CGSize = .zero,
                      footerSize: CGSize = .zero) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.sectionInset = sectionInset
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.headerReferenceSize = headerSize
        layout.footerReferenceSize = footerSize
        self.collectionViewLayout = layout
    }
    
    func configItemSize(itemPerRow: Int, itemRatio: CGFloat) {
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let sectionInset = layout.sectionInset
        let cellSpacing = layout.minimumInteritemSpacing
        let itemWidth = CGFloat(floor(self.frame.width - sectionInset.left - sectionInset.right - (CGFloat(itemPerRow - 1) * cellSpacing)))  / CGFloat(itemPerRow)
        let itemHeight = itemWidth / itemRatio
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    func configItemSize(size: CGSize) {
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = size
    }
    
    func registerNibCellFor<T: UICollectionViewCell>(type: T.Type) {
        let nibName = UIView.getNameFor(type: type)
        register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
    
    func registerClassCellFor<T: UICollectionViewCell>(type: T.Type) {
        let nibName = UIView.getNameFor(type: type)
        register(type, forCellWithReuseIdentifier: nibName)
    }
    
    func registerNibHeaderFor<T: UIView>(type: T.Type) {
        let nibName = UIView.getNameFor(type: type)
        register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: nibName)
    }
    
    func registerNibFooterFor<T: UIView>(type: T.Type) {
        let nibName = UIView.getNameFor(type: type)
        register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: nibName)
    }
    
    func registerClassHeaderFor<T: UIView>(type: T.Type) {
        let nibName = UIView.getNameFor(type: type)
        register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: nibName)
    }
    
    func registerClassFooterFor<T: UIView>(type: T.Type) {
        let nibName = UIView.getNameFor(type: type)
        register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: nibName)
    }
    
    // MARK: - Get component functions
    func reusableCell<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T? {
        let nibName = UIView.getNameFor(type: type)
        return self.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as? T
    }
    
    func cell<T: UICollectionViewCell>(type: T.Type, section: Int, row: Int) -> T? {
        guard let indexPath = validIndexPath(section: section, row: row) else { return nil }
        return self.cellForItem(at: indexPath) as? T
    }
    
    func reusableHeaderFor<T: UIView>(type: T.Type, indexPath: IndexPath) -> T? {
        let nibName = UIView.getNameFor(type: type)
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: nibName, for: indexPath) as? T
    }
    
    func reusableFooterFor<T: UIView>(type: T.Type, indexPath: IndexPath) -> T? {
        let nibName = UIView.getNameFor(type: type)
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: nibName, for: indexPath) as? T
    }
    
    // MARK: - UI functions
    func scrollToTop(animated: Bool = true) {
        setContentOffset(.zero, animated: animated)
    }
    
    func scrollToBottom(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        let lastRowNumber = numberOfItems(inSection: numberOfSections - 1)
        guard lastRowNumber > 0 else { return }
        let indexPath = IndexPath(row: lastRowNumber - 1, section: numberOfSections - 1)
        scrollToItem(at: indexPath, at: .top, animated: animated)
    }
    
    func reloadCellAt(section: Int = 0, row: Int) {
        if let indexPath = validIndexPath(section: section, row: row) {
            reloadItems(at: [indexPath])
        }
    }
    
    func reloadSectionAt(index: Int) {
        reloadSections(IndexSet(integer: index))
    }
    
    func change(bottomInset value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    // MARK: - Supporting functions
    func validIndexPath(section: Int, row: Int) -> IndexPath? {
        guard section >= 0 && row >= 0 else { return nil }
        let rowCount = numberOfItems(inSection: section)
        guard rowCount > 0 && row < rowCount else { return nil }
        return IndexPath(row: row, section: section)
    }
}
