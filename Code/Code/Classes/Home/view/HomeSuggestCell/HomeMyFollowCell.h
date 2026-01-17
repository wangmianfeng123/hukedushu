//
//  HomeRecomdCell.h
//  Code
//
//  Created by Ivan li on 2017/10/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^moreFollowBlock)();


@interface HomeMyFollowCell : UICollectionReusableView

@property(nonatomic,strong)UILabel *grayLabel;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *tagLabel;

@property(nonatomic,strong)UIView *bottomSeparator;

@property(nonatomic,strong)UIButton *changeBtn;

@property(nonatomic,copy)moreFollowBlock moreFollowBlock;

@property (nonatomic, assign)NSInteger follow_list_type;//1-我的关注列表 2-推荐讲师列表;


@end
