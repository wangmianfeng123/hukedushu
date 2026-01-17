//
//  HKCategoryLeftView.m
//  Code
//
//  Created by Ivan li on 2018/4/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCategoryLeftView.h"
#import "HKCategoryLeftCell.h"
#import "HKCategoryTreeModel.h"

@interface HKCategoryLeftView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HKCategoryLeftView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = COLOR_F8F9FA;
        self.delegate = self;
        self.rowHeight = 60;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = true;
        self.selectedIndex = 0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[HKCategoryLeftCell class] forCellReuseIdentifier:@"cellId"];
        self.scrollEnabled = NO;
        //self.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        self.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return self;
}

- (void)setLeftDataArray:(NSMutableArray *)leftDataArray{
    if (!_leftDataArray) {
        _leftDataArray = leftDataArray;
    }
    [self reloadData];
}



- (void)updateWithIndex:(NSInteger )index {
    if(index == self.selectedIndex) return;
    NSInteger lastIndex = self.selectedIndex;
    self.selectedIndex = index;
    if (self.selectedIndex >= self.leftDataArray.count) return;
    [self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedIndex inSection:0],[NSIndexPath indexPathForRow:lastIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    CGFloat offset = cell.center.y - self.frame.size.height * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    CGFloat maxOffset  = self.contentSize.height - self.frame.size.height;
    if (maxOffset < 0) {
        maxOffset = 0;
    }
    if (offset > maxOffset) {
        offset = maxOffset;
    }
//    [self setContentOffset:CGPointMake(0, offset) animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _leftDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCategoryLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
//    HKCategoryTreeModel *model = _leftDataArray[row];
//    cell.model = model;
    
    cell.menuModel = _leftDataArray[row];
    
    if(indexPath.row == self.selectedIndex){
        cell.isSelected = YES;
    }else {
        cell.isSelected = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSInteger row = indexPath.row;
    if(row == self.selectedIndex) return;
    if (row >= self.leftDataArray.count) return;
    [self updateWithIndex:indexPath.row];
    
    NSString *temp = [NSString stringWithFormat:@"%ld",(long)row];
    HKLeftMenuModel *model = _leftDataArray[row];
    BLOCK_EXEC(self.cellClickBlock,row,temp,model);

    //BLOCK_EXEC(self.cellClickBlock,row,temp,model.categoryType);
}


@end
