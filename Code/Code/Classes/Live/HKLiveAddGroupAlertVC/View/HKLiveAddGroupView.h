//
//  HKLiveAddGroupView.h
//  Code
//
//  Created by Ivan li on 2018/12/10.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HKLiveAddGroupView : UIView

@property(nonatomic,strong)UIButton   *closeViewBtn;
/** 荣誉 图片 */
@property(nonatomic,strong)UIImageView *honorIV;

@property(nonatomic,strong)UILabel *honorLB;

@property(nonatomic,strong)UIButton   *pushBtn;
/** 删除 block */
@property(nonatomic,copy)void(^studyMedalCloseBlock)(UIButton *sender);
/** 跳转 block */
@property(nonatomic,copy)void(^studyMedalPushBlock)(UIButton *sender);

@end
