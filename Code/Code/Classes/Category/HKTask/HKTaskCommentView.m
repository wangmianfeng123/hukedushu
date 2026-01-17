//
//  HKTaskCommentView.m
//  Code
//
//  Created by Ivan li on 2018/7/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskCommentView.h"
#import "HKTaskDetailUserCommentCell.h"
#import "HKTaskModel.h"


@interface HKTaskCommentView () <UITableViewDelegate,UITableViewDataSource>


@end

@implementation HKTaskCommentView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        [self setUpView];
    }
    return self;
}



- (void)setUpView {
    
    self.tableFooterView = [UIView new];
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
    self.scrollEnabled = NO;
//    self.estimatedRowHeight = 30;
//    self.rowHeight = UITableViewAutomaticDimension;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataSource = self;
    self.delegate = self;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
//    self.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
}


- (void)setModel:(HKTaskModel *)model {
    _model = model;
    [self reloadData];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.reply_list.count ? 1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.reply_list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"self.model.reply_list[indexPath.row] ---- %f",self.model.reply_list[indexPath.row].headViewHeight);
    return  self.model.reply_list[indexPath.row].headViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKTaskDetailUserCommentCell *cell = [HKTaskDetailUserCommentCell initCellWithTableView:tableView row:indexPath.row];
    cell.commentM = self.model.reply_list[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
