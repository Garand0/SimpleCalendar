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
    // MARK: - Types

    typealias SectionDataSet = [Int: UICollectionViewLayoutAttributes]

    // MARK: - UICollectionViewLayout

    override var collectionViewContentSize: CGSize {
        .init(width: collectionView?.bounds.width ?? .zero, height: height)
    }

    // MARK: - Public Properties

    var dataSource: [CalendarModel] = [] {
        didSet { invalidateLayout() }
    }

    // MARK: - Private Properties

    private var period: Period?
    private var cache: [Int: SectionDataSet] = [:]
    private var cacheHeader: SectionDataSet = [:]
    
    private var height = CGFloat.zero
    
    // MARK: - UICollectionViewFlowLayout
    
    override func prepare() {
        super.prepare()
        cache = [:]
        cacheHeader = [:]
        
        let side = itemSize.width
        var height = CGFloat.zero
        
        for sectionIndex in .zero ..< dataSource.count {
            let section = dataSource[sectionIndex]
            let sectionStart = section.startWeekDay.rawValue
            
            let indexPath = IndexPath(row: 0, section: sectionIndex)
            let header = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            header.frame = CGRect(x: .zero, y: height, width: collectionView?.bounds.width ?? .zero, height: 100)
            cacheHeader.updateValue(header, forKey: sectionIndex)
            
            height += 100
            
            var items: SectionDataSet = [:]
            for itemIndex in .zero ..< dataSource[sectionIndex].dates.count {
                let position = ((sectionStart + itemIndex) % 7 == .zero) ? 7 : (sectionStart + itemIndex) % 7
                let line = CGFloat((sectionStart + itemIndex - 1) / 7).rounded(.toNearestOrAwayFromZero)
                
                let x = side * CGFloat(position - 1)
                let lineSpacingOffsets = CGFloat(max(.zero, line - 1) * 2)
                let rowHeight = side * CGFloat(line)
                let y = rowHeight + lineSpacingOffsets + height
                
                let indexPath = IndexPath(row: itemIndex, section: sectionIndex)
                let layout = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                layout.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
                items.updateValue(layout, forKey: itemIndex)
                guard itemIndex == dataSource[sectionIndex].dates.count - 1 else { continue }
                height = y + side
            }
            cache.updateValue(items, forKey: sectionIndex)
        }
        self.height = height
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layout = super.layoutAttributesForItem(at: indexPath)
        let cachedLayout = cache[indexPath.section]?[indexPath.row]
        guard let frame = cachedLayout?.frame else { fatalError() }
        layout?.frame = frame
        return layout
    }
    
    override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        let `super` = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        guard elementKind == UICollectionView.elementKindSectionHeader else {  return `super` }
        `super`?.frame = cacheHeader[indexPath.section]?.frame ?? .zero
        return `super`
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutsСell = cache.reduce([]) { (result, item) -> [UICollectionViewLayoutAttributes] in
            return result + item.value.compactMap { (attribute) -> UICollectionViewLayoutAttributes? in
                guard rect.intersects(attribute.value.frame) else { return nil }
                return layoutAttributesForItem(at: attribute.value.indexPath)
            }
        }
        let layoutsHeaders = cacheHeader.compactMap { (attribute) -> UICollectionViewLayoutAttributes? in
            guard rect.intersects(attribute.value.frame) else { return nil }
            return layoutAttributesForSupplementaryView(ofKind: attribute.value.representedElementKind ?? "",
                                                        at: attribute.value.indexPath)
        }
        return layoutsСell + layoutsHeaders
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
            let date = dataSource[indexPath.section].dates[indexPath.row]
            let dayNumber = CalendarDateFormatter.dateDayNumberText(for: date)
            ($0 as? DateCollectionViewCell)?.configure(title: dayNumber)
            if let period = self.period {
                let state: CellState = period.contains(date: date) ? .single : .notSelected
                ($0 as? DateCollectionViewCell)?.configure(state: state)
            }
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: CalendarHeaderView.self),
            for: indexPath
        ).then {
            let month = CalendarDateFormatter.monthName(for: dataSource[indexPath.section].dates.first)
            ($0 as? CalendarHeaderView)?.configure(with: month)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CalendarDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let date = dataSource[indexPath.section].dates[indexPath.row]
        if let period = period {
            var startDate = date < period.startDate ? date : period.startDate
            var endDate = date > period.endDate ? date : period.endDate
            if date.isBetweeen(date: period.startDate, andDate: period.endDate) {
                let middle = period.startDate.daysBetweenDates(to: period.endDate) / 2
                let middleDate = period.endDate.dateByAddingDays(-middle)
                if date.isBetweeen(date: middleDate, andDate: period.endDate) {
                    endDate = date
                } else {
                    startDate = date
                }
            }
            self.period = Period(startDate: startDate, endDate: endDate)
        } else {
            period = Period(startDate: date, endDate: date)
        }

        UIView.performWithoutAnimation(collectionView.reloadData)
    }
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
        .init(width: collectionView.bounds.width, height: 100)
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
