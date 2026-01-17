//
//  HKDownloadQABottomView.h
//  Code
//
//  Created by hanchuangkeji on 2018/3/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKDownloadQABottomViewDelegate <NSObject>

- (void)questionBtnClick;

@end

@interface HKDownloadQABottomView : UIView

@property (nonatomic, weak)id<HKDownloadQABottomViewDelegate> delegate;

@end
