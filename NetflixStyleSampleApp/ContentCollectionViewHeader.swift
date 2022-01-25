//
//  ContentCollectionViewHeader.swift
//  NetflixStyleSampleApp
//
//  Created by UAPMobile on 2022/01/25.
//

import UIKit

class ContentCollectionViewHeader: UICollectionReusableView {
    
    let sectionNameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        self.sectionNameLabel.textColor = .white
        self.sectionNameLabel.sizeToFit()
        
        self.addSubview(self.sectionNameLabel)
        
        self.sectionNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.leading.equalToSuperview().offset(10)
        }
    }
    
}
