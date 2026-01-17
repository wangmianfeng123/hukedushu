//
//  HKPrivilegeListCell.m
//  Code
//
//  Created by eon Z on 2021/11/9.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPrivilegeListCell.h"
#import "HKVipPrivilegeModel.h"

@interface HKPrivilegeListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation HKPrivilegeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLabel.textColor = [UIColor colorWithHexString:@"#B6967C"];
    self.descLabel.textColor = [UIColor colorWithHexString:@"#7B8196"];
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
}

-(void)setModel:(HKVipPrivilegeModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    self.descLabel.text = model.des;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.icon]] placeholderImage:HK_PlaceholderImage];
}

@end
