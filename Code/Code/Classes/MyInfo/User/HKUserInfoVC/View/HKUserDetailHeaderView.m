//
//  HKUserDetailHeaderView.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKUserDetailHeaderView.h"
#import "MLLinkLabel.h"

@interface HKUserDetailHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *backBtn;// 返回

@property (weak, nonatomic) IBOutlet UILabel *nameLB;// 名字

@property (weak, nonatomic) IBOutlet UILabel *courseCount;// 教程数量
@property (weak, nonatomic) IBOutlet UIImageView *userVipIV;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;//编辑
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;

@property (weak, nonatomic) IBOutlet UILabel *moneyCountLb;
@property (weak, nonatomic) IBOutlet UILabel *learnCount; //已学视频数量
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;

@end




@implementation HKUserDetailHeaderView



- (void)setUser:(HKUserModel *)user {
    
    _user = user;
    // 头像
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:user.avator] placeholderImage:imageName(HK_Placeholder)];
    // 名字
    self.nameLB.text = user.username.length? user.username : user.name;
    //虎课币
    self.moneyCountLb.text = [NSString stringWithFormat:@"%@",isEmpty(user.gold) ?nil :user.gold];
    //学习课程
    self.learnCount.text = [NSString stringWithFormat:@"%@个教程", isEmpty(user.study_video_total) ?@"0" :user.study_video_total];
    
    self.userVipIV.image = [HKvipImage user_vipImageWithType:user.vip_class];
    //is_self：1-自己 2-别人
    self.editBtn.hidden = ![user.is_self isEqualToString:@"1"];
    
    if (IS_IPHONE_X) {
        self.topCons.constant = self.topCons.constant + 10;
    }
}



- (IBAction)editInfo:(id)sender {
    if (self.user.share_data == nil) {
        ShareModel *share_data = [[ShareModel alloc] init];
        share_data.type = @"";
        share_data.title = @"title title";
        share_data.info = @"infoinfo info";
        share_data.img_url = @"http://img95.699pic.com/photo/40010/9549.jpg_wh300.jpg";
        share_data.web_url = @"https://huke88.com/course/1975.html";
        self.user.share_data = share_data;
    }
    !self.editInfoClickBlock? : self.editInfoClickBlock(self.user);
}




- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 头像圆形
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = self.headerIV.height * 0.5;
    [self addTapGesture];
}



- (IBAction)backBtnClick:(id)sender {
    !self.backClickBlock?  : self.backClickBlock();
}


- (void)addTapGesture {
    self.headerIV.userInteractionEnabled = YES;
    [self.headerIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
}


- (void)clickImage:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(headImageClick:)]) {
        [self.delegate headImageClick:nil];
    }
}




@end
