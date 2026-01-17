
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
        self.heightModel = model;
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
    
    NSArray *arr = @[self.iconImageView,self.vipImageView,self.nameLabel,self.detailINfoLabel,self.timeLabel,self.taskCommentView,self.lineView];
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
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
//    [self.taskCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.detailINfoLabel.mas_bottom).offset(PADDING_10);
//        make.right.equalTo(self.contentView).offset(-PADDING_15);
//        make.left.equalTo(self.nameLabel);
//        make.height.mas_equalTo(self.heightModel.replyListHeight);
//        //make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
//    }];
//
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.taskCommentView.mas_bottom).offset(PADDING_10);
//        make.right.equalTo(self.contentView).offset(-PADDING_15);
//        make.left.equalTo(self.nameLabel);
//        make.height.mas_equalTo(0.5);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
//    }];
}

- (HKTaskCommentView*)taskCommentView {
    if (!_taskCommentView) {
        _taskCommentView = [[HKTaskCommentView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    return _taskCommentView;
}


- (UIView*)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
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


- (void)praiseAction:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPraiseBtnInCell:indexPath:)]) {
        [self.delegate didClickPraiseBtnInCell:self indexPath:self.indexPath];
    }
}


- (void)setHeightModel:(HKTaskModel *)heightModel {
    _heightModel = heightModel;
    if (heightModel.reply_list.count) {
        for (HKTaskCommentModel *temp in heightModel.reply_list) {
            heightModel.replyListHeight += temp.headViewHeight;
        }
    }else{
        heightModel.replyListHeight = 0;
    }
    NSLog(@"heightModel.replyListHeight -- %f",heightModel.replyListHeight);
}


- (void)setModel:(HKTaskModel *)model {
    _model = model;

    self.nameLabel.text = model.username;
    self.timeLabel.text = model.created_at;
    self.detailINfoLabel.text = model.content;
    
    self.vipImageView.image = [HKvipImage comment_vipImageWithType:model.vip_class];
    NSString *count = model.thumbs;
    [self.iconImageView sd_setImageWithURL:HKURL(model.avator) forState:UIControlStateNormal];
    //self.taskCommentView.model = model;
}




@end










