//
//  HKBookRecordCell.h
//  Code
//
//  Created by Ivan li on 2019/8/20.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKBookRecordCell : UITableViewCell

@property (nonatomic,strong) HKBookModel *model;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,copy)void (^bookCellBlock)(HKBookModel  *model);
- (void)updateEditAllConstraints;

- (void)updateNoEditAllConstraints;

/**编辑状态下 点击 cell 选中 */
- (void)editSelectRow;


@end

NS_ASSUME_NONNULL_END
