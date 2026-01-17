//
//  HKBookCommentThemeCell.m
//  Code
//
//  Created by Ivan li on 2019/8/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookCommentTopCell.h"
#import "HKShortVideoCommentModel.h"
#import "DetailModel.h"
#import "CourseStarView.h"
#import "NewCommentModel.h"
#import "UIView+SNFoundation.h"
#import "HKBookCommentModel.h"

@interface HKBookCommentTopCell()
/// 用户头像
@property(nonatomic,strong)UIImageView *iconIV;
/// 用户昵称
@property(nonatomic,strong)UILabel *nameLabel;
/// 评论
@property(nonatomic,strong)UILabel *commentLabel;
/// 封面
@property(nonatomic,strong)UIImageView *coverIV;
/// 星星
@property(nonatomic,strong)CourseStarView *courseStarView;
/// 时间
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong) UITapGestureRecognizer  *singleTapGuesture; // 点击手势
/** vip 图标 */
@property(nonatomic,strong)UIImageView *vipImageView;
/// 精选标签
@property(nonatomic,strong)UILabel *chosenLB;

@end

@implementation HKBookCommentTopCell



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.commentLabel];
    
    [self.contentView addSubview:self.courseStarView];
    [self.contentView addSubview:self.coverIV];
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.vipImageView];
    [self.contentView addSubview:self.chosenLB];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(PADDING_10);
        make.centerY.equalTo(self.iconIV);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(4);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self.chosenLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vipImageView.mas_right).offset(4);
        make.centerY.equalTo(self.nameLabel);
        make.size.mas_equalTo(self.model.is_excellent ?CGSizeMake(39, 15) :CGSizeZero);
    }];
    
    [self.courseStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.lessThanOrEqualTo(self.chosenLB.mas_right).offset(4);
        make.centerY.equalTo(self.nameLabel);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(80);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING_15);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.iconIV.mas_bottom).offset(PADDING_10);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
    
    [self.coverIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLabel.mas_bottom).offset(12);
        make.left.equalTo(self.commentLabel);
        make.size.mas_equalTo(CGSizeMake(110, isEmpty(self.model.image_url) ?0 :110));
    }];
    

}



- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.layer.masksToBounds = YES;
        _iconIV.layer.cornerRadius = 20;
        _iconIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userImageViewClick:)];
        [_iconIV addGestureRecognizer:tap];
    }
    return _iconIV;
}


- (void)userImageViewClick:(UITapGestureRecognizer*)gesture  {
    if ([self.delegate respondsToSelector:@selector(bookCommentTopCell:headViewuserImageViewClick:model:)]) {
        [self.delegate bookCommentTopCell:self headViewuserImageViewClick:0 model:self.model];
    }
}



- (UIImageView*)coverIV {
    if (!_coverIV) {
        _coverIV = [UIImageView new];
        _coverIV.userInteractionEnabled = YES;
        _coverIV.layer.masksToBounds = YES;
        _coverIV.layer.cornerRadius = 5;
        [_coverIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCommeImage:)]];
    }
    return _coverIV;
}


- (void)clickCommeImage:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(bookCommentTopCell:headViewCommentImageViewClick:model:)]) {
        [self.delegate bookCommentTopCell:self headViewCommentImageViewClick:0 model:self.model];
    }
}


- (UILabel*)nameLabel {
    
    if (!_nameLabel) {
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_2D3949 dark:COLOR_EFEFF6];
        _nameLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                    titleColor:textColor
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _nameLabel.font = HK_FONT_SYSTEM_WEIGHT(14,UIFontWeightSemibold);
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}



- (CourseStarView*)courseStarView {
    if (!_courseStarView) {
        _courseStarView = [[CourseStarView alloc]initWithFrame:CGRectZero];
    }
    return _courseStarView;
}


- (UILabel*)commentLabel {
    if (!_commentLabel) {
        _commentLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                         titleColor:COLOR_27323F_EFEFF6
                                          titleFont:nil
                                      titleAligment:NSTextAlignmentLeft];
        _commentLabel.font = HK_FONT_SYSTEM(14);
        _commentLabel.numberOfLines = 0;
        _commentLabel.userInteractionEnabled = YES;
        [_commentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentLabelClick:)]];
    }
    return _commentLabel;
}


- (void)commentLabelClick:(UITapGestureRecognizer*)gesture  {
    if ([self.delegate respondsToSelector:@selector(bookCommentTopCell:headViewCommentAction:model:)]) {
        [self.delegate bookCommentTopCell:self headViewCommentAction:0 model:self.model];
    }
}




- (UILabel*)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                   titleColor:COLOR_A8ABBE_7B8196
                                    titleFont:nil
                                titleAligment:NSTextAlignmentRight];
        _timeLabel.font = HK_FONT_SYSTEM(12);
    }
    return _timeLabel;
}



- (UIImageView*)vipImageView {
    if (!_vipImageView) {
        _vipImageView = [UIImageView new];
        _vipImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _vipImageView;
}


- (UILabel*)chosenLB {
    
    if (!_chosenLB) {
        _chosenLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                   titleColor:COLOR_FF7820
                                    titleFont:@"11"
                                titleAligment:NSTextAlignmentCenter];
        _chosenLB.backgroundColor = [UIColor colorWithHexString:@"#FFF0E6"];
        _chosenLB.clipsToBounds = YES;
        _chosenLB.layer.cornerRadius = 7.5;
        _chosenLB.hidden = YES;
    }
    return _chosenLB;
}



-(void)bindViewModel:(HKBookTopModel *)viewModel {
    self.model = viewModel.model;
}



- (void)setModel:(HKBookCommentModel *)model {
    _model = model;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.username];
    self.vipImageView.image = [HKvipImage comment_vipImageWithType:model.user_vip];
    [self.iconIV sd_setImageWithURL:HKURL(model.avatar) placeholderImage:imageName(HK_Placeholder)];
    
    [self.coverIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.image_url]) placeholderImage:imageName(HK_Placeholder)];
    self.coverIV.hidden = isEmpty(model.image_url);
    
    if (!isEmpty(model.content)) {
        NSMutableAttributedString *attrString = [NSMutableAttributedString  changeLineSpaceWithTotalString:model.content LineSpace:PADDING_5];
        self.commentLabel.attributedText = attrString;
    }else{
        self.commentLabel.attributedText = nil;
    }
    [self.courseStarView setAllImage:[model.score integerValue]];
    self.timeLabel.text = model.created_at;
    
    self.chosenLB.text = model.is_excellent ?@"精选" :nil;
    self.chosenLB.hidden = !model.is_excellent;
}



@end


