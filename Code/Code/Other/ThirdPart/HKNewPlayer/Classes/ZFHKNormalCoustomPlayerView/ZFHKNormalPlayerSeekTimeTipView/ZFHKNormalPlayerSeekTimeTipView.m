//
//  ZFHKNormalPlayerSeekTimeTipView.m
//  Code
//
//  Created by Ivan li on 2019/3/15.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "ZFHKNormalPlayerSeekTimeTipView.h"
#import "HKLineLabel.h"
#import "HKPermissionVideoModel.h"


@implementation ZFHKNormalPlayerSeekTimeTipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}


- (void)setUp {
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = PADDING_5;
    self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.6];    
    [self addSubview:self.lineLabel];
    [self addSubview:self.tipLabel];
    [self addSubview:self.closeBtn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 3.5)), dispatch_get_main_queue(), ^{
        [self removeView];
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(PADDING_10);
        make.top.equalTo(self).offset(9);
        make.size.mas_equalTo(CGSizeMake(25/2, 25/2));
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_closeBtn.mas_right).offset(PADDING_5);
        make.top.equalTo(self).offset(8);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tipLabel.mas_right).offset(PADDING_5);
        make.top.equalTo(_tipLabel);
    }];
}




- (UILabel*)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [UILabel new];

        _lineLabel.userInteractionEnabled = YES;
        _lineLabel.font = HK_FONT_SYSTEM(12);
        _lineLabel.textColor = COLOR_FFD305;
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textClickEvent:)];
        [_lineLabel addGestureRecognizer:tapGest];
    }
    return _lineLabel;
}


- (UILabel*)tipLabel {
    if (!_tipLabel) {
        //@"上次观看至18，正在续播。"
        _tipLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_ffffff titleFont:@"12" titleAligment:0];
        _tipLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipLabelClickEvent:)];
        [_tipLabel addGestureRecognizer:tapGest];
    }
    return _tipLabel;
}


- (UIButton*)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:imageName(@"hkplayer_fork_white") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setHKEnlargeEdge:15];
    }
    return _closeBtn;
}


- (void)textClickEvent:(id)sender {
    //!self.lineTextClickBlock? : self.lineTextClickBlock(@"ddd");
    if (self.delegate && [self.delegate respondsToSelector:@selector(hkPlayTimeTipAction:)]) {
        
        [MobClick event:UM_RECORD_DETAIL_PAGE_MEMORY_NEXT];
        [self.delegate hkPlayTimeTipAction:self.model];
        [self removeView];
    }
}


- (void)tipLabelClickEvent:(id)sender {
    [self removeView];
}


- (void)setPlayerSeekTime:(NSInteger)playerSeekTime {
    
    NSInteger seekTime = playerSeekTime;
    if (seekTime >0) {
        seekTime += 1;
        NSString *time = nil;
        if (seekTime >59) {
            NSInteger min = seekTime/60;
            NSInteger sec = seekTime%60;
            if (sec>0) {
                time = [NSString stringWithFormat:@"上次观看至%ld分%ld秒，正在续播。",min,sec];
            }else {
                time = [NSString stringWithFormat:@"上次观看至%ld分，正在续播。",min];
            }
        }else{
            time = [NSString stringWithFormat:@"上次观看至%ld秒，正在续播。",seekTime];
        }
        _tipLabel.text = time;
        // 网络视频才可以 跳转下一节 ,从下载列表来的 不能跳转
        if ([self.model.video_down_status isEqualToString:@"1"]) {
            NSString *nextId = self.model.next_video_info.video_id;
            if (!isEmpty(nextId) && ![nextId isEqualToString:@"0"]) {
                // 设置下横线
                NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"跳转下一节" attributes:attribtDic];
                //_lineLabel.attributedText = attrString;
            }
        }
    }
}




- (void)removeView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)dealloc {
    //NSLog(@"HKPlayTimeTipView -- dealloc");
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self removeView];
}






@end
