//
//  HKBookCommentChildrenCell.m
//  Code
//
//  Created by Ivan li on 2019/8/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookCommentChildrenCell.h"
#import "HKBookCommentModel.h"
#import "HKUserModel.h"

@interface HKBookCommentChildrenCell()

@property (nonatomic, strong)UILabel *contentLB; // 评论的内容

@property (nonatomic, strong)UIView *bgView;


@end

@implementation HKBookCommentChildrenCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.contentLB];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.contentLB);
    }];
    
    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(65);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _bgView;
}

- (UILabel*)contentLB {
    if (!_contentLB) {
        _contentLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"13" titleAligment:0];
        _contentLB.numberOfLines = 0;
        _contentLB.backgroundColor = COLOR_F8F9FA_333D48;
        _contentLB.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentLBClick)];
        [_contentLB addGestureRecognizer:tap];
    }
    return _contentLB ;
}



- (void)contentLBClick {
    if ([self.delegate respondsToSelector:@selector(bookCommentChildrenCell:model:)]) {
        [self.delegate bookCommentChildrenCell:self model:self.model];
    }
}



- (void)setModel:(HKBookCommentModel *)model {
    _model = model;
    
    NSString *userName = model.username;
    NSString *replyUserName = model.reply_to_username.length? model.reply_to_username : @"";
    NSString *nameToName = [NSString stringWithFormat:@"%@ 回复 %@", userName, replyUserName]; // 用于防止评论内容有相同名字字符串
    NSString *nameToNameAndContent = [NSString stringWithFormat:@"%@：%@", nameToName, model.content]; // 谁回复谁+内容
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nameToNameAndContent];
    [str addAttribute:NSForegroundColorAttributeName value:COLOR_7B8196_A8ABBE range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, str.length)];
    
    // 名字特殊处理
    [str addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x3D8BFF, 1.0) range:[nameToNameAndContent rangeOfString:userName]];
    [str addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x3D8BFF, 1.0) range:[nameToName rangeOfString:replyUserName options:NSBackwardsSearch]];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4.0];
    paragraphStyle.headIndent = 10;          //行首缩进
    paragraphStyle.firstLineHeadIndent = 10.0;//首行缩进
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
    self.contentLB.attributedText = str;
}


-(void)bindViewModel:(HKBookMidCommentModel *)viewModel {
    self.model = viewModel.model;
}

@end
