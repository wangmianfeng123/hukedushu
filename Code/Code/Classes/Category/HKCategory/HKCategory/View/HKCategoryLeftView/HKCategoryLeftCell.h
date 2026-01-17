//
//  HKCategoryLeftCell.h
//  Code
//
//  Created by Ivan li on 2018/4/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKCategoryTreeModel,HKLeftMenuModel;

@interface HKCategoryLeftCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *rightLineView;

@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UILabel *signLabel;

@property (nonatomic, strong) HKCategoryTreeModel *model;

@property (nonatomic, strong) HKLeftMenuModel * menuModel;

@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic, strong) UIView *leftView;

@end

