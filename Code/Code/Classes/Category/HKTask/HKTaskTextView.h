//
//  HKTaskTextView.h
//  Code
//
//  Created by Ivan li on 2018/7/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPlaceholderTextView.h"
#import "HKTaskCountBtn.h"


@class HKTaskDetailModel;

@protocol HKTaskTextViewDelegate <NSObject>

- (void)didClick:(id)sender;

@end

@interface HKTaskTextView : UIView<UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,weak)id <HKTaskTextViewDelegate> delegate;

@property (nonatomic,strong) HKTaskCountBtn *countBtn;

@property (nonatomic,strong) UIButton *tipBtn;

@property (nonatomic,strong) UILabel *countLB;

@property (nonatomic,strong)HKTaskDetailModel *model;

@end
