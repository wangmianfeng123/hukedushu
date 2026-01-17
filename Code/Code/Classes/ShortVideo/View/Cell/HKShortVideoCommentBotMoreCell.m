//
//  HKShortVideoCommentSubCell.m
//  Code
//
//  Created by hanchuangkeji on 2019/5/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKShortVideoCommentBotMoreCell.h"

@interface HKShortVideoCommentBotMoreCell()

@property (nonatomic, weak)UILabel *contentLB; // 评论的内容

@property (nonatomic, weak)UIView *verLine; // 垂直分割线

@property (nonatomic, weak)UIButton *loadMoreBtn;

@property (nonatomic, weak)UIImageView *arrowIV;

@end

@implementation HKShortVideoCommentBotMoreCell

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
    
    // 分割线
    UIView *verLine = [[UIView alloc] init];
    self.verLine = verLine;
    [self.contentView addSubview:verLine];
    verLine.backgroundColor = HKColorFromHex(0xA8ABBE, 0.1);
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0);
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(58.0);
        make.bottom.mas_equalTo(self.contentView).offset(-8.0);
    }];
    
    // 查看更多
    UIButton *loadMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loadMoreBtn = loadMoreBtn;
    [loadMoreBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];
    loadMoreBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [loadMoreBtn setTitleColor:HKColorFromHex(0x7B8196, 1.0) forState:UIControlStateNormal];
    [self.contentView addSubview:loadMoreBtn];
    [loadMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(verLine.mas_right).offset(13.0);
    }];
    [loadMoreBtn addTarget:self action:@selector(loadMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [loadMoreBtn setEnlargeEdgeWithTop:10 right:0 bottom:10 left:0];
    
    // 箭头
    UIImageView *arrowIV = [[UIImageView alloc] init];
    self.arrowIV = arrowIV;
    arrowIV.image = imageName(@"short_video_show_more_comments");
    [self.contentView addSubview:arrowIV];
    [arrowIV sizeToFit];
    [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(loadMoreBtn);
        make.left.mas_equalTo(loadMoreBtn.mas_right).offset(2.0);
        make.bottom.mas_equalTo(self.contentView).offset(-12.0);
    }];
}

- (void)loadMoreBtnClick {
    BOOL isExpand = self.model.subPage < self.model.pageCount || self.model.comment.count < self.model.sub_count.intValue;
    !self.loadMoreBlock? : self.loadMoreBlock(isExpand, self.model);
    
    // 重新设置更新一下
//    self.model = self.model;
}

- (void)setModel:(HKShortVideoCommentModel *)model {
    _model = model;
    
    // 收起还是加载更多
    if (model.subPage >= model.pageCount || model.comment.count >= model.sub_count.intValue) {
        [self.loadMoreBtn setTitle:@"收起" forState:UIControlStateNormal];
        self.arrowIV.image = imageName(@"short_video_show_close_comments");
    } else {
        [self.loadMoreBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];
        self.arrowIV.image = imageName(@"short_video_show_more_comments");
    }
}

- (void)setIsLastCell:(BOOL)isLastCell {
    _isLastCell = isLastCell;
    if (isLastCell) {
        [self.verLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1.0);
            make.top.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.arrowIV.mas_bottom).offset(-5.0);
            make.left.mas_equalTo(self.contentView).offset(58.0);
        }];
    } else {
        [self.verLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1.0);
            make.top.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView).offset(58.0);
        }];
    }
}


@end
