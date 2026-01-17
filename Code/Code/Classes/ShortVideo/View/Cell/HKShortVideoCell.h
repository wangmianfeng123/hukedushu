//
//  HKShortVideoCell.h
//  Code
//
//  Created by Ivan li on 2019/3/25.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYLabel.h>

@class HKShortVideoModel,HKShortVideoCell;

NS_ASSUME_NONNULL_BEGIN

@protocol HKShortVideoCellDelegate <NSObject>

@optional

// 点赞
- (void)hkShortVideoCell:(HKShortVideoCell*)view likeBtn:(UIButton*)likeBtn model:(HKShortVideoModel *)model;

// 评论
- (void)hkShortVideoCell:(HKShortVideoCell*)view commentBtn:(UIButton*)commentBtn model:(HKShortVideoModel *)model;

// 分享
- (void)hkShortVideoCell:(HKShortVideoCell*)view shareBtn:(UIButton*)shareBtn model:(HKShortVideoModel *)model;

// 关注
- (void)hkShortVideoCell:(HKShortVideoCell*)view followBtn:(UIButton*)followBtn model:(HKShortVideoModel *)model;

// 点击用户头像
- (void)hkShortVideoCell:(HKShortVideoCell*)view userBtn:(UIButton*)userBtn  model:(HKShortVideoModel *)model;
///相关视频按钮
- (void)hkShortVideoCell:(HKShortVideoCell*)view relatedVideoBtn:(UIButton*)relatedVideoBtn  model:(HKShortVideoModel *)model;
///标签点击
- (void)hkShortVideoCell:(HKShortVideoCell*)view tagView:(UIView*)tagView  model:(HKShortVideoModel *)model;

@end


@interface HKShortVideoCell : UITableViewCell

@property (nonatomic, strong)HKShortVideoModel *videoModel;

@property (nonatomic, strong) UIButton *followBtn;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) YYLabel *likeLB;

@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) UILabel *commentLB;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UILabel *shareLB;

/** 显示 toptool 背景 */
@property(nonatomic,assign ,getter=isShowTopTool)BOOL showTopTool;

@property (nonatomic, weak)id <HKShortVideoCellDelegate> delegate;
/** 自动点击 点赞 */
- (void)autoLikeBtnClick;
/** 隐藏播放按钮 */
- (void)hiddenPlayBtn;
/** 隐藏底部view */
- (void)hiddenBottomToolView;

@end


NS_ASSUME_NONNULL_END
