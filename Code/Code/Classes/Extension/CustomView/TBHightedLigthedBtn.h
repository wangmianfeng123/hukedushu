//
//  TBHightedLigthedBtn.h
//  TBCoreData8
//
//  Created by hanchuangkeji on 2017/11/10.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.88
//

#import <UIKit/UIKit.h>


typedef enum {
    ButtonIndexBack = 0,// 0-子控件的最底层 默认
    ButtonIndexFont = 1,// 1-子控件的最上层
} ButtonIndex;

@interface TBHightedLigthedBtn : UIButton

@property (nonatomic, strong)UIColor *hightedLigthedColor;

@property (nonatomic, assign)ButtonIndex tb_hightedLigthedIndex;// 高亮View位于哪个一层

@property (nonatomic, assign)UIEdgeInsets tb_hightedLigthedInset;// 高亮图层的偏移量

@property (nonatomic, assign)CGFloat tb_cornerRadius;// 高亮的圆角
@end
