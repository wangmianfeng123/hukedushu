
//
//  HKTaskDetailCommentCell.m
//  Code
//
//  Created by Ivan li on 2018/7/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskDetailCommentCell.h"
#import "UIView+SDAutoLayout.h"
#import "HKTaskModel.h"
#import <SDWebImage/UIButton+WebCache.h>



@implementation HKTaskDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableview model:(HKTaskModel *)model {
    //+ (instancetype)initCellWithTableView:(UITableView *)tableview  {
    
    static  NSString  *identif = @"HKTaskDetailCommentCell";
    HKTaskDetailCommentCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HKTaskDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif model:model];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  model:(HKTaskModel *)model {
    
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
    
    UITapGestureRecognizer *coverTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverImageClick:)];
    [self.coverImageView addGestureRecognizer:coverTap];
    self.coverImageView.userInteractionEnabled = YES;
    
    NSArray *arr = @[self.iconImageView,self.vipImageView,self.nameLabel,self.detailINfoLabel,self.timeLabel,self.lineView,self.coverImageView];
    [self.contentView sd_addSubviews:arr];
    [self makeConstraints];
}




- (void)makeConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.top.equalTo(self.contentView).offset(22);
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
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
    
    [self.detailINfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(PADDING_10);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.left.equalTo(self.nameLabel);
        //make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    
//    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.detailINfoLabel.mas_bottom).offset(PADDING_10);
//        make.left.right.equalTo(self.detailINfoLabel);
//        //make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
//    }];
    

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(PADDING_10);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}




- (UIView*)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor clearColor];
    }
    return _lineView;
}


#pragma mark - Getter

- (void)userImageViewClick:(id)sender  {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentUserInfoClick:indexPath:)]) {
        [self.delegate commentUserInfoClick:self.model indexPath:self.indexPath];
    }
}


- (void)titleLabelClick:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentUserInfoClick:indexPath:)]) {
        [self.delegate commentUserInfoClick:self.model indexPath:self.indexPath];
    }
}




- (void)coverImageClick:(UITapGestureRecognizer *)tap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDetailCommentImageInCell:indexPath:)]) {
        [self.delegate didClickDetailCommentImageInCell:self indexPath:self.indexPath];
    }
}



- (void)setModel:(HKTaskModel *)model {
    _model = model;
    
    self.nameLabel.text = model.username;
    self.timeLabel.text = model.created_at;
    self.detailINfoLabel.text = model.content;
    
    self.vipImageView.image = [HKvipImage comment_vipImageWithType:model.vip_class];
    [self.iconImageView sd_setImageWithURL:HKURL(model.avator) forState:UIControlStateNormal];
    
    //NSLog(@"model.picture_url ---  %@",model.picture_url);
    
    if (isEmpty(model.picture_url)) {
        
        [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailINfoLabel.mas_bottom).offset(PADDING_10);
            make.left.right.equalTo(self.detailINfoLabel);
            make.height.priorityHigh().mas_equalTo(0);
        }];
        
    }else{
        [self.coverImageView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.picture_url]) placeholderImage:HK_PlaceholderImage
                                        options:SDWebImageAvoidAutoSetImage // 下载完成后不要自动设置image SDWebImageAvoidAutoSetImage
                                      completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                          
                                          if (nil != error) {
                                              [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                                  make.top.equalTo(self.detailINfoLabel.mas_bottom).offset(PADDING_10);
                                                  make.left.right.equalTo(self.detailINfoLabel);
                                                  make.height.priorityHigh().mas_equalTo(0);
                                              }];
                                              self.coverImageView.image = nil;
                                              return;
                                          }
                                          
                                          CGFloat w = image.size.width;
                                          CGFloat h = image.size.height;
                                          
                                          CGFloat H =0;
                                          if (w >(SCREEN_WIDTH-30)) {
                                              if (w>=h) {
                                                  CGFloat rate = h/w ;
                                                  H = rate * (SCREEN_WIDTH-80);
                                              }else{
                                                  CGFloat rate = h/w ;
                                                  H = rate * (SCREEN_WIDTH-80);
                                              }
                                          }else{
                                              if (w>=h) {
                                                  CGFloat rate = w/h ;
                                                  H = rate * h;
                                              }else{
                                                  CGFloat rate = h/w ;
                                                  H = rate * h;
                                              }
                                          }
                                          [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                              make.top.equalTo(self.detailINfoLabel.mas_bottom).offset(PADDING_10);
                                              make.left.right.equalTo(self.detailINfoLabel);
                                              make.height.priorityHigh().mas_equalTo(H);
                                          }];
                                          self.coverImageView.image = image;
                                      }];
        
    }
}

@end




