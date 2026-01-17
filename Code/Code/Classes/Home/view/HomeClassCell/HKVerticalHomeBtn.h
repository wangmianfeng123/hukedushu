//
//  HKVerticalHomeBtn.h
//111

#import <UIKit/UIKit.h>
#import "TBHightedLigthedBtn.h"


@class  HKCustomMarginLabel;

@interface HKVerticalHomeBtn : TBHightedLigthedBtn

@property (nonatomic,strong) HKCustomMarginLabel *tagLabel;

@property (nonatomic,strong) UIView *tagBgView;

/** 显示小角标 */
- (void)showTagWithTitle:(NSString*)title;

@end


