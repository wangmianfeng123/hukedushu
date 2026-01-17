//
//  ScrollButtonView.h
//  Code
//
//  Created by Ivan li on 2017/9/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



#define ColorWithRGB(r,g,b,p)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:p]
typedef void(^Myblock)(NSInteger index);

/**
 *   顶部按钮：
 */
@interface ScrollButtonView : UIView

/**
 *   block
 */
@property (nonatomic,strong)Myblock block;
/**
 *  文字
 */

@property (strong ,nonatomic) NSArray * butTitles;

/**
 *  图片
 */

@property (strong ,nonatomic) NSArray * butImages;



/**
 *  滚动视图:
 */

@property (strong ,nonatomic) UIScrollView * scroller;


- (instancetype)initWithFrame:(CGRect)frame
                 andTitlesArr: (NSArray *)titles
                  andImageArr: (NSArray *)images
                  andTapBlock: (Myblock)block;


@end
