//
//  CommentHeadView.m
//  Code
//
//  Created by Ivan li on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//


#import "CommentHeadView.h"
#import "DetailModel.h"
#import "CourseStarView.h"
#import "UIView+SDAutoLayout.h"
#import "NewCommentModel.h"
#import "UIView+SNFoundation.h"
#import "UIImage+Helper.h"
#import "HKCommentModel.h"

//#define imgW (SCREEN_WIDTH - PADDING_15 - 40 - 10 - 15 - 15) * 0.5


@interface CommentHeadView()

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;
@property (nonatomic , strong) HKCustomMarginLabel * imgCountLabel;
@property(nonatomic,strong)UILabel *courseCountLabel; //教程评分

@property(nonatomic,strong)UILabel *detailINfoLabel;

@property(nonatomic,strong)UIImageView *showImageView;
@property (nonatomic , strong) UIImageView * showSecondImageView;

@property(nonatomic,strong)CourseStarView *courseStarView;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIView *blankView;

@property(nonatomic, strong) UITapGestureRecognizer  *singleTapGuesture; // 点击手势

@property(nonatomic,strong)UIImageView *topImageView;//评论置顶图标
/** vip 图标 */
@property(nonatomic,strong)UIImageView *vipImageView;

@property(nonatomic, assign)CGFloat imgW;

@end

@implementation CommentHeadView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
        
        
        self.imgW = ((IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) - PADDING_15 - 40 - 10 - 15 - 15) * 0.5;
    }
    return self;
}


- (void)dealloc {
    [self removeSingleTapGesture];
}


- (void)createUI {
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.topImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailINfoLabel];
    
    [self.contentView addSubview:self.courseCountLabel];
    [self.contentView addSubview:self.courseStarView];
    [self.contentView addSubview:self.showImageView];
    [self.contentView addSubview:self.showSecondImageView];
    [self.showSecondImageView addSubview:self.imgCountLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.vipImageView];
    
    [self addSingleTapGesture];
    [self makeConstraints];
}



- (void)makeConstraints {
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.top.equalTo(self.contentView).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
        make.centerY.equalTo(self.iconImageView);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(4);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.lessThanOrEqualTo(self.vipImageView.mas_right).offset(4);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [_courseStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.lessThanOrEqualTo(self.topImageView.mas_right).offset(8);
        make.centerY.equalTo(self.titleLabel);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(80);
    }];
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING_15);
    }];
    
    [_detailINfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(PADDING_10);
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING_15);
    }];
    
    self.showImageView.sd_layout
    .leftEqualToView(self.titleLabel)
    .topSpaceToView(self.detailINfoLabel,10);
    
    [self setupAutoHeightWithBottomView:self.showImageView bottomMargin:PADDING_10];
    
    
    [_showSecondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showImageView.mas_right).offset(15);
        make.top.equalTo(self.showImageView);
        make.bottom.equalTo(self.showImageView);
        make.width.equalTo(self.showImageView);
        //make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
    [self.imgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.showSecondImageView).offset(-10);
        make.right.equalTo(self.showSecondImageView).offset(-10);
        make.height.mas_equalTo(21);
    }];
    
}



- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userImageViewClick:)];
        [_iconImageView addGestureRecognizer:tap];
    }
    return _iconImageView;
}


- (void)userImageViewClick:(UITapGestureRecognizer*)gesture  {
    if (self.videoCommentModel.uid.length) {
        if ([self.delegate respondsToSelector:@selector(headViewuserImageViewClick:model:)]) {
            [self.delegate headViewuserImageViewClick:self.section model:self.videoCommentModel];
        }

    }
    
    if (self.mainCommentModel.uid.length) {
        if ([self.delegate respondsToSelector:@selector(headViewuserImageViewCommentModel:)]) {
            [self.delegate headViewuserImageViewCommentModel:self.mainCommentModel];
        }

    }
}


- (UIImageView*)topImageView {
    if (!_topImageView) {
        _topImageView = [UIImageView new];
        _topImageView.contentMode = UIViewContentModeScaleAspectFit;
        //_topImageView.image = imageName(@"comment_top");
        //_topImageView.hidden = YES;
    }
    return _topImageView;
}


- (UIImageView*)showImageView {
    if (!_showImageView) {
        _showImageView = [UIImageView new];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.userInteractionEnabled = YES;
        [_showImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCommeImage:)]];
        _showImageView.clipsToBounds = YES;
        _showImageView.tag = 0;
        _showImageView.layer.cornerRadius = 5;
    }
    return _showImageView;
}

- (UIImageView*)showSecondImageView {
    if (!_showSecondImageView) {
        _showSecondImageView = [UIImageView new];
        _showSecondImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showSecondImageView.userInteractionEnabled = YES;
        [_showSecondImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCommeImage:)]];
        _showSecondImageView.clipsToBounds = YES;
        _showSecondImageView.tag = 1;
        _showSecondImageView.layer.cornerRadius = 5;
    }
    return _showSecondImageView;
}

- (void)clickCommeImage:(UITapGestureRecognizer *)tap {
    
    
    if ([self.delegate respondsToSelector:@selector(headViewCommentImageViewClick:model:index:)]) {
        [self.delegate headViewCommentImageViewClick:self.section model:self.videoCommentModel index:tap.view.tag];
    }
}

//- (HKCustomMarginLabel*)imgCountLabel {
//
//    if (!_imgCountLabel) {
//        _imgCountLabel  = [UILabel labelWithTitle:CGRectZero title:nil
//                                    titleColor:COLOR_27323F_EFEFF6
//                                     titleFont:nil
//                                 titleAligment:NSTextAlignmentLeft];
//        _imgCountLabel.font = HK_FONT_SYSTEM_WEIGHT(12,UIFontWeightMedium);
//        _imgCountLabel.numberOfLines = 1;
//        _imgCountLabel.layer.cornerRadius = 15;
//        _imgCountLabel.layer.masksToBounds = YES;
//        [_imgCountLabel setedg]
//    }
//    return _imgCountLabel;
//}

-(HKCustomMarginLabel *)imgCountLabel{
    if (_imgCountLabel == nil) {
        _imgCountLabel  = [[HKCustomMarginLabel alloc] init];
        _imgCountLabel.textInsets = UIEdgeInsetsMake(3, 5, 3, 5);
        _imgCountLabel.textColor = COLOR_ffffff;
        _imgCountLabel.font = HK_FONT_SYSTEM(12);
        _imgCountLabel.textAlignment = NSTextAlignmentCenter;
        _imgCountLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
        //_countLabel.alpha = 0.5;
        _imgCountLabel.clipsToBounds = YES;
        _imgCountLabel.layer.cornerRadius = 10.5;
        //_tipLB.userInteractionEnabled = YES;
    }
    return _imgCountLabel;
}


- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                    titleColor:COLOR_27323F_EFEFF6
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(14,UIFontWeightSemibold);
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}



- (UILabel*)courseCountLabel {
    if (!_courseCountLabel) {
        _courseCountLabel  = [UILabel labelWithTitle:CGRectZero title:@"教程评分:"
                                          titleColor:COLOR_333333
                                           titleFont:nil
                                       titleAligment:NSTextAlignmentLeft];
        _courseCountLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:12];
        _courseCountLabel.numberOfLines = 1;
    }
    return _courseCountLabel;
}


- (CourseStarView*)courseStarView {
    
    if (!_courseStarView) {
        _courseStarView = [[CourseStarView alloc]initWithFrame:CGRectZero];
    }
    return _courseStarView;
}


- (UILabel*)detailINfoLabel {
    if (!_detailINfoLabel) {
        _detailINfoLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                         titleColor:COLOR_27323F_EFEFF6
                                          titleFont:nil
                                      titleAligment:NSTextAlignmentLeft];
        _detailINfoLabel.font = HK_FONT_SYSTEM(14);
        _detailINfoLabel.numberOfLines = 0;
        _detailINfoLabel.userInteractionEnabled = YES;
    }
    return _detailINfoLabel;
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

- (UIView*)blankView {
    if (!_blankView) {
        _blankView = [UIView new];
        _blankView.backgroundColor = [UIColor whiteColor];
    }
    return _blankView;
}


- (UIImageView*)vipImageView {
    if (!_vipImageView) {
        _vipImageView = [UIImageView new];
        _vipImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _vipImageView;
}



#pragma mark - add Gesture
- (void)addSingleTapGesture {
    if (_singleTapGuesture == nil) {
        _singleTapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLabelEvent:)];
        [self.detailINfoLabel addGestureRecognizer:_singleTapGuesture];
    }
}

- (void)removeSingleTapGesture {
    if (_singleTapGuesture) {
        [self removeGestureRecognizer:_singleTapGuesture];
        _singleTapGuesture = nil;
    }
}


- (void)onLabelEvent:(UITapGestureRecognizer*)gesture  {
    if ([self.delegate respondsToSelector:@selector(headViewCommentAction:model:)]) {
        [self.delegate headViewCommentAction:_section model:_videoCommentModel];
    }
}



- (void)setVideoCommentModel:(NewCommentModel *)videoCommentModel hidden:(BOOL)hidden {
    
    [self setVideoCommentModel:videoCommentModel];
    if ([videoCommentModel.stick_mark isEqualToString:@"1"]) {
        //stick_mark：0不置顶，1置顶
        _topImageView.image = imageName(@"comment_top");
        //_topImageView.hidden = NO;
    }else if ([videoCommentModel.stick_mark isEqualToString:@"0"]) {
        _topImageView.image = nil;
    }
}


- (void)setVideoCommentModel:(NewCommentModel *)videoCommentModel {
    
    _videoCommentModel = videoCommentModel;
    
    _vipImageView.image = [HKvipImage comment_vipImageWithType:videoCommentModel.vip_class];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:videoCommentModel.avator] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@",videoCommentModel.username];
    
    if (!isEmpty(videoCommentModel.content)) {
        NSMutableAttributedString *attrString = [NSMutableAttributedString  changeLineSpaceWithTotalString:videoCommentModel.content LineSpace:PADDING_5];
        _detailINfoLabel.attributedText = attrString;
    }else{
        _detailINfoLabel.attributedText = nil;
    }
    
    //_hardLabel.text = [NSString stringWithFormat:@"难易程度: %@",[self setHardLabelTitle:videoCommentModel.difficult]];
    if (videoCommentModel.pictures.count == 0) {
        
        self.showImageView.sd_layout.heightIs(0);
        [self setupAutoHeightWithBottomView:self.detailINfoLabel bottomMargin:PADDING_10];

    }else{
        
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:videoCommentModel.pictures[0]]] placeholderImage:imageName(HK_Placeholder) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                //UIImage *newImage = [UIImage imageCropCenterImage:image size:CGSizeMake(imgW, 0.8 *imgW)];
                self.showImageView.image = image;
            }
        }];
        
        self.showImageView.sd_layout
        .widthIs(self.imgW)
        .heightIs(0.8 *self.imgW);
        [self setupAutoHeightWithBottomView:self.showImageView bottomMargin:PADDING_10];
        
        if (videoCommentModel.pictures.count > 1) {
            self.showSecondImageView.hidden = NO;
            [self.showSecondImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:videoCommentModel.pictures[1]]] placeholderImage:imageName(HK_Placeholder)];
        }else{
            self.showSecondImageView.hidden = YES;
        }
    }
    
    [_courseStarView setAllImage:[videoCommentModel.score integerValue]];

    if (videoCommentModel.pictures.count > 2) {
        _imgCountLabel.hidden = NO;
        _imgCountLabel.text = [NSString stringWithFormat:@"%lu张图片",(unsigned long)videoCommentModel.pictures.count];
    }else{
        _imgCountLabel.hidden = YES;
    }
    
    _timeLabel.text = videoCommentModel.created_at;
}

-(void)setMainCommentModel:(HKCommentModel *)mainCommentModel{
    _mainCommentModel = mainCommentModel;
    //_vipImageView.image = [HKvipImage comment_vipImageWithType:videoCommentModel.vip_class];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:mainCommentModel.avatar] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@",mainCommentModel.username];
    
    if (!isEmpty(mainCommentModel.content)) {
        NSMutableAttributedString *attrString = [NSMutableAttributedString  changeLineSpaceWithTotalString:mainCommentModel.content LineSpace:PADDING_5];
        _detailINfoLabel.attributedText = attrString;
    }else{
        _detailINfoLabel.attributedText = nil;
    }
            
    self.showImageView.sd_layout.heightIs(0);
    [self setupAutoHeightWithBottomView:self.detailINfoLabel bottomMargin:PADDING_10];
    _courseStarView.hidden = YES;

    _timeLabel.text = mainCommentModel.created_at;
}

//教程难度，1太简单，2简单，3难度适中，4有点难，5太难了
- (NSString *)setHardLabelTitle:(NSString*)hardLevel {
    NSString *title = nil;
    if ([hardLevel isEqualToString:@"1"]) {
        title = @"太简单";
    }else if ([hardLevel isEqualToString:@"2"]) {
        title = @"简单";
    }else if ([hardLevel isEqualToString:@"3"]) {
        title = @"适中";
    }else if ([hardLevel isEqualToString:@"4"]) {
        title = @"有点难";
    }else if ([hardLevel isEqualToString:@"5"]) {
        title = @"太难了";
    }
    return title;
}


@end







