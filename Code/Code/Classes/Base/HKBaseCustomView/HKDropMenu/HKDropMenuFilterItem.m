//
//  HKDropMenuFilterItem.m
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKDropMenuFilterItem.h"
#import "HKDropMenuModel.h"
#import "DCSpeedy.h"
#import "HKCustomMarginLabel.h"
#import "HKMyLiveModel.h"



@implementation HKDropMenuFilterItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.iconIV];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //self.title.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(3);
        make.top.equalTo(self.contentView).offset(-2);
    }];
}



- (void)tap:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenuFilterItem:dropMenuModel:)]) {
        [self.delegate dropMenuFilterItem:self dropMenuModel:self.dropMenuModel];
    }
}


- (HKCustomMarginLabel *)title {
    if (_title == nil) {
        _title = [[HKCustomMarginLabel alloc]init];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.userInteractionEnabled = YES;
        _title.font = HK_FONT_SYSTEM(13);
        _title.textInsets = UIEdgeInsetsMake(0, 9, 0, 9);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [_title addGestureRecognizer:tap];
    }
    return _title;
}



- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.image = imageName(@"ic_tag_selected_v2_9");
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
        _iconIV.hidden = YES;
    }
    return _iconIV;
}


- (void)setDropMenuModel:(HKDropMenuModel *)dropMenuModel {
    if ([dropMenuModel.tagName isEqualToString:@"技法类型"]) {
        NSLog(@"----");
    }
    _dropMenuModel = dropMenuModel;
    self.title.text = dropMenuModel.tagName;
    
    if (dropMenuModel.tagSeleted) {
        self.title.textColor = COLOR_FF7820;
        [DCSpeedy dc_chageControlCircularWith:self.title AndSetCornerRadius:15 SetBorderWidth:0 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
        
        //[self.title.layer setBackgroundColor:[[UIColor colorWithHexString:@"#FFF8F0"] CGColor]];
        self.title.backgroundColor = [UIColor colorWithHexString:@"#FFF8F0"];
        _iconIV.hidden = NO;
        
    }else{
//        self.title.textColor = COLOR_7B8196;
//        [DCSpeedy dc_chageControlCircularWith:self.title AndSetCornerRadius:15 SetBorderWidth:0 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
//        [self.title.layer setBackgroundColor:[COLOR_F8F9FA CGColor]];
        
        _iconIV.hidden = YES;
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_A8ABBE];

        [DCSpeedy dc_chageControlCircularWith:self.title AndSetCornerRadius:15 SetBorderWidth:0 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
        self.title.textColor = COLOR_7B8196_27323F;
        self.title.backgroundColor = bgColor;
    }
}

-(void)setModel:(HKClassListModel *)model{
    _model = model;
    self.title.userInteractionEnabled = NO;
    self.title.text = model.name;
    if (model.tagSeleted) {
        self.title.textColor = COLOR_FF7820;
        [DCSpeedy dc_chageControlCircularWith:self.title AndSetCornerRadius:15 SetBorderWidth:0 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];

        //[self.title.layer setBackgroundColor:[[UIColor colorWithHexString:@"#FFF8F0"] CGColor]];
        self.title.backgroundColor = [UIColor colorWithHexString:@"#FFF8F0"];
        _iconIV.hidden = NO;

    }else{
//        self.title.textColor = COLOR_7B8196;
//        [DCSpeedy dc_chageControlCircularWith:self.title AndSetCornerRadius:15 SetBorderWidth:0 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
//        [self.title.layer setBackgroundColor:[COLOR_F8F9FA CGColor]];

        _iconIV.hidden = YES;
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_A8ABBE];

        [DCSpeedy dc_chageControlCircularWith:self.title AndSetCornerRadius:15 SetBorderWidth:0 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
        self.title.textColor = COLOR_7B8196_27323F;
        self.title.backgroundColor = bgColor;
    }
}


@end
