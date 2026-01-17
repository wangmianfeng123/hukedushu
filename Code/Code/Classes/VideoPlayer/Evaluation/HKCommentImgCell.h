//
//  HKCommentImgCell.h
//  Code
//
//  Created by Ivan li on 2020/12/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKImgModel;

@interface HKCommentImgCell : UICollectionViewCell

//@property (nonatomic,strong) HKImgModel * model;
@property (nonatomic , strong) void(^deleteBtnBlock)(UIImage * img);
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end

NS_ASSUME_NONNULL_END
