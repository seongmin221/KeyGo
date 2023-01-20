//
//  JoinReflectionButton.swift
//  Maddori.Apple
//
//  Created by 이성민 on 2022/11/21.
//

import UIKit

import SnapKit

final class JoinReflectionButton: UIView {
    
    var buttonAction: (() -> ())?
    
    // MARK: - property
    
    private let joinButton = UIButton()
    private lazy var reflectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .label2
        return label
    }()
    private let reflectionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        return label
    }()
    private let calendarImageView = UIImageView()
    
    // MARK: - life cycle
    
    init() {
        super.init(frame: .zero)
        render()
        setupJoinButtonAction()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func render() {
        self.addSubview(joinButton)
        joinButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        joinButton.addSubview(reflectionTitleLabel)
        reflectionTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.top.equalToSuperview().inset(18)
        }
        
        joinButton.addSubview(reflectionDescriptionLabel)
        reflectionDescriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.top.equalTo(reflectionTitleLabel.snp.bottom).offset(6)
        }
        
        joinButton.addSubview(calendarImageView)
        calendarImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.width.equalTo(37)
            $0.height.equalTo(39)
        }
    }
    
    // MARK: - func
    
    private func setupJoinButtonAction() {
        let action = UIAction { [weak self] _ in
            self?.buttonAction?()
        }
        joinButton.addAction(action, for: .touchUpInside)
    }
    
//    private func setJoinReflectionShadow() {
//
//    }
    
    func setupAttribute(reflectionStatus: ReflectionStatus, title: String, date: String) {
        switch reflectionStatus {
        case .SettingRequired, .Done:
            reflectionTitleLabel.text = TextLiteral.reflectionTitleLabelSettingRequired
            reflectionTitleLabel.textColor = .gray600
            reflectionDescriptionLabel.text = TextLiteral.reflectionDescriptionLabelSettingRequired
            reflectionDescriptionLabel.textColor = .gray500
            calendarImageView.image = ImageLiterals.imgEmptyCalendar
        case .Before:
            reflectionTitleLabel.text = title
            reflectionTitleLabel.textColor = .gray600
            reflectionDescriptionLabel.text = date.formatDateString(to: "M월 d일 (EEE) HH:mm")
            reflectionDescriptionLabel.textColor = .gray500
            calendarImageView.image = ImageLiterals.imgCalendar
        case .Progressing:
            reflectionTitleLabel.text = TextLiteral.reflectionTitleLabelProgressing
            reflectionTitleLabel.textColor = .white100
            reflectionDescriptionLabel.text = TextLiteral.reflectionDescriptionLabelProgressing
            reflectionDescriptionLabel.textColor = .white100
            calendarImageView.image = ImageLiterals.imgYellowCalendar
        }
    }
}
