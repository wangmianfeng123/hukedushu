//
//  HKMyLiveCell.h
//  Code
//
//  Created by Ivan li on 2020/12/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKMyLiveModel,VideoModel;
@interface HKMyLiveCell : UITableViewCell
@property (nonatomic , strong) HKMyLiveModel * model;
@property (nonatomic , strong) VideoModel * videoModel;
@end

NS_ASSUME_NONNULL_END
