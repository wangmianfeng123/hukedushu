//
//  HKMomentCell.h
//  Code
//
//  Created by Ivan li on 2021/1/18.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKMomentDetailModel;

@protocol HKMomentCellDelegate <NSObject>
@optional
- (void)momentCellDidAttentionBtn:(HKMomentDetailModel *)model;
- (void)momentCellDidLikeBtn:(HKMomentDetailModel *)model;
- (void)momentCellDidCommentBtn:(HKMomentDetailModel *)model;
- (void)momentCellDidHeaderBtn:(HKMomentDetailModel *)model;
- (void)momentCellDidImgArray:(NSMutableArray *)imgArray andIndex:(NSInteger)index;
- (void)momentCellDidCourseView:(HKMomentDetailModel *)model;
- (void)momentCellDidTagBtn:(HKMomentDetailModel *)model;
- (void)momentCellDidCourseAvator:(HKMomentDetailModel *)model;
- (void)momentCellDidShareBtn:(HKMomentDetailModel *)model;
- (void)momentCellDidTotalLabel:(NSIndexPath *)indexPath;

@end

@interface HKMomentCell : UITableViewCell
@property(nonatomic,weak) id<HKMomentCellDelegate>delegate;

@property (nonatomic , strong) HKMomentDetailModel * model;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic , strong) NSIndexPath * indexPath;
@end

NS_ASSUME_NONNULL_END
