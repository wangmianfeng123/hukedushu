//
//  HKMyInfoVipAdCell.h
//  Code
//
//  Created by Ivan li on 2019/4/12.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HKMyInfoNotLoginCellDelegate <NSObject>

- (void)notLoginBtnDidClick:(UIButton *_Nullable)btn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HKMyInfoNotLoginCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tagLB;

@property (nonatomic, weak) id<HKMyInfoNotLoginCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
