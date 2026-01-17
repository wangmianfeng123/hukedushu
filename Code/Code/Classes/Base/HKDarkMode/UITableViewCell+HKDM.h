//
//  UITableViewCell+HK.h
//  Code
//
//  Created by ivan on 2020/3/12.
//  Copyright © 2020 pg. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (HKDM)

/** 设置背景色 */
- (void)set_DMContentViewBGColor;
/** 分割线背景色 */
- (UIColor*)separatorLineBGColor;

@end



@interface UICollectionViewCell (HKDM)

/** 设置背景色 */
- (void)set_DMContentViewBGColor;
/** 分割线背景色 */
- (UIColor*)separatorLineBGColor;

@end

NS_ASSUME_NONNULL_END
