//
//  HKInternetSubCell.h
//  Code
//
//  Created by Ivan li on 2021/7/12.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKLiveListModel;

@interface HKInternetSubCell : UICollectionViewCell

@property (nonatomic , assign) int isTrain ;
@property (nonatomic , strong) HKLiveListModel * liveModel;
@end

NS_ASSUME_NONNULL_END
