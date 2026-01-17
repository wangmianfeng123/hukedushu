//
//  HKAlbumDetailHeadView.h
//  Code
//
//  Created by Ivan li on 2017/12/3.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKAlbumListModel;

//typedef void(^QuitOrCollectAlbumBlock)(HKAlbumListModel *model);

@protocol HKAlbumDetailHeadViewDelegate <NSObject>

@optional
- (void)collectAblumList:(id)model;

@end




@interface HKAlbumDetailHeadView : UITableViewHeaderFooterView

@property(nonatomic,weak)id <HKAlbumDetailHeadViewDelegate>delegate;

@property(nonatomic,strong)HKAlbumListModel *model;
/** 收藏 或 取消 */
@property(nonatomic,copy)void(^quitOrCollectAlbumBlock)(HKAlbumListModel *model);
/** 编辑专辑 */
@property(nonatomic,copy)void(^editMyAlbumBlock)(HKAlbumListModel *model);

@property(nonatomic,copy)NSString  *collectBtnTitle;
/** YES-用户创建的专辑 */
@property(nonatomic,assign)BOOL isMyAblum;

- (void)hiddenCollectBtn;

@end
