//
//  TBCollectionHighLightedCell.h.h
//  TBScrollViewEmpty
//
//  Created by 汤彬 on 2017/11/11.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    CollectionViewIndexBack = 0,// 0-cell子控件的最底层 默认
    CollectionViewIndexFont = 1,// 1-cell子控件的最上层
    CollectionViewIndexContentViewBack = 2,// 2-contentView子控件的最上层
} CollectionViewIndex;

@interface TBCollectionHighLightedCell : UICollectionViewCell

@property (nonatomic, strong)UIColor *hightedLigthedColor;// 高亮的背景颜色

@property (nonatomic, assign)CGFloat tb_cornerRadius;// 高亮的圆角

@property (nonatomic, assign)CollectionViewIndex tb_hightedLigthedIndex;// 高亮View位于哪个一层
@property (nonatomic, assign)UIEdgeInsets tb_hightedLigthedInset;// 高亮图层的偏移量
@end
