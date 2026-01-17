//
//  HKSoftwareRecommenHeadView.h
//  Code
//
//  Created by Ivan li on 2018/4/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKSoftwareRecommenHeadViewDelegate <NSObject>

@optional
- (void)hkSoftwareHeadViewCloseBtnClick:(id)sender;

@end

@interface HKSoftwareRecommenHeadView : UIView

@property (nonatomic,  weak)id<HKSoftwareRecommenHeadViewDelegate> delegate;

@property(nonatomic,copy)NSString *softwareName;

@end
