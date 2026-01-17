//
//  MyDownloadBottomView.h
//  Code
//
//  Created by Ivan li on 2017/8/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark - 全选回调
typedef void(^AllSelectedBlock)(UIButton *btn);

#pragma mark - 删除回调
//typedef void(^DeleteBlock)();
typedef void(^DeleteBlock)(UIButton *btn);

@interface MyDownloadBottomView : UIView


@property(nonatomic,copy)AllSelectedBlock  allSelectBlock;

@property(nonatomic,copy)DeleteBlock  deleteBlock;

@property(nonatomic,strong)UIButton  *checkBoxBtn;

@property(nonatomic,strong)UIButton  *deleteBtn;

@property(nonatomic,strong)UILabel  *lineLabel;

@property(nonatomic,strong)UIColor *checkTitlNormalColor;

@property(nonatomic,strong)UIColor *checkTitlSelectedColor;

@property(nonatomic,strong)UIColor *deleteTitlNormaColor;

@property(nonatomic,strong)UIColor *deleteTitlSelectedColor;

@property(nonatomic,strong)UILabel  *topLineLabel;

@end


