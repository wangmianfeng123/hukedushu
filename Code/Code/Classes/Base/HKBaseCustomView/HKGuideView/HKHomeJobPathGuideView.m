//
//  HKHomeJobPathGuideView.m
//  Code
//
//  Created by Ivan li on 2019/6/18.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKHomeJobPathGuideView.h"
#import "AppDelegate.h"
#import "UIImage+Helper.h"
  
#import "CommonFunction.h"



@interface HKHomeJobPathGuideView()

/** 背景 */
@property(nonatomic,strong)UIImageView  *bgIV;

@property(nonatomic,strong)UIImageView  *arrowIV;

@property(nonatomic,strong)UILabel *titleLB;

@property(nonatomic,assign)NSInteger row;

@property(nonatomic,strong)NSIndexPath *indexPath;

@end


@implementation HKHomeJobPathGuideView


- (instancetype)initWithRect:(CGRect)frame row:(NSInteger)row  indexPath:(NSIndexPath *)indexPath {
    
    if (self = [super init]) {
        self.rect = frame;
        self.row = row;
        self.indexPath = indexPath;
        [self createUI];
    }
    return self;
}




- (void)createUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.arrowIV];
    [self addSubview:self.bgIV];
    [self.bgIV addSubview:self.titleLB];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeViewClick)];
    [self addGestureRecognizer:tap];

    [self makeConstraints];
}




- (void)makeConstraints {
    
    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.row) {
            make.top.equalTo(self);
        }else{
            make.bottom.equalTo(self);
        }
        
        switch (self.indexPath.row) {
            case 0:case 1:case 5:case 6:
                make.left.equalTo(self).offset(self.rect.size.width/2 - PADDING_5);
                break;
            case 4:case 3:case 8:case 9:
                if (IS_IPAD) {
                    make.right.equalTo(self).offset(-self.rect.size.width/2+PADDING_15);
                }else{
                    make.right.equalTo(self).offset(-self.rect.size.width/2+PADDING_5);
                }
                break;
            default:
                make.centerX.equalTo(self);
                break;
        }
    }];
    
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        if (self.row) {
            make.top.equalTo(self.arrowIV.mas_bottom).offset(-1);
            make.bottom.equalTo(self.mas_bottom);
        }else{
            make.bottom.equalTo(self.arrowIV.mas_top).offset(1);
            make.top.equalTo(self.mas_top);
        }
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgIV);
    }];
}



- (UIImageView*)arrowIV {
    if (!_arrowIV) {
        _arrowIV = [UIImageView new];
        _arrowIV.image = imageName(self.row ?@"ic_up_arrow" :@"ic_down_arrow");
        _arrowIV.userInteractionEnabled = YES;
    }
    return _arrowIV;
}



- (UIImageView*)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
        _bgIV.image = imageName(@"ic_redcolor_bg");
        _bgIV.userInteractionEnabled = YES;
        _bgIV.clipsToBounds = YES;
        _bgIV.layer.cornerRadius = 5;
    }
    return _bgIV;
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        NSString *title = @"职业路径全新上线，系统学习职业技能";
        _titleLB = [UILabel labelWithTitle:CGRectZero title:title titleColor:[UIColor whiteColor] titleFont:@"11" titleAligment:NSTextAlignmentCenter];
        _titleLB.font = HK_FONT_SYSTEM_WEIGHT(11, UIFontWeightMedium);
        _titleLB.userInteractionEnabled = YES;
    }
    return _titleLB;
}



- (void)closeViewClick {
    [HKNSUserDefaults setValue:@"2" forKey:Home_Job_Path_GuideView];
    [HKNSUserDefaults synchronize];
    [self removeGuidePage];
}


- (void)removeGuidePage {
    //移除手势
    for (UIGestureRecognizer *ges in self.gestureRecognizers) {
        [self removeGestureRecognizer:ges];
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}



- (void)dealloc {
    
}

@end










