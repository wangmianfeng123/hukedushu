//
//  CategoryCell.h
//  Code
//
//  Created by Ivan li on 2017/8/21.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CategoryModel;

@interface CategoryCell : TBCollectionHighLightedCell

@property(nonatomic,strong)CategoryModel     *model;
/** 期待 不断更新 背景图 */
@property(nonatomic,strong)UIImageView     *bgImageView;

- (void)setImageWithName:(NSString*)name title:(NSString*)title angleImageName:(NSString*)angleImageName;

@end



