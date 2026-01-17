//
//  HKContainerTagFlowLayout.h
//  Code
//
//  Created by Ivan li on 2017/12/19.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const UICollectionElementKindSectionFooter;

@class HKContainerTagFlowLayout;
@protocol HKContainerTagFlowLayoutDelegate <NSObject>
@required
/*
 item heigh 设置第一个cell  的宽高
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HKContainerTagFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath;

@optional
/*
 设置collection 的头视图的size
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(HKContainerTagFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
/*
 section footer 设置collection footer 视图的size
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(HKContainerTagFlowLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
@end

@interface HKContainerTagFlowLayout : UICollectionViewLayout

@property(nonatomic, assign)UIEdgeInsets sectionInset; //cell 间距
@property(nonatomic, assign)CGFloat lineSpacing;  //line space
@property(nonatomic, assign)CGFloat itemSpacing; //item space
@property(nonatomic, assign)CGFloat colCount; //设置colleciton 的列数
@property(nonatomic, weak)id<HKContainerTagFlowLayoutDelegate> delegate;

@end
