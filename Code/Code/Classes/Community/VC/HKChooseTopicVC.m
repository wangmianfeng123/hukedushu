//
//  HKChooseTopicVC.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKChooseTopicVC.h"
#import "HKSectionHeaderView.h"
#import "HKChooseTopicCell.h"
#import "HKHotTopicModel.h"
#import "HKMonmentTypeModel.h"

@interface HKChooseTopicVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , assign) int page ;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic , strong) HKMonmentTagModel * qnaModel;
@end

@implementation HKChooseTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择话题";
    [self createLeftBarButton];

    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    [self.view addSubview:self.tableView];
    [self loadData];
    
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)loadData{
    [HKHttpTool POST:@"/community/subject-list" parameters:nil success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            self.qnaModel = [HKMonmentTagModel mj_objectWithKeyValues:responseObject[@"data"][@"qna"]];
            self.qnaModel.isquestion = YES;
            self.dataArray = [HKHotTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"subjects"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (UITableView*)tableView {
    if (!_tableView) {//138 * Ratio + KNavBarHeight64
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = YES;
        _tableView.tb_EmptyDelegate = self;
        
        //任务项cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSectionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([HKSectionHeaderView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKChooseTopicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKChooseTopicCell class])];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        HKHotTopicModel * topicModel = self.dataArray[section-1];
        return topicModel.list.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 65;
    }else{
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        HKChooseTopicCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKChooseTopicCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.qnaModel;
        //cell.descLabel.hidden = NO;
        cell.desTopMargin.constant = 3;
        return cell;
    }else{
        HKChooseTopicCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKChooseTopicCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HKHotTopicModel * topicModel = self.dataArray[indexPath.section-1];
        cell.model = topicModel.list[indexPath.row];
        cell.descLabel.text = @"";
        cell.desTopMargin.constant = 0;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HKSectionHeaderView * secV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([HKSectionHeaderView class])];
    secV.backgroundColor = COLOR_FFFFFF_3D4752;
    if (section == 0) {
        secV.titleLabel.text = @"置顶";
        secV.imgV.image = [UIImage imageNamed:@"ic_top_select_2_31"];
        secV.titleLeftMargin.constant = 5.0;
    }else{
        HKHotTopicModel * topicModel = self.dataArray[section-1];
        secV.titleLabel.text = topicModel.name;
        if (section == 1) {
            secV.imgV.image = [UIImage imageNamed:@"ic_hot_select_2_31"];
            secV.titleLeftMargin.constant = 5.0;
        }else{
            secV.imgV.image = [UIImage new];
            secV.titleLeftMargin.constant = 0.0;
        }
    }
    return secV;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    bgView.backgroundColor = COLOR_F8F9FA_333D48;
    return bgView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
    if (indexPath.section == 0 ) {
        self.topicModelBlock(self.qnaModel);
    }else{
        HKHotTopicModel * topicModel = self.dataArray[indexPath.section-1];
        HKMonmentTagModel * model = topicModel.list[indexPath.row];
        self.topicModelBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count + 1;
    //return self.dataArray.count ? 1 : 0;
}
@end
