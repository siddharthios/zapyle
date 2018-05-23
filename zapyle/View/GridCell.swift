//
//  GridCell.swift
//  zapyle
//
//  Created by Siddharth Kumar on 19/05/18.
//  Copyright © 2018 Siddharth Kumar. All rights reserved.
//


import UIKit

class GridCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var brandLabel = UILabel()
    var titleLabel = UILabel()
    var priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        contentView.addSubview(imageView)
        
        brandLabel = UILabel()
        brandLabel.textAlignment = .left
        brandLabel.numberOfLines = 0
        brandLabel.textColor=UIColor.black
        brandLabel.font=UIFont.boldSystemFont(ofSize: 16)
        brandLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(brandLabel)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines=0
        titleLabel.textColor=UIColor.gray
        titleLabel.font=UIFont.systemFont(ofSize: 12)
        titleLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(titleLabel)
        
        
        priceLabel = UILabel()
        priceLabel.textAlignment = .left
        priceLabel.textColor=UIColor.black
        priceLabel.font=UIFont.boldSystemFont(ofSize: 14)
        priceLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(priceLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = imageView.frame
        frame.size.height = self.frame.size.height*0.75
        frame.size.width = self.frame.size.width*0.95
        frame.origin.x = self.frame.size.width*0.025
        frame.origin.y = 0
        imageView.frame = frame
        
        var labelFrame = imageView.frame
        labelFrame.size.height = self.frame.size.height*0.04
        labelFrame.size.width = self.frame.size.width*0.9
        labelFrame.origin.x = self.frame.size.width*0.05
        labelFrame.origin.y = self.frame.size.height*0.78
        brandLabel.frame = labelFrame
        
        var labelFrame2 = imageView.frame
        labelFrame2.size.height = self.frame.size.height*0.07
        labelFrame2.size.width = self.frame.size.width*0.9
        labelFrame2.origin.x = self.frame.size.width*0.05
        labelFrame2.origin.y = self.frame.size.height*0.825
        titleLabel.frame = labelFrame2
        
        var labelFrame3 = imageView.frame
        labelFrame3.size.height = self.frame.size.height*0.04
        labelFrame3.size.width = self.frame.size.width*0.9
        labelFrame3.origin.x = self.frame.size.width*0.05
        labelFrame3.origin.y = self.frame.size.height*0.9
        priceLabel.frame = labelFrame3
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
