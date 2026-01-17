//
//  HKChooseTopicCell.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKChooseTopicCell.h"
#import "HKMonmentTypeModel.h"

@interface HKChooseTopicCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end



@implementation HKChooseTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    
}

-(void)setModel:(HKMonmentTagModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"#%@#",model.name];
}

@end
