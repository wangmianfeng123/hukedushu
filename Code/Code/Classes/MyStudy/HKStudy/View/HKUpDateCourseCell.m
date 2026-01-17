//
//  HKUpDateCourseCell.m
//  Code
//
//  Created by yxma on 2020/9/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKUpDateCourseCell.h"
#import "LPAutoScrollView.h"
//#import "LPView.h"
#import "LPImageContentView.h"
#import "HKCycleContentView.h"

@interface HKUpDateCourseCell ()<LPAutoScrollViewDatasource, LPAutoScrollViewDelegate>
@property (nonatomic, weak) LPAutoScrollView *scrollView;
//@property (nonatomic, strong) NSMutableArray *titlesArray;
@end

@implementation HKUpDateCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.titlesArray = [NSMutableArray array];
//
//    for (int i = 0; i < 3; i ++) {
//        [self.titlesArray addObject:[NSString stringWithFormat:@"%d + avbdsgsdg", i]];
//    }
    [self createCycleView];
}

- (void)createCycleView{
    LPAutoScrollView *scrollView = [[LPAutoScrollView alloc] initWithStyle:LPAutoScrollViewStyleVertical];
    scrollView.layer.cornerRadius = 5;
    scrollView.layer.masksToBounds = YES;
    //代理和数据源
    scrollView.lp_scrollDataSource = self;
    scrollView.lp_scrollDelegate = self;
    
    //数据数组为1时是否关闭滚动
    scrollView.lp_stopForSingleDataSourceCount = YES;
    
    //滚动时长
    scrollView.lp_autoScrollInterval = 2;
    
    
    //注册内容view,自定义view请继承,LPContentView 纯代码和xib随意切换
    [scrollView lp_registerNib:[UINib nibWithNibName:NSStringFromClass([HKCycleContentView class]) bundle:nil]];
//    [scrollView lp_registerClass:[LPView class]];
    
    
    _scrollView = scrollView;
    [self addSubview:scrollView];
    
    scrollView.frame = CGRectMake(15, 5, self.frame.size.width-30, 55);
    
    //切记，数据源变化后记得调用 reload
    [self.scrollView lp_reloadData];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(15, 5, self.frame.size.width-30, 55);
}

#pragma mark - LPAutoScrollViewDatasource

- (NSUInteger)lp_numberOfNewsDataInScrollView:(LPAutoScrollView *)scrollView {
    return self.followVideoArray.count;
}

/**
 *
 *  @param contentView 更改为你自己创建的view类型，使用模型赋值，类似UITableView
 */
- (void)lp_scrollView:(LPAutoScrollView *)scrollView newsDataAtIndex:(NSUInteger)index forContentView:(LPContentView *)contentView {
    //contentView.title = self.titlesArray[index];
    
    HKCycleContentView * cell = (HKCycleContentView *)contentView;
    cell.followVideoModel = self.followVideoArray[index];
//    cell.lookBlock = ^{
//        HKFollowVideoModel * model = self.followVideoArray[index];
//        if (self.lookBlock) {
//            self.lookBlock(model);
//        }
//    };
}

#pragma mark LPAutoScrollViewDelegate

- (void)lp_scrollView:(LPAutoScrollView *)scrollView didTappedContentViewAtIndex:(NSUInteger)index {
    NSLog(@"%@", self.followVideoArray[index]);
    //HKTeacherCourseVC 跳转教师详情页
    HKFollowVideoModel * model = self.followVideoArray[index];
    if (self.lookBlock) {
        self.lookBlock(model);
    }
}

-(void)setFollowVideoArray:(NSMutableArray *)followVideoArray{
    _followVideoArray = followVideoArray;
    [self.scrollView lp_reloadData];
}

@end
