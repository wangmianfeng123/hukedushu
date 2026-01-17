//
//  HKStudyrRecommendCell.m
//  Code
//
//  Created by Ivan li on 2019/3/24.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKStudyrRecommendCell.h"
#import "VideoModel.h"

@interface HKStudyrRecommendCell()

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;
/** 观看人数 */
@property(nonatomic,strong)UILabel *countLabel;

@property(nonatomic,strong) UIButton *collectBtn;

@property(nonatomic,strong)UIView *coverView;

@property(nonatomic,strong)UIImageView *coverImageView;

@end


@implementation HKStudyrRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




+ (instancetype)initCellWithTableView:(UITableView *)tableview{
    
    static  NSString  *identif = @"HKStudyrRecommendCell";
    HKStudyrRecommendCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HKStudyrRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.collectBtn];
    
    [self.contentView addSubview:self.coverView];
    [self.contentView addSubview:self.coverImageView];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(7.5);
        make.left.equalTo(self.contentView).offset(PADDING_30);
        make.size.mas_equalTo(CGSizeMake(270/2, 160/2));
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.iconImageView);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconImageView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(7.5);
        make.right.equalTo(self.contentView).offset(-PADDING_30);
        make.top.equalTo(self.iconImageView);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.collectBtn.mas_left).offset(-3);
    }];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView);
        make.right.equalTo(self.contentView).offset(-PADDING_30);
        make.size.mas_equalTo(CGSizeMake(70, 22));
    }];
}


- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 4.5;
    }
    return _iconImageView;
}


- (UIImageView*)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.backgroundColor = [UIColor clearColor];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.image = imageName(@"ic_interest_start_v2.10");
    }
    return _coverImageView;
}


- (UIView*)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc]init];
        _coverView.clipsToBounds = YES;
        _coverView.layer.cornerRadius = 4.5;
        _coverView.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.2];
    }
    return _coverView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM(15);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}



- (UILabel*)countLabel {
    if (!_countLabel) {
        _countLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE_7B8196
                                     titleFont:@"12" titleAligment:NSTextAlignmentLeft];
         [_countLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _countLabel;
}



- (UIButton*)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _collectBtn.titleLabel.font = HK_FONT_SYSTEM(14);
        [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectBtn setTitle:@"点击学习" forState:UIControlStateSelected];
        
        [_collectBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [_collectBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateSelected];
        
        [_collectBtn addTarget:self action:@selector(collectBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_collectBtn setHKEnlargeEdge:PADDING_15];
        
        _collectBtn.clipsToBounds = YES;
        _collectBtn.layer.cornerRadius = 11;
        _collectBtn.layer.borderWidth = 0.5;
        _collectBtn.layer.borderColor = COLOR_27323F_EFEFF6.CGColor;
    }
    return _collectBtn;
}



- (void)collectBtnBtnClick:(UIButton*)btn {
    
    if (self.collectBtnClickCallBack) {
        self.collectBtnClickCallBack(btn, self.model);
    }
}




- (void)setModel:(VideoModel *)model {
    
    _model = model;
    _titleLabel.text = model.title;
    
    if (!isEmpty(model.video_play)) {
        _countLabel.text = [NSString stringWithFormat:@"%@人已学",model.video_play];
    }
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover_image_url]] placeholderImage:imageName(HK_Placeholder)];
    _collectBtn.selected = model.is_collected;
}




@end
