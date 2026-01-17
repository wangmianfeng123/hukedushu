//
//  HomeRecomdCell.h
//  Code
//
//  Created by Ivan li on 2017/10/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^changeVideoBlock)();


@interface HomeRecommendeFooterMoreCell : UICollectionReusableView

@property(nonatomic,copy)changeVideoBlock changeVideoBlock;

@property(nonatomic,strong)UIButton *changeBtn;

@end
