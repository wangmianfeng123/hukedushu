//
//  HKLiveCommentHeaderView.h
//  Code
//
//  Created by Ivan li on 2020/12/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKLiveCommentModel;

@interface HKLiveCommentHeaderView : UIView
//@property (nonatomic , strong) HKLiveCommentModel * model;

@property (nonatomic , strong) NSString * countZh;

@property (nonatomic , assign) CGFloat allScore ;

@property (nonatomic , assign) int allStar ;

@end

NS_ASSUME_NONNULL_END
