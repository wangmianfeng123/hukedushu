//
//  DetailActionView.h
//  Code
//
//  Created by Ivan li on 2017/10/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKDownloadModel.h"


typedef enum {
    collectStateFale = 0,
    collectStateTrue = 1,
} CollectState;

@class DetailModel;


@class HKDownloadModel;

@protocol DetailActionViewDelegate <NSObject>

@optional

- (void)collectionOrQuitVideo:(DetailModel *)downloadModel;

- (void)shareVideo:(DetailModel *)detailModel;
/** 收藏专辑 */
- (void)collectionAlbum:(DetailModel *)detailModel;

@end


typedef void(^CollectVideoBlock)(DetailModel *downloadModel);
//
typedef void(^LoadVideoBlock)(HKDownloadModel *downloadModel,DetailModel *detailModel, HKDownloadStatus dowloadStatus);



@interface DetailActionView : UIView
/** 收藏 */
@property(nonatomic,strong)UIButton *collectBtn;
/** 下载 */
@property(nonatomic,strong)UIButton *downloadBtn;
/** 分享 */
@property(nonatomic,strong)UIButton *shareBtn;
/** 专辑 */
@property(nonatomic,strong)UIButton *containerBtn;

/** 收藏视频 */
@property(nonatomic,copy)CollectVideoBlock  collectVideoBlock;
/** 下载视频 */
@property(nonatomic,copy)LoadVideoBlock  loadVideoBlock;

@property(nonatomic,strong)DetailModel  *detailModel;

@property(atomic,strong)HKDownloadModel *downloadModel;

@property(nonatomic,assign)CollectState collectState;

@property(nonatomic,assign)NSInteger netWorkStatus;

@property(nonatomic,weak)id <DetailActionViewDelegate> delegate;

@property(nonatomic,copy)void(^beginBlock)();

@property (nonatomic , strong) UILabel * materialLabel;

@end

