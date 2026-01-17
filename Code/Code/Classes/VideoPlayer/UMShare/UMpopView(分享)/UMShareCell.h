//
//  UMShareCell.h
//  Code
//／／
//  Created by Ivan li on 2017/11/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMShareCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UIButton *iconBtn;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,copy)NSString *imageName;

@property(nonatomic,copy)NSString *title;

@end
