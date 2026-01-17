//
//  HKVIPadsCell.m
//  Code
//
//  Created by eon Z on 2021/11/10.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKVIPadsCell.h"

@interface HKVIPadsCell ()


@end

@implementation HKVIPadsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick)];
    self.adImgV.userInteractionEnabled = YES;
    [self.adImgV addGestureRecognizer:tap];
    
}

- (void)imgTapClick{
    if (self.tapClickBlock) {
        self.tapClickBlock();
    }
}
@end
