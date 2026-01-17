

//
//  HKTaskListCell.m
//  Code
//
//  Created by Ivan li on 2018/7/12.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskListCell.h"
#import "UIView+SDAutoLayout.h"
#import "HKTaskModel.h"
#import <SDWebImage/UIButton+WebCache.h>


@implementation HKTaskListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableview{
    
    static  NSString  *identif = @"HKTaskListCell";
    HKTaskListCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HKTaskListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
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
    
    [self.iconImageView addTarget:self action:@selector(userImageViewClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
    [self.nameLabel addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapVip = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
    [self.vipImageView addGestureRecognizer:tapVip];
    
    self.detailINfoLabel.numberOfLines = 4;
    NSArray *arr = @[self.iconImageView,self.vipImageView,self.nameLabel,self.detailINfoLabel,self.timeLabel,
                     self.coverImageView,self.commentCountLB,self.scanCountLB,self.praiseBtn];
    [self.contentView sd_addSubviews:arr];
    [self makeConstraints];
}



- (void)makeConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
        make.centerY.equalTo(self.iconImageView);
    }];
    
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.nameLabel.mas_right).offset(4);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING_15);
    }];
    
    [self.detailINfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(12);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.left.equalTo(self.contentView).offset(PADDING_15);
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailINfoLabel.mas_bottom).offset(PADDING_10);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        //make.bottom.equalTo(self.contentView).offset(-PADDING_5);
    }];
    
    [self.scanCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(11);
        make.left.equalTo(self.coverImageView);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
    
    [self.commentCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanCountLB);
        make.left.equalTo(self.scanCountLB.mas_right).offset(8);
    }];
    
    [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.scanCountLB);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
    [self.praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-8, 0, 0)];
}




#pragma mark - Getter

- (void)userImageViewClick:(id)sender  {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userInfoClick:indexPath:)]) {
        [self.delegate userInfoClick:self.model indexPath:self.indexPath];
    }
}


- (void)titleLabelClick:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userInfoClick:indexPath:)]) {
        [self.delegate userInfoClick:self.model indexPath:self.indexPath];
    }
}



- (UILabel*)scanCountLB {
    
    if (!_scanCountLB) {
        _scanCountLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                   titleColor:COLOR_A8ABBE
                                    titleFont:nil
                                titleAligment:NSTextAlignmentRight];
        _scanCountLB.font = HK_FONT_SYSTEM(12);
    }
    return _scanCountLB;
}


- (UILabel*)commentCountLB {
    
    if (!_commentCountLB) {
        _commentCountLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                     titleColor:COLOR_A8ABBE
                                      titleFont:nil
                                  titleAligment:NSTextAlignmentRight];
        _commentCountLB.font = HK_FONT_SYSTEM(12);
    }
    return _commentCountLB;
}


- (UIButton*)praiseBtn {
    
    if (!_praiseBtn) {
        
        _praiseBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_FFB205
                                     titleFont:@"12" imageName:(@"praise_gray")];
        [_praiseBtn setTitleColor:COLOR_FFB205 forState:UIControlStateSelected];
        [_praiseBtn setTitleColor:COLOR_7B8196 forState:UIControlStateNormal];
        [_praiseBtn setImage:imageName(@"praise_red") forState:UIControlStateSelected];
        [_praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_praiseBtn setEnlargeEdgeWithTop:PADDING_15 right:0 bottom:PADDING_15 left:0];
    }
    return _praiseBtn;
}


- (void)praiseAction:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPraiseBtnInCell:indexPath:)]) {
        [self.delegate didClickPraiseBtnInCell:self indexPath:self.indexPath];
    }
}



- (void)setModel:(HKTaskModel *)model {
    _model = model;
    self.nameLabel.text = model.username;
    self.timeLabel.text = model.created_at;
    self.detailINfoLabel.text = model.evaluate;
    
    self.vipImageView.image = [HKvipImage comment_vipImageWithType:model.vip_class];
    
    self.scanCountLB.text = [NSString stringWithFormat:@"%@人看过", model.study_num];
    self.commentCountLB.text = [NSString stringWithFormat:@"%@评论", model.comment_total];
    
    NSString *count = model.thumbs;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%@",[count intValue] ?count :@"赞" ] forState:UIControlStateNormal];
    
    [self.iconImageView sd_setImageWithURL:HKURL(model.avator) forState:UIControlStateNormal];
    [self.coverImageView sd_setImageWithURL:HKURL(model.cover) placeholderImage:HK_PlaceholderImage
                                  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                      CGFloat w = image.size.width;
                                      CGFloat h = image.size.height;
        
    }];
}





@end









