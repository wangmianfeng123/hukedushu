//
//  TeacherInfoCollectionCell.h
//  Code
//
//  Created by Ivan li on 2017/12/11.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TeacherInfoCollectionCellDelegate <NSObject>

@optional
- (void)CollectionCellFocusTeacher:(id)sender;

@end

@class HKUserModel;

@interface TeacherInfoCollectionCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *fanCountLabel;

@property(nonatomic,strong)UILabel *videoCountLabel;

@property(nonatomic,strong)HKUserModel *userInfo;

@property(nonatomic,readwrite,strong)UILabel *lineLabel;

@property(nonatomic,strong)UIButton *focusBtn;

@property (nonatomic, copy)void(^avatorClickBlock)();// 头像点击的block

@property(nonatomic,weak)id <TeacherInfoCollectionCellDelegate> delegate;

@property(nonatomic,strong)UILabel *honorLabel;

@end


