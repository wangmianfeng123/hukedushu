//
//  HKSystemNoticeCell.m
//  Code
//
//  Created by Ivan li on 2021/4/2.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKSystemNoticeCell.h"
#import "HKNotiTabModel.h"

@interface HKSystemNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation HKSystemNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.desLabel.textColor = COLOR_7B8196_A8ABBE;
    self.titleLabel.textColor = COLOR_27323F_FFFFFF;
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
    self.lineView.backgroundColor =COLOR_F8F9FA_333D48;
}

-(void)setModel:(HKSystemNotiMsgModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.desLabel.text = model.sub_title;
    self.timeLabel.text = model.created_at;
}
@end
