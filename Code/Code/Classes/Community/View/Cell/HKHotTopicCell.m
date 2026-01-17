//
//  HKHotTopicCell.m
//  Code
//
//  Created by Ivan li on 2021/1/19.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKHotTopicCell.h"
#import "HKMomentDetailModel.h"
#import "HKMonmentTypeModel.h"

@interface HKHotTopicCell ()
@property (weak, nonatomic) IBOutlet UIView *labBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labBgViewH;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *hotTitleLabel;
@property (nonatomic , strong)UIView * verticalLineView;
@end

@implementation HKHotTopicCell

- (UIView *)verticalLineView{
    if (_verticalLineView == nil) {
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _verticalLineView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
    [self.hotTitleLabel setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
}

-(void)setModel:(HKMomentDetailModel *)model{
    _model = model;
    CGFloat labH = 30;
    CGFloat labW = (SCREEN_WIDTH - 30 - 1 -20 ) * 0.5;
    //NSInteger labCount = 5;
    [self.labBgView removeAllSubviews];
    
    for (int i = 0; i < model.tagsArray.count; i ++) {//HKMonmentTagModel
        HKMonmentTagModel * tagModel = model.tagsArray[i];
        NSInteger row = i / 2;
        NSInteger columnCount = i % 2;
        
        CGFloat labX = (labW + 21) * columnCount;
        CGFloat labY = labH * row;
        
        UILabel * lab = [[UILabel alloc] init];
        lab.text = tagModel.name;
        lab.tag = i;
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont systemFontOfSize:15];
        lab.userInteractionEnabled = YES;
        lab.textColor = COLOR_27323F_EFEFF6;
        lab.frame = CGRectMake(labX, labY, labW, labH);
        [self.labBgView addSubview:lab];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [lab addGestureRecognizer:tap];
        
    }
    self.labBgViewH.constant = labH * ceil(model.tagsArray.count / 2.0);
    
    NSInteger row = model.tagsArray.count / 2;
    self.verticalLineView.frame = CGRectMake(labW+ 10, 10, 1, labH * row - 20);
    [self.labBgView addSubview:self.verticalLineView];
}


- (void)tapClick:(UITapGestureRecognizer *)tap{
    
    if (tap.view.tag <self.model.tagsArray.count) {
        HKMonmentTagModel * tagModel = self.model.tagsArray[tap.view.tag];
        if (self.didTagModelBlock) {
            self.didTagModelBlock(tagModel);
        }
    }    
}
@end
