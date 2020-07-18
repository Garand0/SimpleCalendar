//
//  CalendarHeaderView.swift
//  Calendar
//
//  Created by Maksim Vakula on 7/18/20.
//  Copyright © 2020 Maksim Vakula. All rights reserved.
//

import SnapKit
import UIKit

final class CalendarHeaderView: UICollectionReusableView {
    
    private let separatorView = UIView().then { $0.backgroundColor = .gray }
    
    private let monthLabel = UILabel().then { $0.text = "Январь" }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution  = .fillEqually
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        addSubviews()
        makeConstraints()
        
        let weekDayLabels = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"].map { str in
            UILabel().then { $0.text = str }
        }
        stackView.add { weekDayLabels }
    }
    
    private func addSubviews() {
        add {
            separatorView
            monthLabel
            stackView
        }
    }
    
    private func makeConstraints() {
        separatorView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(12)
        }
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView).offset(16)
            make.leading.greaterThanOrEqualTo(16)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel).offset(16)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(28)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && canImport(Combine)
import PreviewUIKit
import SwiftUI
@available(iOS 13.0, *) struct CalendarHeaderViewProvider: PreviewProvider {
    static var previews: some View {
        PreviewView {
            CalendarHeaderView(frame: CGRect(x: 0, y: 0, width: 375, height: 150))
        }.edgesIgnoringSafeArea(.all)
    }
}
#endif
