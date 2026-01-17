//
//  HKChooseNoteCell.h
//  Code
//
//  Created by Ivan li on 2021/3/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKRecommendTxtModel;


@protocol HKChooseNoteCellDelegate <NSObject>

- (void)chooseNoteCellDidZanClick:(HKRecommendTxtModel * ) model;

@end

@interface HKChooseNoteCell : UICollectionViewCell
//@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic , strong) HKRecommendTxtModel * model;
@property(nonatomic,weak) id <HKChooseNoteCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
