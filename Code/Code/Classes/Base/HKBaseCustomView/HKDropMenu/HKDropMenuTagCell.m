//
//  HKDropMenuTagCell.m
//  Code
//
//  Created by eon Z on 2022/4/29.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKDropMenuTagCell.h"
#import "HKDropMenuModel.h"

@interface HKDropMenuTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation HKDropMenuTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.title.textColor = COLOR_7B8196;
    self.imgView.hidden = YES;

}

- (void)setDropMenuModel:(HKDropMenuModel *)dropMenuModel {
    _dropMenuModel = dropMenuModel;
    self.title.text = dropMenuModel.title;
    self.title.textColor = dropMenuModel.cellSeleted ? COLOR_ff7c00 :COLOR_7B8196;
    self.imgView.hidden = !dropMenuModel.cellSeleted;
}

@end
