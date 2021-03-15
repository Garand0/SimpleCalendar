//
//  DateCollectionViewCell.swift
//  Calendar
//
//  Created by Maksim Vakula on 7/18/20.
//  Copyright © 2020 Maksim Vakula. All rights reserved.
//

import UIKit

enum CellState {
    case notSelected
    case singleSelection

    case selectionLeftEdge
    case selectionRightEdge

    case selectionStart
    case selectionMiddle
    case selectionMiddleOneDay
    case selectionEnd
}

final class DateCollectionViewCell: UICollectionViewCell {
    private let titleLable = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .b1
    }

    private let circleView = UIView()

    override var reuseIdentifier: String? { String(describing: Self.self) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        round()
    }

    func configure(title: String?) {
        titleLable.text = title
    }

    func configure(state: CellState) {
        switch state {
        case .notSelected:
            titleLable.textColor = .black
            circleView.backgroundColor = nil
            backgroundColor = nil
            contentView.backgroundColor = nil
            shape()
        case .singleSelection:
            titleLable.textColor = .white
            circleView.backgroundColor = .b5
            backgroundColor = nil
            contentView.backgroundColor = nil
        case .selectionLeftEdge:
            titleLable.textColor = .black
            circleView.backgroundColor = nil
            backgroundColor = nil
            contentView.backgroundColor = UIColor.b5.withAlphaComponent(0.12)
            roundLeft()
        case .selectionRightEdge:
            titleLable.textColor = .black
            circleView.backgroundColor = nil
            backgroundColor = nil
            contentView.backgroundColor = UIColor.b5.withAlphaComponent(0.12)
            roundRight()
        case .selectionStart:
            titleLable.textColor = .white
            circleView.backgroundColor = .b5
            backgroundColor = nil
            contentView.backgroundColor = UIColor.b5.withAlphaComponent(0.12)
            roundLeft()
        case .selectionMiddle:
            titleLable.textColor = .black
            circleView.backgroundColor = nil
            backgroundColor = UIColor.b5.withAlphaComponent(0.12)
            contentView.backgroundColor = nil
            shape()
        case .selectionMiddleOneDay:
            titleLable.textColor = .black
            circleView.backgroundColor = nil
            backgroundColor = UIColor.b5.withAlphaComponent(0.12)
            contentView.backgroundColor = nil
            roundAll()
        case .selectionEnd:
            titleLable.textColor = .white
            circleView.backgroundColor = .b5
            backgroundColor = nil
            contentView.backgroundColor = UIColor.b5.withAlphaComponent(0.12)
            roundRight()
        }
    }

    // MARK: - Private Methods
    
    private func commonInit() {
        backgroundColor = .white
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.add(insets: .zero) {
            circleView.add(insets: .zero) {
                titleLable
            }
        }
    }
    
    private func makeConstraints() {}
}

extension DateCollectionViewCell {
    private func round() {
        let radius = frame.height / 2
        contentView.layer.cornerRadius = radius
        circleView.layer.cornerRadius = radius
    }

    private func roundLeft() {
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    private func roundRight() {
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    private func roundAll() {
        contentView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
    }
    
    private func shape() {
        contentView.layer.maskedCorners = []
    }
}
