//
//  HKHomeAlbumSubCell.h
//  Code
//
//  Created by yxma on 2020/11/11.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKAlbumModel;

@interface HKHomeAlbumSubCell : UICollectionViewCell

@property (nonatomic , strong) VideoModel * videoModel;

@property (nonatomic , strong) HKAlbumModel * albumModel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic , assign) BOOL isVideoDetail;

- (void)setModel:(HKCourseModel *)model videoType:(HKVideoType)videoType;



@end

NS_ASSUME_NONNULL_END
