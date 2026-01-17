

//
//HomeSuggestCell.m
//  Code
//
//  Created by Ivan li on 2017/9/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HomeSuggestCell.h"
#import "UIView+SNFoundation.h"
#import "VideoModel.h"
#import "UIView+SNFoundation.h"



@interface HomeSuggestCell()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, strong) UILabel *watchTimes;
// 图文标识
@property (nonatomic, strong) UIButton *imageTextBtn;

@end


@implementation HomeSuggestCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame ];
    if (self) {
        self.tb_hightedLigthedIndex = CollectionViewIndexContentViewBack;
        self.tb_hightedLigthedInset = UIEdgeInsetsMake(0, 0, 20, 2.5);
        [self createUI];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];

    [self.watchTimes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.bottom.equalTo(self).mas_offset(-15);
        make.left.equalTo(self.mas_left).mas_offset(5);
        make.right.equalTo(self.mas_right).mas_offset(-5);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.watchTimes);
        make.top.equalTo(self.goodImageView.mas_bottom).mas_offset(8);
    }];

    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(IS_IPAD ? 153.0 : 102.0);
        make.right.left.equalTo(self.watchTimes);
    }];

    
    [self.imageTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.goodImageView).mas_offset(-5.0);
        make.right.mas_equalTo(self.goodImageView).mas_offset(-3.0);
        make.size.mas_equalTo(CGSizeMake(IS_IPHONEMORE4_7INCH? 90 * 0.5 : 85 * 0.5, IS_IPHONEMORE4_7INCH? 40 * 0.5 : 34 * 0.5));
    }];
    
    
}


- (void)createUI {
    
    //self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.goodImageView];
    [self.contentView addSubview:self.watchTimes];
    [self.contentView addSubview:self.imageTextBtn];
}


- (UIImageView*)goodImageView {
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc]init];
        _goodImageView.clipsToBounds = YES;
        _goodImageView.layer.cornerRadius = 5.0;
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodImageView;
}

- (UIButton *)imageTextBtn {
    if (_imageTextBtn == nil) {
        _imageTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageTextBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONEMORE4_7INCH? 12.0 : 11.0];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateNormal];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateHighlighted];
        [_imageTextBtn setTitle:@"有图文" forState:UIControlStateNormal];
    }
    return _imageTextBtn;
}

- (UILabel*)watchTimes {
    if (!_watchTimes) {
        _watchTimes  = [[UILabel alloc] init];
        [_watchTimes setTextColor:[UIColor colorWithHexString:@"#A8ABBE"]];
        
        _watchTimes.textAlignment = NSTextAlignmentLeft;
        _watchTimes.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 13:12];
    }
    return _watchTimes;
}

- (UILabel*)textLabel {
    if (!_textLabel) {
        _textLabel  = [[UILabel alloc] init];
        [_textLabel setTextColor:COLOR_27323F_EFEFF6];
        
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        _textLabel.numberOfLines = 1;
        //_textLabel.text = @"PS-运动鞋";
    }
    return _textLabel;
}



- (void)setModel:(VideoModel *)model {
    NSLog(@"model.img_cover_url ===== %@",model.img_cover_url);
    _model = model;
    //_textLabel.text = model.video_titel;
    _textLabel.text = model.title;
    /// v2.17 隐藏
    self.watchTimes.text = [NSString stringWithFormat:@"%@次观看", model.video_play];
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
    self.imageTextBtn.hidden = !model.has_pictext;
}

@end














@interface HomeSuggestRightCell()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, strong) UILabel *watchTimes;

// 图文标识
@property (nonatomic, strong) UIButton *imageTextBtn;

@end


@implementation HomeSuggestRightCell



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame ];
    if (self) {
        self.tb_hightedLigthedInset = UIEdgeInsetsMake(0, 2.5, 20, 0);
        self.tb_hightedLigthedIndex = CollectionViewIndexContentViewBack;
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.watchTimes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.bottom.equalTo(self).mas_offset(-20);
        make.left.equalTo(self.mas_left).offset(7);
        make.right.equalTo(self.mas_right).offset(-14);
    }];
    
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.watchTimes);
        make.top.equalTo(self.goodImageView.mas_bottom).mas_offset(8);
    }];

    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(102);
        make.right.left.equalTo(self.watchTimes);
    }];
    
    
    [self.imageTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.goodImageView).mas_offset(-5.0);
        make.right.mas_equalTo(self.goodImageView).mas_offset(-3.0);
        make.size.mas_equalTo(CGSizeMake(IS_IPHONEMORE4_7INCH? 90 * 0.5 : 85 * 0.5, IS_IPHONEMORE4_7INCH? 40 * 0.5 : 34 * 0.5));
    }];
}


- (void)createUI {
    
    //self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.goodImageView];
    [self.contentView addSubview:self.watchTimes];
    [self.contentView addSubview:self.imageTextBtn];
}


- (UIButton *)imageTextBtn {
    if (_imageTextBtn == nil) {
        _imageTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageTextBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONEMORE4_7INCH? 12.0 : 11.0];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateNormal];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateHighlighted];
        [_imageTextBtn setTitle:@"有图文" forState:UIControlStateNormal];
    }
    return _imageTextBtn;
}

- (UIImageView*)goodImageView {
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc]init];
        _goodImageView.clipsToBounds = YES;
        _goodImageView.layer.cornerRadius = 5.0;
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodImageView;
}

- (UILabel*)textLabel {
    if (!_textLabel) {
        _textLabel  = [[UILabel alloc] init];
        [_textLabel setTextColor:COLOR_27323F_EFEFF6];
        
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        _textLabel.numberOfLines = 2;
        //_textLabel.text = @"PS-运动鞋";
    }
    return _textLabel;
}


- (UILabel*)watchTimes {
    if (!_watchTimes) {
        _watchTimes  = [[UILabel alloc] init];
        [_watchTimes setTextColor:[UIColor colorWithHexString:@"#A8ABBE"]];
        
        _watchTimes.textAlignment = NSTextAlignmentLeft;
        _watchTimes.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 13:12];
    }
    return _watchTimes;
}

- (void)setModel:(VideoModel *)model {
    
    _model = model;
    /// v2.17 隐藏
    //self.watchTimes.text = [NSString stringWithFormat:@"%@人观看", model.video_play];
    _textLabel.text = model.title;
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
    self.imageTextBtn.hidden = !model.has_pictext;
}


@end



@interface HomeSuggestiPadCell()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, strong) UILabel *watchTimes;

// 图文标识
@property (nonatomic, strong) UIButton *imageTextBtn;

@end


@implementation HomeSuggestiPadCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame ];
    if (self) {
        self.tb_hightedLigthedIndex = CollectionViewIndexContentViewBack;
        self.tb_hightedLigthedInset = UIEdgeInsetsMake(0, 0, 20, 2.5);
        [self createUI];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    WeakSelf;
    
    [self.watchTimes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.bottom.equalTo(weakSelf).mas_offset(-20);
        make.left.equalTo(weakSelf.mas_left).mas_offset(14);
        make.right.equalTo(weakSelf.mas_right).offset(0);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.watchTimes);
        make.right.equalTo(weakSelf.watchTimes);
        make.bottom.equalTo(weakSelf.watchTimes.mas_top).mas_offset(-6);
        make.height.mas_equalTo(PADDING_15);
    }];
    
    [_goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(0);
        make.right.left.equalTo(weakSelf.watchTimes);
        make.bottom.equalTo(weakSelf.textLabel.mas_top).offset(-8);
    }];
    
    [self.imageTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.goodImageView).mas_offset(-5.0);
        make.right.mas_equalTo(self.goodImageView).mas_offset(-3.0);
        make.size.mas_equalTo(CGSizeMake(IS_IPHONEMORE4_7INCH? 90 * 0.5 : 85 * 0.5, IS_IPHONEMORE4_7INCH? 40 * 0.5 : 34 * 0.5));
    }];
}


- (void)createUI {
    
    //self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.goodImageView];
    [self.contentView addSubview:self.watchTimes];
    [self.contentView addSubview:self.imageTextBtn];
}

- (UIImageView*)goodImageView {
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc]init];
        _goodImageView.clipsToBounds = YES;
        _goodImageView.layer.cornerRadius = 5.0;
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodImageView;
}

- (UIButton *)imageTextBtn {
    if (_imageTextBtn == nil) {
        _imageTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageTextBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONEMORE4_7INCH? 12.0 : 11.0];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateNormal];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateHighlighted];
        [_imageTextBtn setTitle:@"有图文" forState:UIControlStateNormal];
    }
    return _imageTextBtn;
}

- (UILabel*)watchTimes {
    if (!_watchTimes) {
        _watchTimes  = [[UILabel alloc] init];
        [_watchTimes setTextColor:[UIColor colorWithHexString:@"#A8ABBE"]];
        
        _watchTimes.textAlignment = NSTextAlignmentLeft;
        _watchTimes.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 13:12];
    }
    return _watchTimes;
}

- (UILabel*)textLabel {
    if (!_textLabel) {
        _textLabel  = [[UILabel alloc] init];
        [_textLabel setTextColor:COLOR_27323F_EFEFF6];
        
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        //_textLabel.text = @"PS-运动鞋";
    }
    return _textLabel;
}



- (void)setModel:(VideoModel *)model {
    _model = model;
    _textLabel.text = model.video_titel;
    _textLabel.text = model.title;
    /// v2.17 隐藏
    self.watchTimes.text = [NSString stringWithFormat:@"%@人观看", model.video_play];
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
    self.imageTextBtn.hidden = !model.has_pictext;
}

@end


@interface HomeSuggestiPadMiddleCell()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, strong) UILabel *watchTimes;

// 图文标识
@property (nonatomic, strong) UIButton *imageTextBtn;

@end

@implementation HomeSuggestiPadMiddleCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame ];
    if (self) {
        self.tb_hightedLigthedIndex = CollectionViewIndexContentViewBack;
        self.tb_hightedLigthedInset = UIEdgeInsetsMake(0, 0, 20, 2.5);
        [self createUI];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    WeakSelf;
    
    [self.watchTimes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.bottom.equalTo(weakSelf).mas_offset(-20);
        make.left.equalTo(weakSelf.mas_left).mas_offset(7);
        make.right.equalTo(weakSelf.mas_right).offset(-7);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.watchTimes);
        make.right.equalTo(weakSelf.watchTimes);
        make.bottom.equalTo(weakSelf.watchTimes.mas_top).mas_offset(-6);
        make.height.mas_equalTo(PADDING_15);
    }];
    
    [_goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(0);
        make.right.left.equalTo(weakSelf.watchTimes);
        make.bottom.equalTo(weakSelf.textLabel.mas_top).offset(-8);
    }];
    
    [self.imageTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.goodImageView).mas_offset(-5.0);
        make.right.mas_equalTo(self.goodImageView).mas_offset(-3.0);
        make.size.mas_equalTo(CGSizeMake(IS_IPHONEMORE4_7INCH? 90 * 0.5 : 85 * 0.5, IS_IPHONEMORE4_7INCH? 40 * 0.5 : 34 * 0.5));
    }];
}


- (void)createUI {
    
    //self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.goodImageView];
    [self.contentView addSubview:self.watchTimes];
    [self.contentView addSubview:self.imageTextBtn];
}

- (UIImageView*)goodImageView {
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc]init];
        _goodImageView.clipsToBounds = YES;
        _goodImageView.layer.cornerRadius = 5.0;
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodImageView;
}

- (UIButton *)imageTextBtn {
    if (_imageTextBtn == nil) {
        _imageTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageTextBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONEMORE4_7INCH? 12.0 : 11.0];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateNormal];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateHighlighted];
        [_imageTextBtn setTitle:@"有图文" forState:UIControlStateNormal];
    }
    return _imageTextBtn;
}

- (UILabel*)watchTimes {
    if (!_watchTimes) {
        _watchTimes  = [[UILabel alloc] init];
        [_watchTimes setTextColor:[UIColor colorWithHexString:@"#A8ABBE"]];
        
        _watchTimes.textAlignment = NSTextAlignmentLeft;
        _watchTimes.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 13:12];
    }
    return _watchTimes;
}

- (UILabel*)textLabel {
    if (!_textLabel) {
        _textLabel  = [[UILabel alloc] init];
        [_textLabel setTextColor:COLOR_27323F_EFEFF6];
        
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        //_textLabel.text = @"PS-运动鞋";
    }
    return _textLabel;
}



- (void)setModel:(VideoModel *)model {
    _model = model;
//    _textLabel.text = model.video_titel;
    _textLabel.text = model.title;

    /// v2.17 隐藏
    self.watchTimes.text = [NSString stringWithFormat:@"%@人观看", model.video_play];
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
    self.imageTextBtn.hidden = !model.has_pictext;
}

@end




@interface HomeSuggestiPadRightCell()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, strong) UILabel *watchTimes;

// 图文标识
@property (nonatomic, strong) UIButton *imageTextBtn;

@end


@implementation HomeSuggestiPadRightCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame ];
    if (self) {
        self.tb_hightedLigthedIndex = CollectionViewIndexContentViewBack;
        self.tb_hightedLigthedInset = UIEdgeInsetsMake(0, 0, 20, 2.5);
        [self createUI];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    WeakSelf;
    
    [self.watchTimes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.bottom.equalTo(weakSelf).mas_offset(-20);
        make.left.equalTo(weakSelf.mas_left).mas_offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(-14);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.watchTimes);
        make.right.equalTo(weakSelf.watchTimes);
        make.bottom.equalTo(weakSelf.watchTimes.mas_top).mas_offset(-6);
        make.height.mas_equalTo(PADDING_15);
    }];
    
    [_goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(0);
        make.right.left.equalTo(weakSelf.watchTimes);
        make.bottom.equalTo(weakSelf.textLabel.mas_top).offset(-8);
    }];
    
    [self.imageTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.goodImageView).mas_offset(-5.0);
        make.right.mas_equalTo(self.goodImageView).mas_offset(-3.0);
        make.size.mas_equalTo(CGSizeMake(IS_IPHONEMORE4_7INCH? 90 * 0.5 : 85 * 0.5, IS_IPHONEMORE4_7INCH? 40 * 0.5 : 34 * 0.5));
    }];
}


- (void)createUI {
    
    //self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.goodImageView];
    [self.contentView addSubview:self.watchTimes];
    [self.contentView addSubview:self.imageTextBtn];
}

- (UIButton *)imageTextBtn {
    if (_imageTextBtn == nil) {
        _imageTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageTextBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONEMORE4_7INCH? 12.0 : 11.0];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateNormal];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateHighlighted];
        [_imageTextBtn setTitle:@"有图文" forState:UIControlStateNormal];
    }
    return _imageTextBtn;
}

- (UIImageView*)goodImageView {
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc]init];
        _goodImageView.clipsToBounds = YES;
        _goodImageView.layer.cornerRadius = 5.0;
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodImageView;
}

- (UILabel*)watchTimes {
    if (!_watchTimes) {
        _watchTimes  = [[UILabel alloc] init];
        [_watchTimes setTextColor:[UIColor colorWithHexString:@"#A8ABBE"]];
        
        _watchTimes.textAlignment = NSTextAlignmentLeft;
        _watchTimes.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 13:12];
    }
    return _watchTimes;
}

- (UILabel*)textLabel {
    if (!_textLabel) {
        _textLabel  = [[UILabel alloc] init];
        [_textLabel setTextColor:COLOR_27323F_EFEFF6];
        
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        //_textLabel.text = @"PS-运动鞋";
    }
    return _textLabel;
}



- (void)setModel:(VideoModel *)model {
    _model = model;
//    _textLabel.text = model.video_titel;
    _textLabel.text = model.title;

    /// v2.17 隐藏
    self.watchTimes.text = [NSString stringWithFormat:@"%@人观看", model.video_play];
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
    self.imageTextBtn.hidden = !model.has_pictext;
}

@end
