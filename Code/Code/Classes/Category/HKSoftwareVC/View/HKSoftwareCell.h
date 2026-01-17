//
//  HKSoftwareCell.h
//  Code
//
//  Created by Ivan li on 2018/4/1.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKSoftwareCell : UITableViewCell

+ (instancetype)initCellWithTableView:(UITableView *)tableview;

@property(nonatomic,strong)VideoModel *model;

@property(nonatomic,assign)NSInteger type;

- (void)setModel:(VideoModel *)model type:(NSInteger)type;

@end

