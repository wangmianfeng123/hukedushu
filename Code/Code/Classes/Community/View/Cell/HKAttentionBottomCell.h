//
//  HKAttentionBottomCell.h
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKrecommendUserModel;

@protocol HKAttentionBottomCellDelegate <NSObject>

- (void)attentionBottomCellDidHeader:(HKrecommendUserModel *)model;
- (void)attentionBottomCellDidAttention:(HKrecommendUserModel *)model;

@end

@interface HKAttentionBottomCell : UITableViewCell
@property (nonatomic , strong) NSMutableArray * dataArray;
@property(nonatomic,weak) id<HKAttentionBottomCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
