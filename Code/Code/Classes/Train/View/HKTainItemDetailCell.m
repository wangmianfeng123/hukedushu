//
//  HKTainItemDetailCell.m
//  Code
//
//  Created by hanchuangkeji on 2019/1/21.1
//  Copyright © 2019年 pg. All rights reserved.2
//

#import "HKTainItemDetailCell.h"
#import "UIButton+HKExtension.h"
#import "HKPunchClockModel.h"

@interface HKTainItemDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@property (weak, nonatomic) IBOutlet UIImageView *vipTagIV;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnH;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImgH;
@property (weak, nonatomic) IBOutlet UIView *lockView;

@end

@implementation HKTainItemDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.coverIV.clipsToBounds = YES;

    // 圆角处理
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = self.headerIV.height * 0.5;
    
    // 手势
    self.coverIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverIVTap)];
    [self.coverIV addGestureRecognizer:tap];
    self.headerIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerIVTap)];
    [self.headerIV addGestureRecognizer:tap2];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.nameLB.textColor = COLOR_27323F_EFEFF6;
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
}


- (void)headerIVTap {
    !self.userHeaderIVTapBlock? : self.userHeaderIVTapBlock(self.punchClockModel);
}

- (void)coverIVTap {
    !self.coverIVTapBlock? : self.coverIVTapBlock(self.punchClockModel);
}

-(void)setPunchClockModel:(HKPunchClockModel *)punchClockModel{
    
    _punchClockModel = punchClockModel;
        
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:punchClockModel.avator] placeholderImage:imageName(HK_Placeholder)];
    self.nameLB.text = punchClockModel.username;
    self.timeLabel.text = punchClockModel.created_at;
    self.resaonLabel.text = punchClockModel.del_reason;
    self.vipTagIV.image = [HKvipImage comment_vipImageWithType:[NSString stringWithFormat:@"%d",punchClockModel.vip_class]];
    
    self.titleLB.text = punchClockModel.task_desc;
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:punchClockModel.image_url]] placeholderImage:imageName(HK_Placeholder)];
    
    
    self.deleteBtnTopMargin.constant = punchClockModel.task_desc.length ? 10 : 0;
    [self.thumbsBtn setTitle:[punchClockModel.thumbs_up isEqualToString:@"0"] ? @"":punchClockModel.thumbs_up forState:UIControlStateNormal];
    if (punchClockModel.like) {
        [self.thumbsBtn setImage:[UIImage imageNamed:@"praise_red"] forState:UIControlStateNormal];
        [self.thumbsBtn setTitleColor:[UIColor colorWithHexString:@"FFB205"] forState:UIControlStateNormal];
    }else{
        [self.thumbsBtn setImage:[UIImage imageNamed:@"praise_gray"] forState:UIControlStateNormal];
        [self.thumbsBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
    }
    
    if (_punchClockModel.height == 0 || _punchClockModel.width == 0) {
        self.coverImgH.constant = 0.0;
    }else{
        CGFloat h = SCREEN_WIDTH * _punchClockModel.height /(CGFloat)_punchClockModel.width;
        if (h >= 450) {
            h = 450;
        }
        self.coverImgH.constant = h;
    }
}

- (IBAction)likeBtn:(UIButton *)sender {
    
    [sender buttonCommitAnimationWithAnimateDuration:0.2 Completion:^{
        !self.likeBlock? : self.likeBlock(self.punchClockModel);
        if (_punchClockModel.like) {
            [self.thumbsBtn setImage:[UIImage imageNamed:@"praise_gray"] forState:UIControlStateNormal];
            int count = [_punchClockModel.thumbs_up intValue]-1;
            [self.thumbsBtn setTitle: count? [NSString stringWithFormat:@"%d",[_punchClockModel.thumbs_up intValue]-1]:@"" forState:UIControlStateNormal];
            [self.thumbsBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        }else{
            [self.thumbsBtn setImage:[UIImage imageNamed:@"praise_red"] forState:UIControlStateNormal];
            [self.thumbsBtn setTitle:[NSString stringWithFormat:@"%d",[_punchClockModel.thumbs_up intValue]+1] forState:UIControlStateNormal];
            [self.thumbsBtn setTitleColor:[UIColor colorWithHexString:@"FFB205"] forState:UIControlStateNormal];
        }
    }];
}

- (IBAction)deleteBtnClick {
    !self.deleteBlock? : self.deleteBlock(self.punchClockModel);
}

-(void)setTypeString:(NSString *)typeString{
    if ([typeString isEqualToString:@"all"]) {
        self.thumbsBtn.hidden= NO;
        self.deteBtn.hidden = YES;
        self.deleteBtnLeftMargin.constant = 0.0;
        self.deleteBtnBottomMargin.constant = 10.0;
        self.deleteBtnW.constant = 0.0;
        self.deleteBtnH.constant = 30.0;
        self.lockView.hidden = YES;
        
    }else if ([typeString isEqualToString:@"my"]){
        self.thumbsBtn.hidden = NO;
        self.deteBtn.hidden = NO;
        self.deleteBtnLeftMargin.constant = 15;
        self.deleteBtnBottomMargin.constant = 10.0;
        self.deleteBtnW.constant = 22.0;
        self.deleteBtnH.constant = 22.0;
        self.lockView.hidden = YES;
    }else{
        //小黑屋
        self.thumbsBtn.hidden = YES;
        self.deteBtn.hidden = YES;
        self.deleteBtnLeftMargin.constant = 0.0;
        self.deleteBtnBottomMargin.constant = 0.0;
        self.deleteBtnH.constant = 0.0;
        self.lockView.hidden = NO;
    }    
}

@end
