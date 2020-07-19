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
    var cacheHeader: [Int: UICollectionViewLayoutAttributes] = [:]
    
    // MARK: - UICollectionViewFlowLayout
    
    override func prepare() {
        super.prepare()
        cache = [:]
        cacheHeader = [:]

        let side = itemSize.width
        var height = CGFloat.zero
        
        autoreleasepool {
            for sectionIndex in .zero ..< dataSource.count {
                let section = dataSource[sectionIndex]
                let sectionStart = section.startWeekDay.rawValue
                
                let header = UICollectionViewLayoutAttributes()
                header.frame = CGRect(x: .zero, y: height, width: collectionView?.bounds.width ?? .zero, height: 100)
                cacheHeader.updateValue(header, forKey: sectionIndex)
                
                height += 100
                
                var items: [Int: UICollectionViewLayoutAttributes] = [:]
                for itemIndex in .zero ..< dataSource[sectionIndex].dates.count {
                    // TODO: разобрать это говно
                    let position = ((sectionStart + itemIndex) % 7 == .zero) ? 7 : (sectionStart + itemIndex) % 7
                    let line = CGFloat((sectionStart + itemIndex - 1) / 7).rounded(.toNearestOrAwayFromZero)
                    
                    let x = side * CGFloat(position - 1)
                    let lineSpacingOffsets = CGFloat(max(.zero, line - 1) * 2)
                    let rowHeight = side * CGFloat(line)
                    let y = rowHeight + lineSpacingOffsets + height
                    
                    let layout = UICollectionViewLayoutAttributes()
                    
                    layout.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
                    items.updateValue(layout, forKey: itemIndex)
                    guard itemIndex == dataSource[sectionIndex].dates.count - 1 else { continue }
                    height = y + side
                }
                cache.updateValue(items, forKey: sectionIndex)
            }
        }
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
        super.layoutAttributesForElements(in: rect)?.compactMap { attribute in
            switch attribute.representedElementCategory {
            case .cell:
                return layoutAttributesForItem(at: attribute.indexPath)
            case .supplementaryView:
                return layoutAttributesForSupplementaryView(
                    ofKind: attribute.representedElementKind ?? "",
                    at: attribute.indexPath
                )
            default:
                return nil
            }
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: CalendarHeaderView.self),
            for: indexPath
        )
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
