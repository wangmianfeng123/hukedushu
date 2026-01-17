//
//  HKShortVideoCommentCell.m
//  Code
//
//  Created by hanchuangkeji on 2019/5/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKShortVideoCommentTopCell.h"

@interface HKShortVideoCommentTopCell()

@property (nonatomic, weak)UIImageView *headerIV; // 头像

@property (nonatomic, weak)UILabel *nameLB; // 名字

@property (nonatomic, weak)UILabel *contentLB; // 评论的内容

@property (nonatomic, weak)UILabel *timeLB; // 时间

@end

@implementation HKShortVideoCommentTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    // 头像
    UIImageView *headerIV = [[UIImageView alloc] init];
    self.headerIV = headerIV;
    headerIV.userInteractionEnabled = YES;
    [self.contentView addSubview:headerIV];
    [headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30.0, 30.0));
        make.left.mas_equalTo(self.contentView).offset(15.0);
        make.top.mas_equalTo(self.contentView).offset(12.0);
    }];
    headerIV.clipsToBounds = YES;
    headerIV.layer.cornerRadius = 15.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapAction)];
    [headerIV addGestureRecognizer:tap];
    
    // 名字
    UILabel *nameLB = [[UILabel alloc] init];
    nameLB.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightBold];
    nameLB.textColor = HKColorFromHex(0xA8ABBE, 1.0);
    self.nameLB = nameLB;
    [self.contentView addSubview:nameLB];
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerIV.mas_right).offset(10.0);
        make.centerY.mas_equalTo(headerIV);
        make.right.mas_lessThanOrEqualTo(self.contentView);
    }];
    nameLB.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapAction)];
    [nameLB addGestureRecognizer:tap2];
    
    // 内容
    UILabel *contentLB = [[UILabel alloc] init];
    contentLB.numberOfLines = 0;
    contentLB.font = [UIFont systemFontOfSize:14.0];
    contentLB.textColor = [UIColor whiteColor];
    self.contentLB = contentLB;
    [self.contentView addSubview:contentLB];
    [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLB);
        make.top.mas_equalTo(nameLB.mas_bottom).offset(6.0);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    // 时间
    UILabel *timeLB = [[UILabel alloc] init];
    timeLB.font = [UIFont systemFontOfSize:12.0];
    timeLB.textColor = HKColorFromHex(0xA8ABBE, 1.0);
    self.timeLB = timeLB;
    [self.contentView addSubview:timeLB];
    [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentLB);
        make.top.mas_equalTo(contentLB.mas_bottom).offset(5.0);
        make.bottom.mas_equalTo(self.contentView).offset(- 10.0);;
    }];
}

- (void)userTapAction {
    !self.userTapActionBlock? : self.userTapActionBlock(self.model);
}


- (void)setModel:(HKShortVideoCommentModel *)model {
    _model = model;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.commentUser.avator] placeholderImage:imageName(HK_Placeholder)];
    self.nameLB.text = model.commentUser.username;
    self.contentLB.text = model.content;
    self.timeLB.text = model.time_desc;
}



@end
