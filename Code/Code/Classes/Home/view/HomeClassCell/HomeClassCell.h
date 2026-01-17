//
//  HomeClassCell.h
//  Code
//
//  Created by Ivan li on 2017/10/19.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeCategoryModel;

@class HKVerticalHomeBtn;

@interface HomeClassCell : TBCollectionHighLightedCell

@property(nonatomic,strong)HomeCategoryModel *model;

@property(strong,nonatomic)HKVerticalHomeBtn *btn;

@property (nonatomic,strong) UILabel *tagLabel;
@property (nonatomic, strong) UIImageView * toastImg;

@end
