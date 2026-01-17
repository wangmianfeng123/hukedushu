
//
//  HKTeacherSuggestCourseCell.m
//  Code
//
//  Created by Ivan li on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKTeacherSuggestCourseCell.h"
#import "VideoModel.h"
#import "HKCoverBaseIV.h"


@implementation HKTeacherSuggestCourseCell


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
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).mas_offset(-15);
        make.height.mas_equalTo(PADDING_15);
    }];
    
    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.left.equalTo(self.contentView);
        make.bottom.equalTo(self.textLabel.mas_top).offset(-8);
    }];
}


- (void)createUI {
    //self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.goodImageView];
}


- (HKCoverBaseIV*)goodImageView {
    if (!_goodImageView) {
        _goodImageView = [[HKCoverBaseIV alloc]init];
        _goodImageView.clipsToBounds = YES;
        _goodImageView.layer.cornerRadius = 5.0;
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodImageView;
}



- (UILabel*)textLabel {
    if (!_textLabel) {
        _textLabel  = [UILabel new];
        [_textLabel setTextColor:COLOR_27323F_EFEFF6];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
    }
    return _textLabel;
}



- (void)setModel:(VideoModel *)model {
    _model = model;
    _textLabel.text = model.video_titel;
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
    // 图文
    self.goodImageView.hasPictext = !model.has_pictext;
}

@end

