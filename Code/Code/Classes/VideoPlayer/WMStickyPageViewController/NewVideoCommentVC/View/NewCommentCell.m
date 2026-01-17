//
//  NewCommentCell.m
//  Code
//
//  Created by Ivan li on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "NewCommentCell.h"
//#import <TYAttributedLabel/TYAttributedLabel.h>
#import "NewCommentModel.h"
#import "UIView+SDAutoLayout.h"


@interface NewCommentCell()

@property(nonatomic,strong)UILabel *attrLabel;

@property(nonatomic,strong)UIView *blankView;

@property(nonatomic,assign)NSInteger row;

@end

@implementation NewCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)initCellWithTableView:(UITableView *)tableView  row:(NSInteger)row{
    
    NewCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewCommentCell"];
    if (!cell) {
        cell = [[NewCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewCommentCell"];
    }
    cell.row = row;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


#pragma mark cell左边缩进 右边缩进
-(void)setFrame:(CGRect)frame{
    CGFloat leftSpace = 65;//(IS_IPHONE6PLUS ?100: (IS_IPHONE5S ?60:90));
    frame.origin.x = leftSpace;
    frame.size.width = (IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) -leftSpace-PADDING_15;//SCREEN_WIDTH - (IS_IPHONE6PLUS ?110:(IS_IPHONE5S ?70:100));
    [super setFrame:frame];
}


- (void)createUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = COLOR_F8F9FA_333D48;
    [self.contentView addSubview:self.attrLabel];
    [self.contentView addSubview:self.blankView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.attrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(PADDING_10);
        make.top.equalTo(self.contentView.mas_top).offset(PADDING_10);
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING_10);
    }];

    [self.blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.attrLabel);
        make.top.equalTo(self.attrLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}




- (UIView*)blankView {
    if (!_blankView) {
        _blankView = [UIView new];
    }
    return _blankView;
}

- (UILabel *)attrLabel {
    
    if (!_attrLabel) {
        _attrLabel = [UILabel new];
        _attrLabel.textColor = COLOR_7B8196_A8ABBE;
        _attrLabel.numberOfLines = 0;
        _attrLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _attrLabel;
}


//- (void)setCommentModel:(NewCommentModel *)commentModel {
//
//    _commentModel = commentModel;
//}


- (void)setModel:(CommentChildModel *)model {
    _model = model;
    if (self.row>2) {
        NSString *str =@"查看全部评论 >";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_A8ABBE range:NSMakeRange(0, attrString.length)];
        self.attrLabel.attributedText = attrString;
    }else{
        // 富文本content
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];//行间距
        
        if ([model.reply_username isEqualToString:model.username]) {
            
            //去除首位空格
            NSString *contentString = [NSString stringWithFormat:@"%@: %@", model.username, model.content];
            NSRange userNameRange = [contentString rangeOfString:model.username];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
            [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
            [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_3D8BFF range:userNameRange];
            self.attrLabel.attributedText = attrString;
        }else{
            
            NSString *contentString = [NSString stringWithFormat:@"%@ 回复 %@:%@", model.username, model.reply_username, model.content];
            NSRange userNameRange = [contentString rangeOfString:model.username];
            NSRange replyUserNameRange = [contentString rangeOfString:model.reply_username];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
            [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
            [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_3D8BFF range:userNameRange];
            [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_3D8BFF range:replyUserNameRange];
            self.attrLabel.attributedText = attrString;
        }
    }
}



- (CGSize)sizeThatFits:(CGSize)size {
    
    CGFloat totalHeight = 10;
    totalHeight += [self.attrLabel sizeThatFits:CGSizeMake(size.width -100, 0)].height;
    totalHeight += [self.blankView sizeThatFits:CGSizeMake(size.width -100, 0)].height;
    //NSLog(@"totalHeight ----- >>>> %f",totalHeight);
    return CGSizeMake(size.width -80, totalHeight);
}


@end
