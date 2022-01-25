//
//  ContentCollectionViewCell.swift
//  NetflixStyleSampleApp
//
//  Created by UAPMobile on 2022/01/25.
//

import UIKit
import SnapKit

class ContentCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true
        
        self.imageView.contentMode = .scaleAspectFill
        contentView.addSubview(self.imageView)  // storyboard 에서 + 하는 것과 같은
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()  // superview인 contentView에 딱 맞게
        }
    }
}
