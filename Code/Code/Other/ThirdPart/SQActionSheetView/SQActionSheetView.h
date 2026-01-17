//
//  SQActionSheetView.h
//  Code
//
//  Created by Ivan li on 2017/10/9.
//  Copyright © 2017年 yangsq. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface SQActionSheetView : UIView

@property (nonatomic, copy) void(^buttonClick)(SQActionSheetView *sheetView,NSInteger buttonIndex);

- (id)initWithTitle:(NSString *)title buttons:(NSArray <NSString *>*)buttons buttonClick:(void(^)(SQActionSheetView *sheetView,NSInteger buttonIndex))block;

- (void)showView;
@end
