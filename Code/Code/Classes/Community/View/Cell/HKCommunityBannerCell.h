//
//  HKCommunityBannerCell.h
//  Code
//
//  Created by Ivan li on 2021/6/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKADdataModel;

@interface HKCommunityBannerCell : UITableViewCell
@property (nonatomic , strong) NSMutableArray <HKADdataModel *>* ad_data;
@property (nonatomic , strong) void(^didImgBlock)(HKADdataModel * model);

@end

NS_ASSUME_NONNULL_END
