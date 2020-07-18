//
//  DateCollectionViewCell.swift
//  Calendar
//
//  Created by Maksim Vakula on 7/18/20.
//  Copyright © 2020 Maksim Vakula. All rights reserved.
//

import UIKit

final class DateCollectionViewCell: UICollectionViewCell {
    
    private let titleLable = UILabel().then { $0.textAlignment = .center }
    
    override var reuseIdentifier: String? { String(describing: Self.self) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func configure(title: String) {
        titleLable.text = title
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        add(insets: .zero) {
            titleLable
        }
    }
    
    private func makeConstraints() {}
}
