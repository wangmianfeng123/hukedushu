//
//  HKStudyTagCell.h
//  Code
//
//  Created by Ivan li on 2018/5/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKStudyTagModel;

@interface HKStudyTagCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *typeLabel;

@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic,strong) HKStudyTagModel *model;

@property (nonatomic,strong)UIImage *selectedImage;

@property (nonatomic,strong)UIImage *normalImage;


@end
