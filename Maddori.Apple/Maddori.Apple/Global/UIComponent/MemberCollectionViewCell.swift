//
//  MemberCollectionViewCell.swift
//  Maddori.Apple
//
//  Created by 김유나 on 2022/10/19.
//

import UIKit

import SnapKit

final class MemberCollectionViewCell: BaseCollectionViewCell {
    
    private enum Size {
        static let width = 135
        static let height = 60
        static let frame = CGRect(x: 0, y: 0, width: Size.width, height: Size.height)
    }
    
    // MARK: - property
    
    let memberLabel: UILabel = {
        let label = UILabel()
        label.font = .label1
        label.textColor = .black100
        label.backgroundColor = .white300
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.textAlignment = .center
        return label
    }()
    let memberShadow: UIView = {
        let view = UIView()
        view.frame = Size.frame
        view.clipsToBounds = false
        return view
    }()
    let memberShadowLayer: CALayer = {
        let layer = CALayer()
        let shadowPath0 = UIBezierPath(roundedRect: Size.frame, cornerRadius: 8)
        layer.shadowPath = shadowPath0.cgPath
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.bounds = Size.frame
        return layer
    }()
    
    // MARK: - lifecycle
    
    override func render() {
        self.addSubview(memberShadow)
        memberShadow.snp.makeConstraints {
            $0.width.equalTo(Size.width)
            $0.height.equalTo(Size.height)
        }
        
        memberShadow.layer.addSublayer(memberShadowLayer)
        memberShadowLayer.position = memberShadow.center
        
        self.addSubview(memberLabel)
        memberLabel.snp.makeConstraints {
            $0.width.equalTo(Size.width)
            $0.height.equalTo(Size.height)
        }
    }
}
