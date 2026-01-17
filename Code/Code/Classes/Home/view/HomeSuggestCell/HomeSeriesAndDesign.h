//
//  HomeRecomdCell.h
//  Code
//
//  Created by Ivan li on 2017/10/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^moreSeriesAndDesignBlock)();


@interface HomeSeriesAndDesign : UICollectionReusableView

@property(nonatomic,strong)UILabel *grayLabel;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *tagLabel;

@property(nonatomic,strong)UIButton *changeBtn;

@property(nonatomic,copy)moreSeriesAndDesignBlock moreSeriesAndDesignBlock;



@end
