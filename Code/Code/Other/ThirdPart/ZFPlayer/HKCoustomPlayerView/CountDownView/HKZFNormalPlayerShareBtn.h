//
//  HKZFNormalPlayerShareBtn.h
//  Code
//
//  Created by Ivan li on 2018/1/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKZFNormalPlayerShareBtnDelegate <NSObject>

- (void)hKZFNormalPlayerShareAction:(id)sender;

@end

@interface HKZFNormalPlayerShareBtn: UIButton

@property(nonatomic,weak)id <HKZFNormalPlayerShareBtnDelegate>delegate;

@end

