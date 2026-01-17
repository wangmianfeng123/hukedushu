//
//  HKFiltrateView.h
//  Code
//
//  Created by Ivan li on 2020/12/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//@class HKMonmentTagModel;

@interface HKFiltrateView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) void(^cancelFiltrateBlock)(void);
//@property (nonatomic , strong) void(^callBackParams)(NSDictionary * dic);

@property (nonatomic , strong) NSArray * tagArray;
@property (nonatomic , assign) BOOL isMonmentVC ;//是否显示已学
//@property (nonatomic, strong) void(^sureFiltrateBlock)(HKMonmentTagModel * tagModel);

@end

NS_ASSUME_NONNULL_END
