//
//  HKImageTextVC.m
//  Code
//
//  Created by eon Z on 2022/4/24.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKImageTextVC.h"
#import "HKLiveCourseInfoDesCell.h"

@interface HKImageTextVC ()<UITableViewDelegate, UITableViewDataSource,TBSrollViewEmptyDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)CGFloat htmlHeight;
@property (nonatomic, strong)UILabel * txtLabel;
@property (nonatomic, strong)DetailModel *videlDetailModel;

@end

@implementation HKImageTextVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId  detailModel:(DetailModel*)model {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.videlDetailModel = model;
    }
    return self;
}

//-(UILabel *)txtLabel{
//    if (_txtLabel == nil) {
//        _txtLabel = [UILabel labelWithTitle:CGRectZero title:@"视频相关图文教程" titleColor:COLOR_27323F_EFEFF6 titleFont:@"15" titleAligment:NSTextAlignmentLeft];
//        _txtLabel.font = [UIFont boldSystemFontOfSize:15];
//    }
//    return _txtLabel;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    self.emptyText = @"该视频暂无图文教程";
//    self.txtLabel.height = 55;
//    self.tableView.tableHeaderView = self.txtLabel;
    [self.view addSubview:self.tableView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)setVideoInfoWithModel:(DetailModel*)videlDetailModel {
    _videlDetailModel = videlDetailModel;
    [self.tableView reloadData];
}


-(UITableView *)tableView{
    if (_tableView == nil) {
        if (IS_IPAD) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(iPadContentMargin, 0, iPadContentWidth, SCREEN_HEIGHT - SCREEN_HEIGHT * 0.5 -44)
                                                     style:UITableViewStyleGrouped];
            _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPadContentWidth, CGFLOAT_MIN)];
        }else{
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_WIDTH*9/16 -44)
                                                     style:UITableViewStyleGrouped];
            _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        }
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.delegate= self;
        _tableView.dataSource = self;
        _tableView.tb_EmptyDelegate = self;
//        _tableView.em
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveCourseInfoDesCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKLiveCourseInfoDesCell class])];
        
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    self.tableView.scrollEnabled = self.videlDetailModel.pictext_url.length ? YES : NO;

    return self.videlDetailModel.pictext_url.length ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videlDetailModel.pictext_url.length ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKLiveCourseInfoDesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKLiveCourseInfoDesCell class])];
    WeakSelf
    cell.themeLb.text = @"视频相关图文教程";
    cell.themeLb.font = [UIFont boldSystemFontOfSize:IS_IPAD ? 20:16];
    cell.htmlHeightBlock = ^(float height) {
        if (height > 0) {
            weakSelf.htmlHeight = height;
            [weakSelf.tableView reloadData];
        }
    };
    
    cell.loginBlock = ^(HomeAdvertModel * _Nonnull adsModel) {
        [HKH5PushToNative runtimePush:adsModel.className arr:adsModel.list currectVC:weakSelf];
    };
    cell.h5_url = self.videlDetailModel.pictext_url;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.htmlHeight ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - TBSrollViewEmptyDelegate

- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
    return [UIImage imageNamed:@"data_empty"];
}

- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
    return CGPointMake(0, 80);
}

//- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
//    return imageName(@"group_chat_data_empty");
//}


@end
