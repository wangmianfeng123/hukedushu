//
//  HKHomeJobPathGuideView.h
//  Code
//
//  Created by Ivan li on 2019/6/18.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKHomeJobPathGuideView : UIView

@property (nonatomic,assign)CGRect rect;

- (instancetype)initWithRect:(CGRect)frame row:(NSInteger)row indexPath:(NSIndexPath *)indexPath;

- (void)closeViewClick;

@end


NS_ASSUME_NONNULL_END

