//
//  HKTaskTextView.h
//  Code
//
//  Created by Ivan li on 2018/7/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPlaceholderTextView.h"


@protocol HKTaskTextViewDelegate <NSObject>

- (void)didClick:(id)sender;

@end

@interface HKTaskTextView : UIView<UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,weak)id <HKTaskTextViewDelegate> delegate;

@property (nonatomic,strong) UIButton *countBtn;

@property (nonatomic,strong) UIButton *tipBtn;

@property(nonatomic,copy)NSString *title;

@end
