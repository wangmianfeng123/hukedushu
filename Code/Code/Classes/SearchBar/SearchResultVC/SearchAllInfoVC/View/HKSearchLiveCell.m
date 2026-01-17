//
//  HKSearchLiveCell.m
//  Code
//
//  Created by Ivan li on 2021/5/19.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKSearchLiveCell.h"
#import "UIView+HKLayer.h"
#import "HKImageTextIV.h"

@interface HKSearchLiveCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teacherAvator1;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UIImageView *teacherAvator2;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong)HKImageTextIV *animationIV; // 正在播放的动画

@end

@implementation HKSearchLiveCell

- (HKImageTextIV*)animationIV {
    if (!_animationIV) {
        _animationIV = [[HKImageTextIV alloc]init];
        _animationIV.isRemoveRoundedCorner = YES;
        _animationIV.liveAnimationType = HKLiveAnimationType_videoDetail;
    }
    return _animationIV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.descLabel.textColor = COLOR_7B8196_A8ABBE;
    self.teacherName.textColor = COLOR_7B8196_A8ABBE;
    self.rightBottomLabel.textColor = COLOR_7B8196_A8ABBE;
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
    self.bgView.backgroundColor = COLOR_F8F9FA_333D48;
    [self.bgView addCornerRadius:15];
    [self.iconImgV addCornerRadius:4];
    [self.teacherAvator1 addCornerRadius:10];
    [self.teacherAvator2 addCornerRadius:10];
    
    [self.contentView insertSubview:self.animationIV belowSubview:self.contentView];
    [self.animationIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.teacherAvator1);
//        make.left.mas_equalTo(SCREEN_WIDTH - 95);
        make.right.equalTo(self.bgView);
    }];
    
    
    self.timeIcon.image = [UIImage hkdm_imageWithNameLight:@"ic_duration_search_12_34" darkImageName:@"ic_duration_search_dark_12_34"];
    
    
}


-(void)setVideoModel:(VideoModel *)videoModel{
    _videoModel = videoModel;
    
    self.descLabel.text = _videoModel.label;
    
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:videoModel.cover]] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
    if (videoModel.teacher.count == 1) {
        HKLiveTeachModel * teacher = _videoModel.teacher[0];
        [self.teacherAvator1 sd_setImageWithURL:[NSURL URLWithString:teacher.avator] placeholderImage:HK_PlaceholderImage];
        self.teacherName.text = teacher.name;
        self.teacherAvator1.hidden = NO;
        self.teacherName.hidden = NO;
        self.teacherAvator2.hidden = YES;
    }else if (videoModel.teacher.count >= 2){
        HKLiveTeachModel * teacher = _videoModel.teacher[0];
        [self.teacherAvator1 sd_setImageWithURL:[NSURL URLWithString:teacher.avator] placeholderImage:HK_PlaceholderImage];
        self.teacherName.text = @"";
        HKLiveTeachModel * teacher1 = _videoModel.teacher[1];
        [self.teacherAvator2 sd_setImageWithURL:[NSURL URLWithString:teacher1.avator] placeholderImage:HK_PlaceholderImage];
        
        self.teacherAvator1.hidden = NO;
        self.teacherName.hidden = YES;
        self.teacherAvator2.hidden = NO;
    }else{
        self.teacherAvator1.hidden = YES;
        self.teacherName.hidden = YES;
        self.teacherAvator2.hidden = YES;
    }
    
    if ([videoModel.is_charge floatValue] > 0) {
        self.rightBottomLabel.text = videoModel.lessionAndLike ;
        self.timeIcon.hidden = YES;
        self.animationIV.hidden = YES;
        self.rightBottomLabel.hidden = NO;
    }else{
        if ([videoModel.live_status isEqualToString:@"1"]) {
                // 正在播放的动画
            self.animationIV.isAnimation = YES;// 正在播放
            [self.animationIV text:@"直播中" hiddenIfTextEmpty:NO];
            self.animationIV.hidden = NO;
            self.rightBottomLabel.hidden = YES;
            self.timeIcon.hidden = YES;
        }else{
            self.animationIV.hidden = YES;
            self.rightBottomLabel.hidden = NO;
            self.rightBottomLabel.text = videoModel.liveTime;
            self.timeIcon.hidden = NO;
        }
        
    }
    
    if ([videoModel.is_charge isEqualToString:@"0"]) {
        NSMutableAttributedString *attrString = [self addParagraphStyle:videoModel];
        self.titleLabel.attributedText = attrString;
    }else{
        self.titleLabel.text = videoModel.name;
    }
    
}

- (NSMutableAttributedString *)addParagraphStyle:(VideoModel *)model{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//行间距
    //清除首尾空格
    NSString *contentString = model.name;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_27323F_EFEFF6 range:NSMakeRange(0, attrString.length)];
    //self.firstCommentLabel.attributedText = attrString;
    
    //3.初始化NSTextAttachment对象
    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
    attchment.bounds = CGRectMake(0, -2, 50, 15);//设置frame
    attchment.image = [UIImage hkdm_imageWithNameLight:@"tag_live_search_2_24" darkImageName:@"tag_live_search_2_24"];//[UIImage imageNamed:@""];//设置图片
    
    //4.创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
    [attrString insertAttributedString:string atIndex:0];//插入到第几个下标

    return attrString;
}


@end
