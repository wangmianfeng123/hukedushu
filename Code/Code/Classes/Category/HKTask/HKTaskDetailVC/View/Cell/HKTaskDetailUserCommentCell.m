//
//  HKTaskDetailUserCommentCell.m
//  Code
//
//  Created by Ivan li on 2018/7/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskDetailUserCommentCell.h"
#import "HKTaskModel.h"

@interface HKTaskDetailUserCommentCell()

@property(nonatomic,strong)UILabel *attrLabel;

@property(nonatomic,strong)UIView *garyView;

@property(nonatomic,assign)NSInteger row;

@end

@implementation HKTaskDetailUserCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)initCellWithTableView:(UITableView *)tableView  row:(NSInteger)row {
    
    HKTaskDetailUserCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKTaskDetailUserCommentCell"];
    if (!cell) {
        cell = [[HKTaskDetailUserCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKTaskDetailUserCommentCell"];
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
- (void)setFrame:(CGRect)frame{

    frame.origin.x = 65;
    frame.size.width = SCREEN_WIDTH -65-PADDING_15;
    [super setFrame:frame];
}


- (void)createUI {
    
    //    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.garyView];
    [self.contentView addSubview:self.attrLabel];
    
    [self.garyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.attrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.garyView).offset(15);
        make.right.equalTo(self.garyView).offset(-15);
        make.top.equalTo(self.garyView).offset(4);
        make.bottom.equalTo(self.garyView).offset(-4);
    }];
    
}



- (UILabel *)attrLabel {
    
    if (!_attrLabel) {
        _attrLabel = [UILabel new];
        _attrLabel.textColor = COLOR_27323F;
        _attrLabel.numberOfLines = 0;
        _attrLabel.font = HK_FONT_SYSTEM(14);
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
    
    if (!isEmpty(commentM.username)) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];//行间距
        NSString *contentString = [NSString stringWithFormat:@"%@: %@", commentM.username, commentM.content];
        NSRange userNameRange = [contentString rangeOfString:commentM.username];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_3D8BFF range:userNameRange];
        self.attrLabel.attributedText = attrString;
    }
}


@end








