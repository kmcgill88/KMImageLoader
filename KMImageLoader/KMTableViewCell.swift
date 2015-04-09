//
//  KMTableViewCell.swift
//
//  Created by Kevin McGill on 1/17/15.
//  Copyright (c) 2015 Kevin McGill. All rights reserved.
//

import Foundation
import UIKit

class KMTableViewCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var theImageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
       theImageView.frame = CGRectMake(5, 5, 100.0, 100.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        theImageView.image = UIImage(named: "loading-placeholder-clear.png")
        titleLabel.text = ""
        subTitleLabel.text = ""
    }
}