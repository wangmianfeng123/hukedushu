//
//  HKWorksMomentCell.h
//  Code
//
//  Created by Ivan li on 2021/1/19.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKMomentDetailModel;

@protocol HKWorksMomentCellDelegate <NSObject>

- (void)worksMomentCellDidAttentionBtn:(HKMomentDetailModel *)model;
- (void)worksMomentCellDidLikeBtn:(HKMomentDetailModel *)model;
- (void)worksMomentCellDidHeaderBtn:(HKMomentDetailModel *)model;
- (void)worksMomentCellDidImgs:(NSMutableArray *)imgs index:(NSInteger)index;
- (void)worksMomentCellDidShareBtn:(HKMomentDetailModel *)model;

@end

@interface HKWorksMomentCell : UITableViewCell
@property (nonatomic , strong) HKMomentDetailModel * model;
@property(nonatomic,weak) id<HKWorksMomentCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

NS_ASSUME_NONNULL_END
