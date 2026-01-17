//
//  HKTeacherDetailHeaderView.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKTeacherDetailHeaderView.h"
#import "MLLinkLabel.h"

@interface HKTeacherDetailHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *backBtn;// 返回
@property (weak, nonatomic) IBOutlet UILabel *nameLB;// 名字
@property (weak, nonatomic) IBOutlet UILabel *courseCount;// 教程数量
@property (weak, nonatomic) IBOutlet UILabel *fansCount;// 粉丝数量
@property (weak, nonatomic) IBOutlet MLLinkLabel *introducationLB;// 简介
@property (weak, nonatomic) IBOutlet UIButton *followBtn;// 关注

@property (weak, nonatomic) IBOutlet UIImageView *vipIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnTop;

@end




@implementation HKTeacherDetailHeaderView

- (void)setUser:(HKUserModel *)user {
    
    WeakSelf;
    _user = user;
    
    // 头像
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:user.avator] placeholderImage:imageName(HK_Placeholder)];
    
    // 名字
    self.nameLB.text = user.username.length? user.username : user.name;
    
    // 教程
    self.courseCount.text = [NSString stringWithFormat:@"教程 %@", user.curriculum_num.length? user.curriculum_num : @"0"];
    
    // 粉丝
    self.fansCount.text = [NSString stringWithFormat:@"粉丝 %@", user.follow];
    
    // 关注
    self.followBtn.selected = user.is_follow;
    [self.followBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    
    // 设置简介 并且返回高度
    CGFloat headerHeight = [self parseUserContent:user];
    !self.headerHeightBlock? : self.headerHeightBlock(headerHeight);
    
    //点击事件(label需要根据内容计算宽高，有待完善)
    [self.introducationLB setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        if ([link.linkValue isEqualToString:@"展开"]) {
            user.teacherInfoExpand = YES;
        } else {
            user.teacherInfoExpand = NO;
        }
        !weakSelf.moreClickBlock? : weakSelf.moreClickBlock(user);
    }];
}

- (CGFloat)parseUserContent:(HKUserModel *)user {
    
    CGFloat heightTotal = 138;
    
    if (user.content.length == 0) {
        self.introducationLB.text = @"";
        return heightTotal;
    }
    
    
    CGSize stringSize = [user.content boundingRectWithSize:CGSizeMake(UIScreenWidth - 25 * 2, CGFLOAT_MAX) options:1 attributes:@{NSFontAttributeName : self.introducationLB.font} context:nil].size;
    
    // 少于2行
    if (stringSize.height <= (self.introducationLB.font.lineHeight + 1.0) * 2) {
        heightTotal += stringSize.height + 0.5;
        self.introducationLB.text = user.content;
    } else { // 大于2行
        
        // 展开的
        if (user.teacherInfoExpand) {
            
            NSString *stringClose = [NSString stringWithFormat:@"%@收起", user.content];
           CGSize stringSize = [stringClose boundingRectWithSize:CGSizeMake(UIScreenWidth - 25 * 2, CGFLOAT_MAX) options:1 attributes:@{NSFontAttributeName : self.introducationLB.font} context:nil].size;
            
            NSString *destinationString = stringClose;
            NSMutableAttributedString *wholeAttrStr = [[NSMutableAttributedString alloc]initWithString:destinationString];
            [wholeAttrStr addAttribute:NSLinkAttributeName value:@"收起" range:NSMakeRange(wholeAttrStr.length - 2, 2)];
            [wholeAttrStr addAttribute:NSFontAttributeName value:self.introducationLB.font range:NSMakeRange(0, destinationString.length)];
            //[wholeAttrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(wholeAttrStr.length - 2, 2)];
            
            self.introducationLB.attributedText = wholeAttrStr;
            heightTotal += stringSize.height + 0.5;
        } else { // 收缩的
            
            NSString *destinationString = [self line3Char:user.content];
            NSMutableAttributedString *wholeAttrStr = [[NSMutableAttributedString alloc]initWithString:destinationString];
            [wholeAttrStr addAttribute:NSLinkAttributeName value:@"展开" range:NSMakeRange(wholeAttrStr.length - 2, 2)];
            [wholeAttrStr addAttribute:NSFontAttributeName value:self.introducationLB.font range:NSMakeRange(0, destinationString.length)];
            //[wholeAttrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(wholeAttrStr.length - 2, 2)];
            
            self.introducationLB.attributedText = wholeAttrStr;
            heightTotal += self.introducationLB.font.lineHeight * 2 + 0.5;
        }
    }
    
    return heightTotal;
}

- (NSString *)line3Char:(NSString *)content {
    
    for (NSInteger i = 1; i <= content.length; i++) {
        NSString *stringChar = [content substringToIndex:i];
        NSString * stringCharTemp = [NSString stringWithFormat:@"%@...展开", stringChar];
        CGSize size = [stringCharTemp boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 25, CGFLOAT_MAX) options:1 attributes:@{NSFontAttributeName : self.introducationLB.font} context:nil].size;
//        NSLog(@"%@ --- %@",stringCharTemp, NSStringFromCGSize(size));
        if (size.height > (self.introducationLB.font.lineHeight + 1) * 2) {
            return [[stringChar substringToIndex:stringChar.length - 1] stringByAppendingString:@"...展开"];
        }
    }
    
    return @"";
}



- (IBAction)shareBtnClick:(id)sender {
    
    if (self.user.share_data == nil) {
        ShareModel *share_data = [[ShareModel alloc] init];
        share_data.type = @"";
        share_data.title = @"title title";
        share_data.info = @"infoinfo info";
        share_data.img_url = @"http://img95.699pic.com/photo/40010/9549.jpg_wh300.jpg";
        share_data.web_url = @"https://huke88.com/course/1975.html";
        self.user.share_data = share_data;
    }
    
    !self.shareClickBlock? : self.shareClickBlock(self.user);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 头像圆形
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = self.headerIV.height * 0.5;
    [self addTapGesture];
    
    // 设置关注按钮
    self.followBtn.clipsToBounds = YES;
    self.followBtn.layer.cornerRadius = self.followBtn.height * 0.5;
//    self.followBtn.layer.borderWidth = 1;
//    self.followBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (IS_IPHONE_X) {
        self.headerTopC.constant = self.headerTopC.constant + 20;
        self.backBtnTop.constant = self.backBtnTop.constant + 20;
    }
}


- (void)addTapGesture {
    self.headerIV.userInteractionEnabled = YES;
    [self.headerIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
}


- (void)clickImage:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(teacherHeadImageClick:)]) {
        [self.delegate teacherHeadImageClick:nil];
    }
}




- (void)followBtnClick:(id)sender {
    !self.followBtnClickBlock? : self.followBtnClickBlock();
}


- (IBAction)backBtnClick:(id)sender {
    !self.backClickBlock?  : self.backClickBlock();
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 计算自身控件的高度
    CGFloat selfHeight = CGRectGetMaxY(self.followBtn.frame) + 20;
    !self.heightBlock? : self.heightBlock(selfHeight);
}

@end
