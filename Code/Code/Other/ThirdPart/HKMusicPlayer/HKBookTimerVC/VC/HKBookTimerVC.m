//
//  HKBookTimerVC.m
//  Code
//
//  Created by Ivan li on 2019/7/17.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookTimerVC.h"
#import "HKBookTimerCell.h"
  
#import "HKBookModel.h"
#import "HKEnumerate.h"
#import "GKPlayer.h"



@interface HKBookTimerVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray <HKBookModel*>*dataSource;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UIView *bgView;

@property (nonatomic, assign)NSInteger currentSelectTimeIndex;




@end

@implementation HKBookTimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)createUI {
    
    self.zf_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self setupHeaderView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [self.bgView addGestureRecognizer:tapGesture];
    
    [self.tableView reloadData];
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}


- (void)setBgViewBackGroundColor {
    _bgView.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.4];
    _tableView.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.y = SCREEN_HEIGHT/2;
    } completion:^(BOOL finished) {
    }];
}


- (void)tapGestureClick {
    [self closeBtnClick];
}



- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2) style:UITableViewStyleGrouped];
        [_tableView registerClass:[HKBookTimerCell class] forCellReuseIdentifier:NSStringFromClass([HKBookTimerCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.rowHeight = 60;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [UIView new];
        
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}




- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.height = 50;
    self.tableView.tableHeaderView = headerView;
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightSemibold);
    titleLabel.textColor = COLOR_27323F_EFEFF6;
    titleLabel.text = @"定时关闭";
    [titleLabel sizeToFit];
    titleLabel.x = 15;
    titleLabel.centerY = headerView.height * 0.5;
    [headerView addSubview:titleLabel];
    
    // 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:imageName(@"ic_pulldown_v2_14") forState:UIControlStateNormal];
    [closeBtn setImage:imageName(@"ic_pulldown_v2_14") forState:UIControlStateSelected];
    closeBtn.width = 35;
    closeBtn.height = headerView.height;
    closeBtn.x = self.view.width - closeBtn.width;
    closeBtn.centerY = headerView.height * 0.5;
    [headerView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setHKEnlargeEdge:20];
    
    // 分割线
    UIView *separator = [[UIView alloc] init];
    separator.frame = CGRectMake(0, headerView.height - 1, self.view.width, 1);
    separator.backgroundColor = COLOR_F8F9FA_333D48;
    [headerView addSubview:separator];
}



- (void)closeBtnClick {
    self.bgView.backgroundColor = [UIColor clearColor];
    [self dismissViewControllerAnimated:YES completion:^{ }];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKBookModel *model = self.dataSource[indexPath.row];
    if (model.timerType == [GKPlayer sharedInstance].timerType) {
        model.is_selected = YES;
    }
    HKBookTimerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKBookTimerCell class]) forIndexPath:indexPath];
    cell.bookModel = model;
    return cell;
}

#pragma mark <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.dataSource enumerateObjectsUsingBlock:^(HKBookModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.is_selected = (idx == indexPath.row)? YES :NO;
    }];
    [tableView reloadData];
    
    if (self.bookTimerVCCellClick) {
        NSInteger second = 0;
        HKBookModel *model = self.dataSource[indexPath.row];
        [GKPlayer sharedInstance].timerType = model.timerType;
        
        switch (model.timerType) {
            case HKBookTimerType_none:
                second = 0;
                break;
                
            case HKBookTimerType_10MIN:
                second = 600;
                break;
                
            case HKBookTimerType_15MIN:
                second = 900;
                break;
                
            case HKBookTimerType_20MIN:
                second = 1200;
                break;
                
            case HKBookTimerType_30MIN:
                second = 1800;
                break;
                
            case HKBookTimerType_45MIN:
                second = 2700;
                break;
                
            case HKBookTimerType_60MIN:
                second = 3600;
                break;
                
            default:
                break;
        }
        if (self.bookTimerVCCellClick) {
            self.bookTimerVCCellClick(model.timerType, second, indexPath.row);
        }
    }
    [self closeBtnClick];
}



- (NSMutableArray<HKBookModel*>*)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        for (int i = 0; i< 7; i++) {
            HKBookModel *model = [HKBookModel new];
            switch (i) {
                case 0:
                    model.title = @"不开启";
                    model.is_selected = NO;
                    model.timerType = HKBookTimerType_none;
                    break;
                case 1:
                    model.title = @"10分钟"; 
                    model.is_selected = NO;
                    model.timerType = HKBookTimerType_10MIN;
                    break;
                case 2:
                    model.title = @"15分钟";
                    model.is_selected = NO;
                    model.timerType = HKBookTimerType_15MIN;
                    break;
                    
                case 3:
                    model.title = @"20分钟";
                    model.is_selected = NO;
                    model.timerType = HKBookTimerType_20MIN;
                    break;
                case 4:
                    model.title = @"30分钟";
                    model.is_selected = NO;
                    model.timerType = HKBookTimerType_30MIN;
                    break;
                case 5:
                    model.title = @"45分钟";
                    model.is_selected = NO;
                    model.timerType = HKBookTimerType_45MIN;
                    break;
                case 6:
                    model.title = @"60分钟";
                    model.is_selected = NO;
                    model.timerType = HKBookTimerType_60MIN;
                    break;
            }
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}




@end

