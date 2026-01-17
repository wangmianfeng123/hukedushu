//
//  HKEditAblumInfoCell.h
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPlaceholderTextView.h"


@protocol HKEditAblumInfoCellDelegate <NSObject>

@optional

/**
 TextView 文本内容
 @param text
 */
- (void)albumInfo:(NSString*)text;

@end

@interface HKEditAblumInfoCell : UITableViewCell <UITextViewDelegate>

@property(nonatomic,strong)UIImageView *coverImageView;

@property(nonatomic,strong)HKPlaceholderTextView *placeholderTextView;

@property(nonatomic,weak)id <HKEditAblumInfoCellDelegate>delegate;
/** 简介 */
@property(nonatomic,copy)NSString *introduceText;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end



