//
//  CalendarView.swift
//  Calendar
//
//  Created by Maksim Vakula on 7/18/20.
//  Copyright © 2020 Maksim Vakula. All rights reserved.
//

import UIKit

final class CalendarView: UIView {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: calendarDataSource).then {
        $0.dataSource = calendarDataSource
        $0.delegate = calendarDataSource
        $0.backgroundColor = .yellow
        $0.register(
            DateCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: DateCollectionViewCell.self)
        )
        $0.register(
            CalendarHeaderView.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: String(describing: CalendarHeaderView.self)
        )
    }
    
    private lazy var calendarDataSource = CalendarDataSource().then {
        $0.minimumInteritemSpacing = .zero
        $0.minimumLineSpacing = 2
    }
    
    // MARK: - Private Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        commonInit()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func commonInit() {
        addSubviews()
        let dataSet = CalendarModelFactory.make(
            startDate: Date(),
            endDate: Date().dateByAddingMonths(15)
        )
        calendarDataSource.dataSource = dataSet
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func addSubviews() {
        add(insets: UIEdgeInsets(top: 32, left: 12, bottom: 12, right: 12)) { collectionView }
    }
}
