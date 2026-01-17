//
//  HKVersionCodeCell.h
//  Code
//
//  Created by Ivan li on 2018/5/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKVersionCodeCell : UITableViewCell

+ (instancetype)initCellWithTableView:(UITableView *)tableview;

- (void)setVersion:(NSString*)version;

/** 设置背景 左侧圆角 */
- (void)setBgViewCorner;

@end
