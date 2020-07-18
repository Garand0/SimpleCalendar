//
//  CalendarDataSource.swift
//  Calendar
//
//  Created by Maksim Vakula on 7/18/20.
//  Copyright © 2020 Maksim Vakula. All rights reserved.
//

import Then
import UIKit

final class CalendarDataSource: UICollectionViewFlowLayout {
    var dataSource: [CalendarModel] = [] {
        didSet { invalidateLayout() }
    }
    
    var cache: [Int: [Int: UICollectionViewLayoutAttributes]] = [:]
    
    // MARK: - UICollectionViewFlowLayout
    
    override func prepare() {
        super.prepare()
        cache = [:]
        
        let side = itemSize.width
        var height = CGFloat.zero
        
        for sectionIndex in .zero ..< dataSource.count {
            let section = dataSource[sectionIndex]
            let sectionStart = section.startWeekDay.rawValue

            var items: [Int: UICollectionViewLayoutAttributes] = [:]
            for itemIndex in .zero ..< dataSource[sectionIndex].dates.count {
                // TODO: разобрать это говно
                let position = ((sectionStart + itemIndex) % 7 == .zero) ? 7 : (sectionStart + itemIndex) % 7
                let line = CGFloat((sectionStart + itemIndex - 1) / 7).rounded(.toNearestOrAwayFromZero)
                
                let x = side * CGFloat(position - 1)
                let y = (side * CGFloat(line) + CGFloat(max(.zero, line - 1)) * 2) + height
                
                let layout =
                    UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: itemIndex, section: sectionIndex))
                
                layout.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
                items.updateValue(layout, forKey: itemIndex)
                guard itemIndex == dataSource[sectionIndex].dates.count - 1 else { continue }
                height = y + side
            }
            cache.updateValue(items, forKey: sectionIndex)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layout = super.layoutAttributesForItem(at: indexPath)
        let cachedLayout = cache[indexPath.section]?[indexPath.row]
        guard let frame = cachedLayout?.frame else { fatalError() }
        layout?.frame = frame
        return layout
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        return attributes?.compactMap { attribute in
            guard attribute.representedElementCategory == .cell else { return attribute }
            return layoutAttributesForItem(at: attribute.indexPath)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CalendarDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { dataSource.count }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource[section].dates.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DateCollectionViewCell.self),
            for: indexPath
        ).then {
            $0.backgroundColor = [UIColor.red, UIColor.green, UIColor.blue].randomElement()
            ($0 as? DateCollectionViewCell)?.configure(title: "\(indexPath.row)")
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CalendarDataSource: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CalendarDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let side = collectionView.bounds.width / 7
        return .init(width: side, height: side)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        referenceSizeForHeaderInSection _: Int
    ) -> CGSize {
        .init(width: collectionView.bounds.width, height: 2)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        minimumLineSpacingForSectionAt _: Int
    ) -> CGFloat {
        2
    }
    
    func collectionView(
        _ _: UICollectionView,
        layout _: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt _: Int
    ) -> CGFloat {
        .zero
    }
}
