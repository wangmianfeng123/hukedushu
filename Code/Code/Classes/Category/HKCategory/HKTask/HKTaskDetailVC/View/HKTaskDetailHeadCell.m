//
//  HKTaskDetailHeadCell.m
//  Code
//
//  Created by Ivan li on 2018/7/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskDetailHeadCell.h"
#import "UIView+SDAutoLayout.h"
#import "HKTaskModel.h"
#import <SDWebImage/UIButton+WebCache.h>


@implementation HKTaskDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableview{
    
    static  NSString  *identif = @"HKTaskDetailHeadCell";
    HKTaskDetailHeadCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HKTaskDetailHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
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
    
    NSArray *arr = @[self.iconImageView,self.vipImageView,self.nameLabel,self.detailINfoLabel,self.timeLabel,
                     self.coverImageView,self.scanImageLB];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView sd_addSubviews:arr];
    [self makeConstraints];
}



- (void)makeConstraints1 {
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
    
    [self.scanImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(11);
        make.left.equalTo(self.coverImageView);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
}



- (void)makeConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
        make.top.equalTo(self.iconImageView);
    }];
    
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(4);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.detailINfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(14);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.left.equalTo(self.contentView).offset(PADDING_15);
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailINfoLabel.mas_bottom).offset(PADDING_10);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
    
    [self.scanImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(PADDING_10);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-PADDING_30);
    }];
}


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



- (UILabel*)scanImageLB {
    
    if (!_scanImageLB) {
        _scanImageLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                   titleColor:COLOR_A8ABBE
                                    titleFont:nil
                                titleAligment:NSTextAlignmentCenter];
        _scanImageLB.font = HK_FONT_SYSTEM(12);
    }
    return _scanImageLB;
}




- (void)setModel:(HKTaskDetailModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:HKURL(model.avator) forState:UIControlStateNormal];
    
    self.nameLabel.text = model.username;
    self.timeLabel.text = model.created_at;
    
    self.detailINfoLabel.text = model.describle;
    self.vipImageView.image = [HKvipImage comment_vipImageWithType:model.vip_class];
    
    self.scanImageLB.text = isEmpty(model.picture) ?nil :@"点击图片查看大图";
    
    [self.coverImageView sd_setImageWithURL:HKURL(model.picture) placeholderImage:HK_PlaceholderImage
                                    options:SDWebImageAvoidAutoSetImage // 下载完成后不要自动设置image SDWebImageAvoidAutoSetImage
                                  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                      CGFloat w = image.size.width;
                                      CGFloat h = image.size.height;
                                      
                                      CGFloat H =0;
                                      if (w >(SCREEN_WIDTH-30)) {
                                          if (w>=h) {
                                              CGFloat rate = h/w ;
                                              H = rate * (SCREEN_WIDTH-30);
                                          }else{
                                              CGFloat rate = h/w ;
                                              H = rate * (SCREEN_WIDTH-30);
                                          }
                                      }

                                      [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                          make.top.equalTo(self.detailINfoLabel.mas_bottom).offset(PADDING_10);
                                          make.left.equalTo(self.contentView).offset(PADDING_15);
                                          make.right.equalTo(self.contentView).offset(-PADDING_15);
                                          make.height.mas_equalTo(H);
                                      }];
                                        self.coverImageView.image = image;
                                        [self.coverImageView layoutIfNeeded];
                                    if (self.model.imageH <= 0) {
                                      if (self.delegate && [self.delegate respondsToSelector:@selector(reloadTaskDetailHeadCell:indexPath:)]) {
                                              self.model.imageH = H;
                                              [self.delegate reloadTaskDetailHeadCell:self.model indexPath:self.indexPath];
                                          }
                                      }
                                    //[self.contentView layoutIfNeeded];
//                                      [self.detailINfoLabel layoutIfNeeded];
//                                      [self.contentView layoutIfNeeded];
//                                      [self.contentView setNeedsDisplay];
                                  }
     ];
}
@end



