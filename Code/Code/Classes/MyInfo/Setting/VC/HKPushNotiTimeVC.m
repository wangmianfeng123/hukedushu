//
//  HKPushNotiTimeVC.m
//  Code
//
//  Created by eon Z on 2022/2/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKPushNotiTimeVC.h"
#import "QFTimePickerView.h"
#import "HKPushTimeCell.h"
#import "UIView+HKLayer.h"
#import "HKPushNoticeModel.h"

@interface HKPushNotiTimeVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSString * hour;
@property(nonatomic, strong)NSString * min;
@property (nonatomic , assign ) int selectIndex;

@end

@implementation HKPushNotiTimeVC
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
        NSMutableArray * nameArray = [[NSMutableArray alloc]initWithObjects:@"每天",@"法定工作日（智能跳过节假日）",@"法定节假日（智能跳过工作日）",@"周一至周五",@"周六至周日", nil];
        for (int i = 0; i < nameArray.count; i++) {
            HKPushTimeModel * model = [HKPushTimeModel new];
            model.index = i;
            model.name = nameArray[i];
            if (i == [self.j_push_type intValue]) {
                model.selected = YES;
            }
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250) style:UITableViewStylePlain];
        _tableView.rowHeight = IS_IPAD ? 55 * iPadHRatio : 45 * Ratio;
        UIColor *color = COLOR_F6F6F6_3D4752;
        _tableView.backgroundColor = color;
        _tableView.bounces = NO;
//        [_tableView setSeparatorColor:color];
        _tableView.separatorStyle = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self,_tableView);
        // 注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKPushTimeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKPushTimeCell class])];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置提醒时间";
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_F6F6F6_3D4752;
    [self showChooseTimeView];
}

- (void)showChooseTimeView{
    WeakSelf
    QFTimePickerView *pickerView = [[QFTimePickerView alloc]initDatePackerWithStartHour:@"00" endHour:@"24" period:30 response:^(NSString *hour, NSString *min) {
        weakSelf.hour = hour;
        weakSelf.min = min;
        NSLog(@"%@:%@",hour,min);
    }];
    pickerView.backgroundColor = COLOR_FFFFFF_3D4752;
    [pickerView show];
//    NSString * hour = [DateChange getCurrentTime_Hour];
//    [pickerView hour:hour];
    [pickerView hour:[NSString stringWithFormat:@"%@",self.j_push_hour]];
    if ([self.j_push_hour_type intValue] == 2) {
        [pickerView min:@"30"];
    }else{
        [pickerView min:@"00"];
    }
//    UIViewController * vc =[self topViewController];
    [self.view addSubview:pickerView];
    pickerView.frame = CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, IS_IPAD ? 260 * iPadHRatio : 240 * Ratio);
    
    UILabel * repeatLabel = [UILabel labelWithTitle:CGRectMake(15, CGRectGetMaxY(pickerView.frame),100, IS_IPAD ? 60 * iPadHRatio : 40 * Ratio) title:@"重复" titleColor:COLOR_7B8196_A8ABBE titleFont:@"14" titleAligment:NSTextAlignmentLeft];
    [self.view addSubview:repeatLabel];
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(repeatLabel.frame), SCREEN_WIDTH, IS_IPAD ? 275 * iPadHRatio : 225 * Ratio);
    [self.view addSubview:self.tableView];

    
    UIButton * sureButton = [UIButton buttonWithTitle:@"保存并返回" titleColor:[UIColor whiteColor] titleFont:@"18" imageName:@""];
    sureButton.frame = CGRectMake(15, CGRectGetMaxY(self.tableView.frame) + 30, SCREEN_WIDTH - 30, 48);
    [sureButton addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF8A00"].CGColor,(id)[UIColor colorWithHexString:@"#FFB600"].CGColor]];
    [sureButton addCornerRadius:24];
    [sureButton addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
}

- (void)sureBtnClick{
    @weakify(self);
    NSString * hourType = @"";
    if ([self.min isEqualToString:@"30"]) {
        hourType = @"2";
    }else{
        hourType = @"1";
    }    
    NSDictionary *param = @{@"key":self.key, @"j_push_hour":self.hour, @"j_push_hour_type" : hourType, @"j_push_type": [NSString stringWithFormat:@"%d",self.selectIndex]};

    [HKHttpTool POST:@"/setting/switch-option-time" parameters:param success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            showTipDialog(responseObject[@"data"][@"business_message"]);
            if ([responseObject[@"data"][@"business_code"] intValue] == 200) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)setJ_push_hour:(NSNumber *)j_push_hour{
    _j_push_hour = j_push_hour;
    self.hour = [NSString stringWithFormat:@"%@",self.j_push_hour];
}

-(void)setJ_push_hour_type:(NSNumber *)j_push_hour_type{
    _j_push_hour_type = j_push_hour_type;
    self.min = [j_push_hour_type intValue] == 2 ? @"30":@"00";
}

-(void)setJ_push_type:(NSNumber *)j_push_type{
    _j_push_type = j_push_type;
    self.selectIndex = [j_push_type intValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    HKPushTimeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKPushTimeCell class])];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (HKPushTimeModel * model in self.dataArray) {
        if (model.index == indexPath.row) {
            model.selected = YES;
            self.selectIndex = model.index;
        }else{
            model.selected = NO;
        }
    }
    [self.tableView reloadData];
}

@end
