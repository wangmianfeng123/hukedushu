//
//  HKCommentImgCell.m
//  Code
//
//  Created by Ivan li on 2020/12/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCommentImgCell.h"
#import "HKImgModel.h"
#import "UIView+HKLayer.h"

@interface HKCommentImgCell ()

@end

@implementation HKCommentImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imgV addCornerRadius:6];
    self.contentView.backgroundColor = COLOR_FFFFFF_333D48;
}

- (IBAction)deleteBtnClick {
    if (self.deleteBtnBlock) {
        self.deleteBtnBlock(self.imgV.image);
    }
    
}

@end
