//
//  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;     }     return self; }   HomeSuggestCell.h
//  Code
//
//  Created by Ivan li on 2017/9/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VideoModel;

@interface HomeSuggestCell : TBCollectionHighLightedCell

@property(nonatomic,copy)VideoModel *model;


@end





@interface HomeSuggestRightCell : TBCollectionHighLightedCell

@property(nonatomic,copy)VideoModel *model;

@end


@interface HomeSuggestiPadCell : TBCollectionHighLightedCell

@property(nonatomic,copy)VideoModel *model;

@end


@interface HomeSuggestiPadMiddleCell : TBCollectionHighLightedCell

@property(nonatomic,copy)VideoModel *model;

@end


@interface HomeSuggestiPadRightCell : TBCollectionHighLightedCell

@property(nonatomic,copy)VideoModel *model;

@end
