//
//  HKLiveMomentCell.h
//  Code
//
//  Created by Ivan li on 2021/1/18.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKMomentDetailModel;

@protocol HKLiveMomentCellDelegate <NSObject>
@optional
- (void)liveMomentCellDidAttentionBtn:(HKMomentDetailModel *)model;
- (void)liveMomentCellDidLikeBtn:(HKMomentDetailModel *)model;
- (void)liveMomentCellDidHeaderBtn:(HKMomentDetailModel *)model;
- (void)liveMomentCellDidCoverView:(HKMomentDetailModel *)model;
- (void)liveMomentCellDidShareBtn:(HKMomentDetailModel *)model;

@end

@interface HKLiveMomentCell : UITableViewCell
@property(nonatomic,weak) id<HKLiveMomentCellDelegate>delegate;
@property (nonatomic , strong) HKMomentDetailModel * model;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

NS_ASSUME_NONNULL_END
