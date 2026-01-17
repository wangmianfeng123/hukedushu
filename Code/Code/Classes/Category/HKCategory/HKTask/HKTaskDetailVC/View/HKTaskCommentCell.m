
//
//  HKTaskCommentCell.m
//  Code
//
//  Created by Ivan li on 2018/7/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskCommentCell.h"

#import "HKTaskModel.h"

@interface HKTaskCommentCell()

@property(nonatomic,strong)UILabel *attrLabel;

@property(nonatomic,strong)UIView *garyView;

@property(nonatomic,assign)NSInteger row;

@end

@implementation HKTaskCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)initCellWithTableView:(UITableView *)tableView  row:(NSInteger)row {
    
    HKTaskCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKTaskCommentCell"];
    if (!cell) {
        cell = [[HKTaskCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKTaskCommentCell"];
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


//#pragma mark cell左边缩进 右边缩进
//-(void)setFrame:(CGRect)frame{
//    frame.origin.x = PADDING_15;
//    frame.size.width = SCREEN_WIDTH - 2*PADDING_15;
//    [super setFrame:frame];
//}


- (void)createUI {
    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.contentView.backgroundColor = COLOR_F8F9FA;
    [self.contentView addSubview:self.garyView];
    [self.contentView addSubview:self.attrLabel];
    
    [self.garyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.attrLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.garyView).offset(15);
        make.right.equalTo(self.garyView).offset(-15);
        make.top.equalTo(self.garyView).offset(3);
        make.bottom.equalTo(self.garyView).offset(-3);
    }];
    
}



- (UILabel *)attrLabel {
    
    if (!_attrLabel) {
        _attrLabel = [UILabel new];
        _attrLabel.textColor = COLOR_27323F;
        _attrLabel.numberOfLines = 0;
        _attrLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _attrLabel;
}


- (UIView*)garyView {
    if (!_garyView) {
        _garyView = [UIView new];
        _garyView.backgroundColor = COLOR_F8F9FA;
    }
    return _garyView;
}


- (void)setCommentM:(HKTaskCommentModel *)commentM {
    _commentM = commentM;
    if (self.row>2) {
        NSString *str =@"查看更多 >";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_A8ABBE range:NSMakeRange(0, attrString.length)];
        self.attrLabel.attributedText = attrString;
    }else{
        
        if (!isEmpty(commentM.username)) {
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:3];//行间距
            //去除首位空格
            if (self.row == 1) {
                commentM.content = @"姐姐斤斤计较斤斤计较及 i 计划巴萨錒坚持农村经济简简单单就教大家姐姐斤斤计较斤斤计较及 i 计划巴萨錒坚持农村经济简简单单就教大家";
            }
            NSString *contentString = [NSString stringWithFormat:@"%@: %@", commentM.username, commentM.content];
            NSRange userNameRange = [contentString rangeOfString:commentM.username];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
            [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
            [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_3D8BFF range:userNameRange];
            self.attrLabel.attributedText = attrString;
        }
    }
}


@end








