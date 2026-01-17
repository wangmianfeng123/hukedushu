//
//  HKHomeArticleGuideView.h
//  Code
//
//  Created by Ivan li on 2018/8/9.
//  Copyright © 2018年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>

@class HKLineLabel;

@interface HKHomeArticleGuideView : UIView

@property (nonatomic,assign)CGRect rect;

- (instancetype)initWithRect:(CGRect)frame row:(NSInteger)row indexPath:(NSIndexPath *)indexPath;

- (void)closeViewClick;
@end
