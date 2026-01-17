//
//  SeriseCourseHeaderView.h
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SeriseCourseHeaderViewDelegate <NSObject>
@optional
- (void)allCourserAction:(id)sender;
@end

@interface SeriseCourseHeaderView : UIView

@property(nonatomic,weak)id <SeriseCourseHeaderViewDelegate>delegate;

- (void)setCourseBtnByTitle:(NSString*)title;

@end
