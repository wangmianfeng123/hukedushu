//
//  HKTaskDetailVC.m
//  Code
//
//  Created by Ivan li on 2018/7/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskDetailVC.h"
#import "HKTaskModel.h"
#import "HKUserInfoVC.h"
#import "HKTaskDetailHeadCell.h"
#import "HKTaskTeacCommentCell.h"
#import "HKTaskDetailCommentCell.h"
#import "HKTaskDetailUserCommentCell.h"
#import "HKTaskDetailUserCommentFootView.h"
#import "HKInputView.h"
#import "HKTaskTextView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface HKTaskDetailVC ()<UITableViewDelegate,UITableViewDataSource,HKTaskDetailHeadCellDelegate,HKTaskTeacCommentCellDelegate,HKInputViewDelagete,HKTaskTextViewDelegate>

@property(nonatomic,strong)UITableView    *tableView;

@property(nonatomic,strong)HKTaskDetailModel *detailM;

@property(nonatomic,strong)HKTaskTextView *taskTextView;

@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度



@end


@implementation HKTaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}


- (void)createUI {
    [self createLeftBarButton];
    [self createShareButtonItem];
    
    self.title = @"";
    self.view.backgroundColor = COLOR_F8F9FA;
    [self.view addSubview:self.tableView];
    [self getTaskData];
    [self.view addSubview:self.taskTextView];
    [self.taskTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    self.taskTextView.title = @"回复";
}


- (void)shareBtnItemAction {
    
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        [_tableView registerClass:[HKTaskDetailHeadCell class] forCellReuseIdentifier:@"HKTaskDetailHeadCell"];
        
        [_tableView registerClass:[HKTaskDetailUserCommentFootView class] forHeaderFooterViewReuseIdentifier:@"HKTaskDetailUserCommentFootView"];
        
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        //_tableView.sectionHeaderHeight = 0.005;
        //_tableView.sectionFooterHeight = 0.005;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //ios 11
        HKAdjustsScrollViewInsetNever(self, _tableView)
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
    }
    return _tableView;
}


#pragma mark - Getters
- (NSMutableDictionary *)heightAtIndexPath
{
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger count = self.detailM.comment_list.count;
    return  count ? 2 + count: 0;
    //return (count ?0 :count + 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = 1;
            break;
        default:
            count += self.detailM.comment_list[section -2].reply_list.count + 1;
            break;
    }
    return count;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return 150;
    
//    if (0 == indexPath.row) {
//        return 500;
//    }else{
//        return 30;
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat height = 0;
    switch (section) {
        case 0: case 1:
            height = 0.005;
            break;
        default:
            height = 40;
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.005;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section >1) {
        HKTaskDetailUserCommentFootView *footerView = (HKTaskDetailUserCommentFootView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HKTaskDetailUserCommentFootView"];
        //footerView.delegate = self;
        footerView.section = section;
        footerView.model = self.detailM.comment_list[section - 2];
        return footerView;
    }
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
            HKTaskDetailHeadCell *cell = [HKTaskDetailHeadCell initCellWithTableView:tableView];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = self.detailM;
            return cell;
    }else if (1 == indexPath.section) {
        HKTaskTeacCommentCell *cell = [HKTaskTeacCommentCell initCellWithTableView:tableView];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = self.detailM;
        return cell;
    }else {
        if (0 == indexPath.row) {
            HKTaskDetailCommentCell *cell = [HKTaskDetailCommentCell initCellWithTableView:tableView model:self.detailM.comment_list[indexPath.section - 2]];
            //cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = self.detailM.comment_list[indexPath.section - 2];
            return cell;
        }else{
            HKTaskDetailUserCommentCell *cell = [HKTaskDetailUserCommentCell initCellWithTableView:tableView row:indexPath.row-1];
            cell.commentM = self.detailM.comment_list[indexPath.section - 2].reply_list[indexPath.row -1];
            return cell;
        }
    }
}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSNumber *height = @(cell.frame.size.height);
//    [self.heightAtIndexPath setObject:height forKey:indexPath];
//}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark HKTaskListCell delegate

- (void)userInfoClick:(HKTaskModel*)model indexPath:(NSIndexPath *)indexPath {
    if (isLogin()) {
        HKUserInfoVC *vc = [HKUserInfoVC new]; vc.userId = model.uid;
        [self pushToOtherController:vc];
    }else{
        [self setLoginVC];
    }
}

- (void)didClickPraiseBtnInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (isLogin()) {
        
    }else{
        [self setLoginVC];
    }
}


- (void)reloadTaskDetailHeadCell:(HKTaskDetailModel *)model indexPath:(NSIndexPath *)indexPath {
    self.detailM = model;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)reloadTaskTeacCommentCell:(HKTaskDetailModel*)model indexPath:(NSIndexPath *)indexPath {
    self.detailM = model;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


- (HKTaskDetailModel*)detailM {
    if (!_detailM) {
        _detailM = [HKTaskDetailModel new];
    }
    return _detailM;
}


- (void)getTaskData {
    
    NSDictionary *dict = @{@"task_id":self.model.task_id};
    [HKHttpTool POST:TASK_DETAIl parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            HKTaskDetailModel *detailM = [HKTaskDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.detailM = detailM;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}





- (HKTaskTextView*)taskTextView {
    if (!_taskTextView) {
        _taskTextView = [[HKTaskTextView alloc]init];
        _taskTextView.delegate = self;
    }
    return _taskTextView;
}


- (void)didClick:(id)sender {
    
    [self showInputViewWithStyle:InputViewStyleDefault];
}


- (void)showInputViewWithStyle:(InputViewStyle)style {
    
    [HKInputView showWithStyle:style configurationBlock:^(HKInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        
        /** 代理 */
        inputView.delegate = self;
        
        /** 占位符文字 */
        inputView.placeholder = @"请输入评论文字...";
        /** 设置最大输入字数 */
        inputView.maxCount = 100000;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        
    } sendBlock:^BOOL(NSString *text) {
        if(text.length){
            NSLog(@"输入的信息为:%@",text);
            return YES;//收起键盘
        }else{
            NSLog(@"显示提示框-请输入要评论的的内容");
            return NO;//不收键盘
        }
    }];
    
}

#pragma mark - XHInputViewDelagete
/** XHInputView 将要显示 */
-(void)HKInputViewWillShow:(HKInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要显示时将其关闭 */
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    
}

/** XHInputView 将要影藏 */
-(void)HKInputViewWillHide:(HKInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要影藏时将其打开 */
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
}

@end

