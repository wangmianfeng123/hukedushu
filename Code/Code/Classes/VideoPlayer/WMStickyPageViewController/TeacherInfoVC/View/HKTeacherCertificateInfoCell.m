//
//  HKTeacherCertificateInfoCell.m
//  Code
//
//  Created by ivan on 2020/8/28.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKTeacherCertificateInfoCell.h"




@implementation HKTeacherCertificateInfoView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {

    [self addSubview:self.iconIV];
    [self addSubview:self.themeLB];
}



- (void)layoutSubviews {
    [super layoutSubviews];

    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];

    [self.themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(7);
        make.right.lessThanOrEqualTo(self);
        make.top.height.equalTo(self);
    }];
}


- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.image = imageName(@"ic_certificate_info");
        [_iconIV sizeToFit];
    }
    return _iconIV;
}


- (UILabel *)themeLB {
    if (!_themeLB) {
        _themeLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"15" titleAligment:0];
    }
    return _themeLB;
}


- (void)setTheme:(NSString *)theme {
    _theme = theme;
    self.themeLB.text = [NSString stringWithFormat:@"%@",theme];
}


@end




@implementation HKTeacherCertificateInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
        
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.smallBgView];
    
    [self.bgView addSubview:self.themeLB];
    
    [self.bgView addSubview:self.leftLine];
    [self.bgView addSubview:self.rightLine];
    
    [self.bgView addSubview:self.leftIconIV];
    [self.bgView addSubview:self.rightIconIV];
    [self.smallBgView addSubview:self.arrowIconIV];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(1, 15, 1, 15));
    }];
    
    [self.themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(10);
    }];
    
    [self.leftIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.themeLB.mas_left).offset(-5);
        make.centerY.equalTo(self.themeLB);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.themeLB.mas_left).offset(-30);
        make.centerY.equalTo(self.themeLB);
        make.left.equalTo(self.bgView).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.rightIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeLB.mas_right).offset(5);
        make.centerY.equalTo(self.themeLB);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeLB.mas_right).offset(30);
        make.centerY.equalTo(self.themeLB);
        make.right.equalTo(self.bgView).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.arrowIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self.smallBgView);
    }];
    
    
    [self.smallBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.top.equalTo(self.bgView).offset(37);
        make.right.equalTo(self.bgView).offset(-10);
        
        CGFloat H = [self smallBgViewHeight];
        make.height.mas_equalTo(H);
    }];
    
        
    [self.viewArr enumerateObjectsUsingBlock:^(HKTeacherCertificateInfoView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat H = 15;
        CGFloat topMargin = 20;
        CGFloat space_Y = 20;
        
        CGFloat Y = 0;
        if (0 == idx) {
            Y = idx*H + topMargin;
        }else{
            Y = idx*H + idx*space_Y + topMargin;
        }
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.smallBgView).offset(Y);
            make.left.equalTo(self.smallBgView).offset(12);
            make.right.lessThanOrEqualTo(self.smallBgView);
            make.height.mas_equalTo(H);
        }];
    }];
}



- (UIImageView*)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        UIColor *color2 = [UIColor colorWithHexString:@"#F3D6C0"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFF0DF"];
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(320, 50) gradientColors:@[(id)color1,(id)color2] percentage:@[@(0.1),@(1)] gradientType:GradientFromLeftToRight];
        _bgView.image = image;
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
}


- (UILabel*)leftLine {
    if (!_leftLine) {
        _leftLine = [UILabel new];
        _leftLine.backgroundColor = [UIColor colorWithHexString:@"#B28861"];
    }
    return _leftLine;
}


- (UILabel*)rightLine {
    if (!_rightLine) {
        _rightLine = [UILabel new];
        _rightLine.backgroundColor = [UIColor colorWithHexString:@"#B28861"];
    }
    return _rightLine;
}


- (UILabel*)themeLB {
    if (!_themeLB) {
        _themeLB = [UILabel labelWithTitle:CGRectZero title:@"课程证书" titleColor:COLOR_9D7351 titleFont:nil titleAligment:1];
        _themeLB.font = HK_FONT_SYSTEM_BOLD(17);
        [_themeLB sizeToFit];
    }
    return _themeLB;
}


- (UIImageView*)leftIconIV {
    if (!_leftIconIV) {
        _leftIconIV = [UIImageView new];
        _leftIconIV.image = imageName(@"img_certificate_left");
        [_leftIconIV sizeToFit];
    }
    return _leftIconIV;
}



- (UIImageView*)rightIconIV {
    if (!_rightIconIV) {
        _rightIconIV = [UIImageView new];
        _rightIconIV.image = imageName(@"img_certificate_right");
        [_rightIconIV sizeToFit];
    }
    return _rightIconIV;
}


- (UIImageView*)arrowIconIV {
    if (!_arrowIconIV) {
        _arrowIconIV = [UIImageView new];
        _arrowIconIV.image = imageName(@"ic_certificate_down");
        [_arrowIconIV sizeToFit];
    }
    return _arrowIconIV;
}





- (UIView*)smallBgView {
    if (!_smallBgView) {
        _smallBgView = [UIView new];
        _smallBgView.backgroundColor = [COLOR_ffffff colorWithAlphaComponent:0.6];
    }
    return _smallBgView;
}




- (void)setModel:(DetailModel *)model {
    _model = model;
    
    [model.obtain_info.app_obtain enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger tag = 100 +idx;
        if (nil == [self.smallBgView viewWithTag:tag]) {
            HKTeacherCertificateInfoView *certificateView = [[HKTeacherCertificateInfoView alloc]init];
            certificateView.theme = obj;
            certificateView.tag = 100 +idx;
            
            [self.viewArr addObject:certificateView];
        }
    }];
    
    [self.viewArr enumerateObjectsUsingBlock:^(HKTeacherCertificateInfoView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger tag = 100 +idx;
        if (nil == [self.smallBgView viewWithTag:tag]) {
            [self.smallBgView addSubview:obj];
        }
    }];
}


- (NSMutableArray <HKTeacherCertificateInfoView*>*)viewArr {
    if (!_viewArr) {
        _viewArr = [NSMutableArray array];
    }
    return _viewArr;
}




- (CGFloat)smallBgViewHeight {
    
    NSInteger count = self.model.obtain_info.app_obtain.count;
    CGFloat space = (count>1) ?(count - 1)*20 :0;
    CGFloat height = (40+ count*15 + space);
    return height;
}

- (CGSize)sizeThatFits:(CGSize)size {

    CGFloat totalHeight = 37+10+2;
    totalHeight += [self smallBgViewHeight];
    return CGSizeMake(size.width, totalHeight);
}



@end
