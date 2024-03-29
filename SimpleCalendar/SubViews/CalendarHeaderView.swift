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
    
    private let monthLabel = UILabel().then { $0.textColor = .b1 }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution  = .fillEqually
    }

    override var reuseIdentifier: String? { String(describing: Self.self) }

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
            UILabel().then {
                $0.text = str
                $0.textColor = .b2
                $0.font = .systemFont(ofSize: 13)
                $0.textAlignment = .center
            }
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
            make.top.equalTo(separatorView.snp.bottom).offset(16)
            make.leading.greaterThanOrEqualTo(16)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(28)
        }
    }
}

// MARK: - Configurable

extension CalendarHeaderView {
    typealias ViewModel = String?
    
    func configure(with viewModel: ViewModel) {
        monthLabel.text = viewModel
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
