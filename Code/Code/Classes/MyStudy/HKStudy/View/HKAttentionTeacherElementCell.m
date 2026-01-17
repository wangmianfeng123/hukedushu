//
//  HKAttentionTeacherElementCell.m
//  Code
//
//  Created by yxma on 2020/9/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKAttentionTeacherElementCell.h"
#import "UIView+HKLayer.h"
#import "HKFollowTeacherModel.h"


@interface HKAttentionTeacherElementCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UIView *boderView;//最外层散光的view
@property (weak, nonatomic) IBOutlet UIView *redInnerRingView; //红色内边框view
@property (weak, nonatomic) IBOutlet UILabel *signLabel;//直播中
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *redPointView;//红点
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (nonatomic , assign) BOOL isAnitaiton ;
@end

@implementation HKAttentionTeacherElementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.headerImgView addCornerRadius:27.5];
    [self.moreLabel addCornerRadius:27.5];
    [self.boderView addCornerRadius:30 addBoderWithColor:[UIColor colorWithHexString:@"#FF4E4E"] BoderWithWidth:0.8];
    [self.signLabel addCornerRadius:8 addBoderWithColor:[UIColor whiteColor]];
    self.nameLabel.textColor = COLOR_27323F_EFEFF6;
}

- (void)zoomView {
    _isAnitaiton = YES;
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.boderView.transform = CGAffineTransformMakeScale(1.15, 1.15); // 边框放大
        self.boderView.alpha = 0.08; // 透明度渐变
    } completion:^(BOOL finished) {
        // 恢复默认
        self.boderView.transform = CGAffineTransformMakeScale(1, 1);
        self.boderView.alpha = 1;
        
        
        BOOL show = [self isDisplayedInScreen:self.boderView];
        if (show) {
            // 缩放动画
            [self zoomView];
        }else{
            _isAnitaiton = NO;
        }
        NSLog(@"-------%d",show);
    }];
}

-(void)setTeacherModel:(HKFollowTeacherModel *)teacherModel{
    _teacherModel = teacherModel;
    
    self.boderView.hidden = teacherModel.status == 1 ? NO : YES;
    self.redInnerRingView.hidden = teacherModel.status == 1 ? NO : YES;
    self.signLabel.hidden = teacherModel.status == 1 ? NO : YES;
    self.redPointView.hidden = teacherModel.status == 2 ? NO : YES;
    self.nameLabel.hidden = NO;
    self.nameLabel.text = teacherModel.name;
    self.headerImgView.hidden = NO;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:teacherModel.avator]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_isAnitaiton) {
        // 缩放动画
        [self zoomView];
    }
}

-(void)setIsShowMore:(BOOL)isShowMore{
    _isShowMore = isShowMore;
    self.headerImgView.hidden = isShowMore;
    self.moreLabel.hidden = !isShowMore;
    self.nameLabel.hidden = isShowMore;
    self.boderView.hidden = isShowMore;
    self.redInnerRingView.hidden = isShowMore;
    self.signLabel.hidden = isShowMore;
    self.redPointView.hidden = isShowMore;
}


// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen:(UIView *)subV
{
    if (subV == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [subV convertRect:subV.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (subV.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (subV.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return TRUE;
    }
    return FALSE;
    
}

@end
