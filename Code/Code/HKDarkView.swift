//
//  HKDarkView.swift
//  Code
//
//  Created by ivan on 2020/5/15.
//  Copyright © 2020 pg. All rights reserved.
//

import UIKit
class HKDarkView: UIView {
    
    override init(frame: CGRect) {
        DarkModeManager.setup();
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

