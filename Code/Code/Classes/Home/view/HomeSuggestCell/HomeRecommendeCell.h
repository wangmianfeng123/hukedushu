//
//  HomeRecomdCell.h
//  Code
//
//  Created by Ivan li on 2017/10/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^changeVideoBlock)();


@interface HomeRecommendeCell : UICollectionReusableView

@property(nonatomic,strong)UILabel *grayLabel;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *freeLabel;

@property(nonatomic,strong)UILabel *rightTitleLabel;

@property(nonatomic,strong)UILabel *tagLabel;

@property(nonatomic,strong)UIButton *changeBtn;

@property(nonatomic,copy)changeVideoBlock changeVideoBlock;

- (void)setUpdate_video_total:(NSString *)video_total;
- (void)changeMas_makeConstraints:(CGFloat)margin;
@end
