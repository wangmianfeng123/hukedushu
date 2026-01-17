//
//  HKContainerListCell.h
//  Code
//
//  Created by Ivan li on 2017/11/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



@class HKBookCoverImageView ,HKBookModel;

@interface HKHomeBookCell : UICollectionViewCell

@property (nonatomic, strong)NSMutableArray<HKBookModel *> *book_data; // 书籍

@property (nonatomic, copy)void(^bookBlock)(HKBookModel *book);

@property (nonatomic,strong) HKBookCoverImageView *coverIV;

@property (nonatomic,strong) HKBookModel *model;
@property (strong, nonatomic)  UIView *lineView;

@end









