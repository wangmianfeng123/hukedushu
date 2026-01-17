//
//  HKHomeVipHeader.h
//  Code
//
//  Created by ivan on 2020/6/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKHomeVipHeader : UICollectionReusableView

@property(nonatomic,strong)UILabel *grayLabel;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *tagLabel;

@property(nonatomic,strong)UIButton *moreBtn;

@property(nonatomic,copy)void (^moreBtnClickBlock) ();
/// 设置 更多按钮 title ，header 主题
- (void)setMoreBtnTitle:(NSString*)title  headerTitle:(NSString*)headerTitle;

@end

NS_ASSUME_NONNULL_END

