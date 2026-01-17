//
//  HKNotesThumbsCell.h
//  Code
//
//  Created by Ivan li on 2021/1/5.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKNotiMessageModel;


@protocol HKNotesThumbsCellDelegate <NSObject>

- (void)myNotesThumbsCellModel:(HKNotiMessageModel *)messageModel;

@end


@class HKMyProductLikeCellModel,HKNotiMessageModel;
@interface HKNotesThumbsCell : UITableViewCell
@property (nonatomic , strong) HKMyProductLikeCellModel * model;
@property (nonatomic , strong) HKNotiMessageModel * messageModel;
@property (nonatomic , strong) NSNumber * tabID;
@property (nonatomic , strong) void(^didAvatorBlock)(void);
@property(nonatomic,weak) id<HKNotesThumbsCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
