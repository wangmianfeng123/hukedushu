//
//  HKAlbumDetailHeadView.m
//  Code
//
//  Created by Ivan li on 2017/12/3.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKAlbumDetailHeadView.h"
#import "HKAlbumListModel.h"
#import "HKAlbumTagView.h"
#import "NSString+MD5.h"


@interface HKAlbumDetailHeadView()

@property(nonatomic,strong)UIImageView *bgImageView;

@property(nonatomic,strong)UIImageView *iconImageView;
/** 专辑标题 */
@property(nonatomic,strong)UILabel *albumTitleLabel;
/** 专辑数量 */
@property(nonatomic,strong)UILabel *albumCountLabel;
/** 收藏 */
@property(nonatomic,strong)UIButton *collectBtn;
/** 模糊视图 */
@property(nonatomic,strong)UIVisualEffectView *effectView;
/** 模糊视图 遮照 */
@property(nonatomic,strong)UIView *effectCoverView;
/** 头像 */
@property(nonatomic,strong)UIImageView *userImageView;
/** 昵称 */
@property(nonatomic,strong)UILabel *userNameLabel;
/** 收藏人数 */
//@property(nonatomic,strong)HKAlbumTagView  *followView;
/** 练习数量 */
//@property(nonatomic,strong)HKAlbumTagView  *exerciseView;

/** 收藏数 */
@property(nonatomic,strong)UILabel *collectLabel;
/** 教程数 */
@property(nonatomic,strong)UILabel *courseLabel;

@property(nonatomic,strong)UILabel *lineLB;

@end



@implementation HKAlbumDetailHeadView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}



- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.effectView];
    [self.bgImageView addSubview:self.effectCoverView];

    [self.contentView addSubview:self.iconImageView];
    
    [self.contentView addSubview:self.albumTitleLabel];
    [self.contentView addSubview:self.albumCountLabel];
    [self.contentView addSubview:self.collectBtn];
    
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.userNameLabel];
    
    [self.contentView addSubview:self.collectLabel];
    [self.contentView addSubview:self.courseLabel];
    [self.contentView addSubview:self.lineLB];
    
    //[self.contentView addSubview:self.followView];
    //[self.contentView addSubview:self.exerciseView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints  {
    
    [_bgImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImageView);
    }];
    
    [_effectCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImageView);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_top).offset(KNavBarHeight64+PADDING_30);
        make.left.equalTo(self.bgImageView.mas_left).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(280/2, 175/2));
    }];
    
    [_albumCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(18);
        make.left.equalTo(self.bgImageView.mas_left).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_5);
    }];
    
    [_albumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_20);
        make.top.equalTo(self.iconImageView.mas_top).offset(3);
        make.right.equalTo(self.bgImageView.mas_right).offset(-1);
    }];
    
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-PADDING_20);
        make.top.equalTo(self.albumCountLabel.mas_bottom).offset(PADDING_10);
        make.height.mas_equalTo(PADDING_30);
        make.width.mas_equalTo(PADDING_25*4);
        make.centerX.equalTo(self.bgImageView);
    }];
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.albumTitleLabel.mas_bottom).offset(6);
        make.left.equalTo(self.albumTitleLabel);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(PADDING_5);
        make.centerY.equalTo(self.userImageView);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-1);
    }];
    
    [_collectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userImageView.mas_bottom).offset(12);
        make.left.equalTo(self.userImageView.mas_left);
    }];
    
    [_lineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.collectLabel);
        make.size.mas_equalTo(CGSizeMake(1, 9));
        make.left.equalTo(self.collectLabel.mas_right).offset(PADDING_10);
    }];
    
    [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectLabel);
        make.left.equalTo(self.lineLB.mas_right).offset(PADDING_10);
        make.right.equalTo(self.bgImageView);
    }];
    
//    [_followView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.userImageView.mas_bottom).offset(PADDING_15);
//        make.left.equalTo(self.userImageView.mas_left);
//    }];
//
//    [_exerciseView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.userImageView.mas_bottom).offset(PADDING_15);
//        make.left.equalTo(self.followView.mas_right).offset(PADDING_20);
//    }];
}


- (UIVisualEffectView*)effectView {
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }
    return _effectView;
}


- (UIView*)effectCoverView {
    if (!_effectCoverView) {
        _effectCoverView = [UIView new];
        _effectCoverView.backgroundColor = [COLOR_000000 colorWithAlphaComponent:.7];
        _effectCoverView.alpha = 0.25;
    }
    return _effectCoverView;
}


- (UIImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.clipsToBounds = YES;
        //_bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = PADDING_5;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}


- (UILabel*)albumTitleLabel {
    if (!_albumTitleLabel) {
        _albumTitleLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_ffffff titleFont:@"18"titleAligment:NSTextAlignmentLeft];
        _albumTitleLabel.numberOfLines = 1;
        _albumTitleLabel.font = HK_FONT_SYSTEM_WEIGHT(18, UIFontWeightSemibold);
    }
    return _albumTitleLabel;
}


- (UILabel*)albumCountLabel {
    if (!_albumCountLabel) {
        _albumCountLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_ffffff titleFont:@"14"titleAligment:NSTextAlignmentLeft];
        _albumCountLabel.numberOfLines = 2;
    }
    return _albumCountLabel;
}



- (UIButton*)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithTitle:@"收藏专辑" titleColor:COLOR_ffffff titleFont:@"14" imageName:nil];
        [_collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
        [_collectBtn setTitleColor:COLOR_ffffff forState:UIControlStateSelected];
        _collectBtn.clipsToBounds = YES;
        _collectBtn.layer.borderWidth = 1;
        _collectBtn.layer.cornerRadius = PADDING_30 * 0.5;
        _collectBtn.layer.borderColor = COLOR_ffffff.CGColor;
        [_collectBtn addTarget:self action:@selector(collectAlbumClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}

- (UIImageView*)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc]init];
        _userImageView.image = imageName(HK_Placeholder);
        _userImageView.clipsToBounds = YES;
        _userImageView.layer.cornerRadius = PADDING_25/2;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userImageView;
}


- (UILabel*)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_ffffff titleFont:@"14"titleAligment:NSTextAlignmentLeft];
    }
    return _userNameLabel;
}


- (UILabel*)collectLabel {
    
    if (!_collectLabel) {
        _collectLabel = [UILabel new];
        [_collectLabel setTextColor:COLOR_EFEFF6];
        _collectLabel.textAlignment = NSTextAlignmentLeft;
        _collectLabel.font = HK_FONT_SYSTEM(13);
        
    }
    return _collectLabel;
}


- (UILabel*)courseLabel {
    
    if (!_courseLabel) {
        _courseLabel = [UILabel new];
        [_courseLabel setTextColor:COLOR_EFEFF6];
        _courseLabel.textAlignment = NSTextAlignmentLeft;
        _courseLabel.font = HK_FONT_SYSTEM(13);
    }
    return _courseLabel;
}


- (UILabel*)lineLB {
    if (!_lineLB) {
        _lineLB = [UILabel new];
        _lineLB.backgroundColor = COLOR_EFEFF6;
    }
    return _lineLB;
}


//- (HKAlbumTagView*)followView {
//    if (!_followView) {
//        _followView = [[HKAlbumTagView alloc]initWithFrame:CGRectZero];
//    }
//    return _followView;
//}
//
//
//
//- (HKAlbumTagView*)exerciseView {
//    if (!_exerciseView) {
//        _exerciseView = [[HKAlbumTagView alloc]initWithFrame:CGRectZero];
//    }
//    return _exerciseView;
//}


- (void)collectAlbumClick:(UIButton*)btn {
    
    if ([self.delegate respondsToSelector:@selector(collectAblumList:)]) {
        [self.delegate collectAblumList:btn];
    }
    
    if ([HKAccountTool shareAccount]) {
        if(!isEmpty(self.model.album_id)) {
            if (self.isMyAblum) {
                //自己创建的专辑
                self.editMyAlbumBlock ? self.editMyAlbumBlock(self.model) :nil;
            }else{
                //收藏的专辑
                [self collectOrQuitAlbumWithModel:self.model];
            }
        }
    }
}



- (void)hiddenCollectBtn {
    _collectBtn.hidden = YES;
}


/** 设置按钮标题 */
- (void)setCollectBtnTitle:(NSString *)collectBtnTitle {
    _collectBtnTitle = collectBtnTitle;
    [_collectBtn setTitle:collectBtnTitle forState:UIControlStateNormal];
    [_collectBtn setTitle:collectBtnTitle forState:UIControlStateSelected];
}


- (void)setIsMyAblum:(BOOL)isMyAblum {
    _isMyAblum = isMyAblum;
    if (_isMyAblum) { self.collectBtnTitle = @"编辑"; }
}


- (void)setModel:(HKAlbumListModel *)model {
    
    //collect_num：收藏数；video_num：课程数；is_collect：0-未收藏 1-已收藏 2-不显示收藏
    _model = model;
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    if (isEmpty(model.introduce)) {
        _albumCountLabel.text = nil;
    }else{
        NSString *introduce = [NSString removeSpaceAndNewline: model.introduce];
        _albumCountLabel.text = [NSString stringWithFormat:@"简介：%@",introduce];
    }
    _albumTitleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    _collectLabel.text = [NSString stringWithFormat:@"收藏数 %@",model.collect_num];
    _courseLabel.text = [NSString stringWithFormat:@"教程 %@",model.video_num];
    
    //[_followView setImageWithName:@"album_enjoy_white" text:[NSString stringWithFormat:@"%@人",model.collect_num] type:nil];
    //[_exerciseView setImageWithName:@"album_exercise_white" text:[NSString stringWithFormat:@"%@节",model.video_num] type:nil];
    _userNameLabel.text = model.username;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    
    _collectBtn.selected = [model.is_collect integerValue];
}



//收藏/取消收藏专辑
- (void)collectOrQuitAlbumWithModel:(HKAlbumListModel *)model {
    
    WeakSelf;
    if (isEmpty(model.album_id)) {
        return;
    }
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:model.album_id,@"album_id",nil];
    [HKHttpTool POST:ALBUM_COLLECT_ALBUM parameters:parameters success:^(id responseObject) {
        
        if (HKReponseOK) {
            HK_NOTIFICATION_POST(KQuitOrCollectAlbumNotification, nil);
            
            NSInteger count = 0;
            if ([model.is_collect isEqualToString:@"0"]) {

                count = [model.collect_num intValue]+1;
                model.is_collect = @"1";
                showTipDialog(@"收藏成功");
            
            }else if ([model.is_collect isEqualToString:@"1"]) {
                
                NSInteger temp = [model.collect_num intValue];
                if (temp >0) {
                    count = temp -1;
                }
                model.is_collect = @"0";
                showTipDialog(@"取消收藏");
            }
            //_collectBtn.selected = YES;
            model.collect_num = [NSString stringWithFormat:@"%ld",(long)count];
            weakSelf.model = model;
            weakSelf.quitOrCollectAlbumBlock(model);
        }
    } failure:^(NSError *error) {
        
    }];
}






@end





