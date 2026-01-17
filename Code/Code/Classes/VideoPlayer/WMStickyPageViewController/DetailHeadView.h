//
//  DetailHeadView.h
//  Code
//
//  Created by Ivan li on 2017/10/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYLabel.h>

@class DetailModel,HKCustomMarginLabel;


@interface DetailHeadView : UIView



@property(nonatomic,strong)UIButton *praticeBtn;// 练习题按钮

@property(nonatomic,strong)HKCustomMarginLabel *categoryLabel;

@property(nonatomic,strong)UILabel *learnedTimesLB;

@property(nonatomic,strong)UILabel *difficultLB;

@property(nonatomic,strong)DetailModel *detaiModel;

@property(nonatomic, copy)void(^praticeBtnClickBlock)();

@property(nonatomic,strong)UILabel *totalLB;

@property(nonatomic,assign)CGFloat textHeight;
/** 视频时长 */
@property(nonatomic,strong)UILabel *videoTimeLB;

@property(nonatomic,strong)UIView *certificateBgView;

@property(nonatomic,strong)UIImageView *certificateIV;

@property(nonatomic,strong)UILabel *certificateLB;

@property(nonatomic, copy)void(^certificateBgViewClickBlock)(DetailModel *detaiModel);



@end

