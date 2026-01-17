//
//  HKCategoryLeftView.h
//  Code
//
//  Created by Ivan li on 2018/4/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKLeftMenuModel;

//typedef void(^cellClickBlock)(NSInteger index,NSString *_id,HKCategoryType categoryType);
typedef void(^cellClickBlock)(NSInteger index,NSString *_id,HKLeftMenuModel * leftMenuModel);

@interface HKCategoryLeftView : UITableView

@property (nonatomic, copy) cellClickBlock cellClickBlock;

@property (nonatomic, strong) NSMutableArray *leftDataArray;

- (void)updateWithIndex:(NSInteger )index;

/**
 *  设置选中几号 item（默认第一项）
 */
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) NSInteger defalutSelectedIndex;


// 选中第几个
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
