
//
//  DetailHeadView.m
//  Code
//
//  Created by Ivan li on 2017/10/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "DetailHeadView.h"
#import "DetailModel.h"
#import "HKCustomMarginLabel.h"
  
#import <YYText/YYText.h>


@implementation DetailHeadView



- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    [self addSubview:self.totalLB];
    [self addSubview:self.categoryLabel];
    [self addSubview:self.learnedTimesLB];
    [self addSubview:self.difficultLB];
    // 练习题按钮
    [self addSubview:self.praticeBtn];
    // 分割线
    [self addSeparatorLines];
    
    [self addSubview:self.videoTimeLB];
    
    [self addSubview:self.certificateBgView];
    [self.certificateBgView addSubview:self.certificateIV];
    [self.certificateBgView addSubview:self.certificateLB];
    
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.learnedTimesLB.textColor = COLOR_7B8196_A8ABBE;
    self.difficultLB.textColor = COLOR_7B8196_A8ABBE;
}


- (void)addSeparatorLines {
    for (int i = 0; i < 2; i++) {
        UIView *separator = [[UIView alloc] init];
        // 设置分割线的tag
        separator.tag = 1 + i;
        separator.backgroundColor = COLOR_CFCFD9;
        [self addSubview:separator];
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.totalLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(PADDING_15);
        make.right.equalTo(self.mas_right).offset(-PADDING_15);
    }];
    
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(PADDING_15);
        make.height.mas_equalTo(20);
    }];
    
    [self.learnedTimesLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalLB.mas_bottom).offset(12);
        make.left.equalTo(self.totalLB);
    }];
    
    // 分割线0
    UIView *separator1 = [self viewWithTag:2];
    BOOL isPgc = ([self.detaiModel.video_type integerValue ] == HKVideoType_PGC);
    separator1.hidden = isPgc;

    
    BOOL isCompleted = _detaiModel.obtain_info.is_completed;
    BOOL isShowCert = _detaiModel.obtain_info.app_cert_show;

    
    [self.certificateBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalLB.mas_bottom).offset(12);
        make.left.equalTo(self.totalLB);
        make.height.mas_equalTo(20);
    }];
    
    if (isShowCert) {
        UIColor *fillColor = isCompleted ? COLOR_FFF0E6 :COLOR_ffffff;
        UIColor *strokeColor = isCompleted ? COLOR_FFF0E6 :COLOR_FF7820;
        [self.certificateBgView setRoundedCorners:UIRectCornerAllCorners radius:10 rect:self.certificateBgView.bounds lineWidth:1 strokeColor:strokeColor fillColor:fillColor];
    }
    
    
    [self.certificateIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.certificateBgView);
        make.left.equalTo(self.certificateBgView).offset(7);
    }];
    
    
    [self.certificateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.certificateBgView);
        if (isShowCert) {
            if (isCompleted) {
                make.left.equalTo(self.certificateBgView).offset(7);
            }else{
                make.left.equalTo(self.certificateIV.mas_right).offset(5);
            }
        }
        make.right.equalTo(self.certificateBgView).offset(-7);
    }];
    
    [self.difficultLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.totalLB.mas_bottom).offset(12);
        //make.left.equalTo(self.totalLB);
        make.centerY.equalTo(self.certificateBgView);
        if (isShowCert) {
            make.left.equalTo(self.certificateBgView.mas_right).offset(5);
        }else{
            make.left.equalTo(self.totalLB);
        }
    }];
    
    
    [separator1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.difficultLB.mas_right).offset(15/2);
        make.width.equalTo(@0.5);
        make.height.equalTo(@12);
        make.centerY.equalTo(self.difficultLB);
    }];
    
    [self.videoTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(separator1.mas_right).offset(15/2);
        make.centerY.equalTo(self.difficultLB);
    }];
    
    // 练习按钮
    [self.praticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (Iphone_47Inch_Width <= SCREEN_WIDTH) {
            // iPhone 6以上的尺寸
            make.right.equalTo(self.mas_right).offset(-PADDING_15);
            make.centerY.equalTo(self.difficultLB);
        } else {
            // iPhone 5s及其以下的尺寸
            //make.left.equalTo(self.learnedTimesLB);
            make.right.equalTo(self.mas_right).offset(-PADDING_15);
            make.top.equalTo(self.learnedTimesLB.mas_bottom).mas_offset(3.0);
        }
        make.height.mas_equalTo(20);
    }];
}



- (UILabel*)totalLB {
    
    if (!_totalLB) {
        _totalLB = [[UILabel alloc] init];
        _totalLB.font = HK_FONT_SYSTEM_WEIGHT(IS_IPHONE5S ? 16:17, UIFontWeightMedium);
        _totalLB.numberOfLines = 2;
        _totalLB.textColor = COLOR_27323F_EFEFF6;
    }
    return _totalLB;
}



- (HKCustomMarginLabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [HKCustomMarginLabel new];
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_3D8BFF dark:COLOR_3D8BFF];
        _categoryLabel.textColor = textColor;
        _categoryLabel.textAlignment = NSTextAlignmentCenter;
        _categoryLabel.backgroundColor = COLOR_EEF5FF;
        _categoryLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 13:12);
        _categoryLabel.layer.masksToBounds = YES;
        _categoryLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _categoryLabel;
}



- (UIButton *)praticeBtn {
    if (_praticeBtn == nil) {
        _praticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //_praticeBtn.size = IS_IPHONE5S? CGSizeMake(50, 17) : CGSizeMake(90, 17);
        _praticeBtn.titleLabel.font = HK_FONT_SYSTEM(12);
        
        [_praticeBtn setTitleColor:COLOR_27323F forState:UIControlStateNormal];
        [_praticeBtn setTitleColor:[COLOR_27323F colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];
        
        _praticeBtn.clipsToBounds = YES;
        _praticeBtn.layer.borderWidth = 0.5;
        _praticeBtn.layer.borderColor = COLOR_27323F.CGColor;
        _praticeBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 7.5, 3, 7.5);
        
        _praticeBtn.layer.cornerRadius = 10;
        
        [_praticeBtn addTarget:self action:@selector(praticeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_praticeBtn setEnlargeEdgeWithTop:10 right:0 bottom:10 left:0];
    }
    return _praticeBtn;
}

- (void)praticeBtnClick {
    NSLog(@"%s", __func__);
    
    
    showTipDialog(@"可以在目录中查看所有练习题哟~");
    
    //    !self.praticeBtnClickBlock? : self.praticeBtnClickBlock();
}



- (UILabel*)learnedTimesLB {
    
    if (!_learnedTimesLB) {
        _learnedTimesLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                        titleColor:COLOR_7B8196
                                         titleFont:nil
                                     titleAligment:NSTextAlignmentLeft];
        _learnedTimesLB.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
        [_learnedTimesLB sizeToFit];
    }
    return _learnedTimesLB;
}



- (UILabel*)difficultLB {
    
    if (!_difficultLB) {
        _difficultLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                     titleColor:COLOR_A8ABBE
                                      titleFont:nil
                                  titleAligment:NSTextAlignmentLeft];
        _difficultLB.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _difficultLB;
}


- (UILabel*)videoTimeLB {
    
    if (!_videoTimeLB) {
        _videoTimeLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                     titleColor:COLOR_A8ABBE
                                      titleFont:nil
                                  titleAligment:NSTextAlignmentLeft];
        _videoTimeLB.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _videoTimeLB;
}





- (UILabel*)certificateLB {
    if (!_certificateLB) {
        _certificateLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                     titleColor:COLOR_FF7820
                                      titleFont:@"13"
                                  titleAligment:NSTextAlignmentLeft];
        _certificateLB.backgroundColor = [UIColor clearColor];
    }
    return _certificateLB;
}


- (UIView*)certificateBgView {
    if (!_certificateBgView) {
        _certificateBgView  = [UIView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(certificateBgViewClick)];
        [_certificateBgView addGestureRecognizer:tap];
    }
    return _certificateBgView;
}



- (void)certificateBgViewClick {
    if (self.certificateBgViewClickBlock) {
        [MobClick event:detailpage_clickcertificate];
        self.certificateBgViewClickBlock(self.detaiModel);
    }
}


- (UIImageView*)certificateIV {
    if (!_certificateIV) {
        _certificateIV = [UIImageView new];
    }
    return _certificateIV;
}





- (void)setDetaiModel:(DetailModel *)detaiModel {
    
    _detaiModel = detaiModel;
    
    /// v2.17 隐藏
    //_learnedTimesLB.text = [NSString stringWithFormat:@"%@人学过",isEmpty(detaiModel.video_play) ?@"0" :detaiModel.video_play];
    _difficultLB.text = isEmpty(detaiModel.viedeo_difficulty) ?nil :[NSString stringWithFormat:@"难度等级：%@",detaiModel.viedeo_difficulty];
    
    // 练习
    [_praticeBtn setTitle:[NSString stringWithFormat:@"%lu节练习题", (unsigned long)detaiModel.salve_video_list.count] forState:UIControlStateNormal];
    _praticeBtn.hidden = !([self.detaiModel.video_type isEqualToString:@"1"] && self.detaiModel.salve_video_list.count > 0);
    // 第二条分割线
    UIView *separator2 = [self viewWithTag:2];
    separator2.hidden = _praticeBtn.hidden;
    
    [self setCategoryLbAndTotalLb:detaiModel];
    
    NSString *videoDuration = detaiModel.video_duration;
    self.videoTimeLB.hidden = isEmpty(videoDuration);
    self.videoTimeLB.text = [NSString stringWithFormat:@"时长: %@",isEmpty(videoDuration) ?@"" :videoDuration];
    
    if (detaiModel.obtain_info.app_cert_show) {
        BOOL is_completed = detaiModel.obtain_info.is_completed;
        _certificateIV.image = is_completed ? nil :imageName(@"ic_certificate_btn");
        _certificateLB.text = is_completed ?@"已获得证书" :@"课程证书";
    }
}


/** 设置 标签和标题 */
- (void)setCategoryLbAndTotalLb:(DetailModel *)detaiModel {
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//行间距
    paragraphStyle.firstLineHeadIndent = detaiModel.headSize.width;
    
    NSMutableAttributedString *attachment = nil;
    
    CGSize size = detaiModel.headSize;
    // [self stringSizeWithText:[NSString stringWithFormat:@"%@",detaiModel.class_name]];
    self.categoryLabel.size  = size;
    self.categoryLabel.layer.cornerRadius = _categoryLabel.height/2;
    self.categoryLabel.text = [NSString stringWithFormat:@"%@",detaiModel.class_name];
    
    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:self.categoryLabel contentMode:UIViewContentModeTop attachmentSize:self.categoryLabel.size alignToFont:self.categoryLabel.font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString: attachment];
    
    NSString *countString = [NSString stringWithFormat:@" %@", [NSString stringWithFormat:@"%@",isEmpty(detaiModel.video_titel) ?@"" :detaiModel.video_titel]];
    attachment = [[NSMutableAttributedString alloc] initWithString:countString attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    
    [attachment addAttribute:NSFontAttributeName value:self.totalLB.font range:NSMakeRange(0, countString.length)];
    [attachment addAttribute:NSForegroundColorAttributeName value:self.totalLB.textColor range:NSMakeRange(0, countString.length)];
    
    self.totalLB.attributedText = attachment;
    self.textHeight = detaiModel.headHeight;
}



@end








