//
//  HKShortVideoCommentSubCell.m
//  Code
//
//  Created by hanchuangkeji on 2019/5/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKShortVideoCommentSubCell.h"

@interface HKShortVideoCommentSubCell()

@property (nonatomic, weak)UILabel *contentLB; // 评论的内容

@property (nonatomic, weak)UIView *verLine; // 垂直分割线

@end

@implementation HKShortVideoCommentSubCell

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
    
    UIView *verLine = [[UIView alloc] init];
    self.verLine = verLine;
    [self.contentView addSubview:verLine];
    verLine.backgroundColor = HKColorFromHex(0xA8ABBE, 0.1);
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0);
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(58.0);
    }];
    
    // 内容
    UILabel *contentLB = [[UILabel alloc] init];
    contentLB.numberOfLines = 0;
    contentLB.font = [UIFont systemFontOfSize:14.0];
    contentLB.textColor = [UIColor whiteColor];
    self.contentLB = contentLB;
    [self.contentView addSubview:contentLB];
    [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(verLine).offset(15.0);
        make.top.mas_equalTo(verLine);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
}

- (void)setModel:(HKShortVideoCommentModel *)model {
    _model = model;
    
    NSString *userName = model.commentUser.username.length? model.commentUser.username : model.commentUser.name;
    NSString *replyUserName = model.parentCommentUser.username.length? model.parentCommentUser.username : @"";
    NSString *nameToName = [NSString stringWithFormat:@"%@ 回复 %@", userName, replyUserName]; // 用于防止评论内容有相同名字字符串
    NSString *nameToNameAndContent = [NSString stringWithFormat:@"%@\n%@", nameToName, model.content]; // 谁回复谁+内容
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nameToNameAndContent];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, str.length)];
    
    if (userName == nil || replyUserName == nil) {
        self.contentLB.attributedText = str;
        return;
    }

    // 名字特殊处理
    [str addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xA8ABBE, 1.0) range:[nameToNameAndContent rangeOfString:userName]];
    [str addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xA8ABBE, 1.0) range:[nameToName rangeOfString:replyUserName options:NSBackwardsSearch]];

    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0 weight:UIFontWeightBold] range:[nameToNameAndContent rangeOfString:userName]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0 weight:UIFontWeightBold] range:[nameToName rangeOfString:replyUserName options:NSBackwardsSearch]];
    ;
   
    // 行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4.0];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
    
    self.contentLB.attributedText = str;
}


- (void)setIsLastCell:(BOOL)isLastCell {
    _isLastCell = isLastCell;
    
    if (isLastCell) {
        [self.verLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1.0);
            make.top.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView).offset(-10.0);
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
