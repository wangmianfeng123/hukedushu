//
//  HKContainerView.m
//  Code
//
//  Created by Ivan li on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKContainerView.h"
#import "HKContainerListCell.h"
#import "HKBulidContainerVC.h"
#import "HKContainerModel.h"
#import "DetailModel.h"


static CGFloat animationTime = 0.25; //动画时间

@interface HKContainerView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;
@property(nonatomic,strong)UIView    *maskView;
@property(nonatomic,assign)CGFloat bgViewHeith;
@property(nonatomic,assign)NSInteger totalPage;
@property(nonatomic,assign)NSInteger page;
@end

@implementation HKContainerView


- (void)dealloc {
    
}

- (instancetype)init{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}


- (void)setUI {
    self.page = 1;
    self.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
    self.frame = [self frontWindow].bounds;
    [[self frontWindow] addSubview:self];
    [self addSubview:self.maskView];
    
    [self.maskView addSubview:self.tableView];
    [self showPickView];
    [self refreshUI];
    [self getAlbumByPage:[NSString stringWithFormat:@"%lu",self.page]];
    [MyNotification addObserver:self
                       selector:@selector(editContainerTitleNotification:)
                           name:HKEditContainerTitleNotification
                         object:nil];
}


- (void)setDetailModel:(DetailModel *)detailModel {
    _detailModel = detailModel;
}


- (UIView*)maskView {
    
    if (!_maskView) {
        _bgViewHeith = 84*4+PADDING_25;
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, SCREEN_WIDTH, _bgViewHeith)];
        _maskView.backgroundColor = COLOR_F6F6F6;
    }
    return _maskView;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self hidePickView];
}


//显示
- (void)showPickView{
    [UIView animateWithDuration:animationTime animations:^{
        self.maskView.frame = CGRectMake(0, self.height - _bgViewHeith , SCREEN_WIDTH, _bgViewHeith);
    } completion:^(BOOL finished) {
        
    }];
}

//隐藏
- (void)hidePickView{
    
    [UIView animateWithDuration:animationTime animations:^{
        self.maskView.frame = CGRectMake(0, self.height, SCREEN_WIDTH, _bgViewHeith);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - FrontWindow
- (UIWindow *)frontWindow {
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return nil;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
//        for (int i =0; i<3; i++) {
//
//            HKContainerModel *model = [HKContainerModel new];
//            model.title = [NSString stringWithFormat:@"专辑%d",i];
//            [_dataArray addObject:model];
//        }
    }
    return _dataArray;
}



- (UIView*)setTableHeaderView {
    
    UILabel *label = [UILabel labelWithTitle:CGRectZero title:@"收藏到" titleColor:COLOR_333333
                                   titleFont:(IS_IPHONE6PLUS ? @"13" :@"11") titleAligment:NSTextAlignmentLeft];
    
    __block UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, PADDING_25)];
    [bgView addSubview:label];
    bgView.backgroundColor = COLOR_F6F6F6;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(13);
        make.centerY.equalTo(bgView.mas_centerY);
    }];
    return bgView;
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bgViewHeith) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 168/2;
        _tableView.backgroundColor = COLOR_F6F6F6;
    }
    return _tableView;
}


#pragma mark - Table view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HKContainerListHead"];
        if (!header) {
            header = (UITableViewHeaderFooterView*)[self setTableHeaderView];
        }
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0)? PADDING_25 :0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count>0 ? _dataArray.count+1 :1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKContainerListCell *cell = [HKContainerListCell initCellWithTableView:tableView];
    if(indexPath.section == self.dataArray.count){
        HKAlbumModel *model = [HKAlbumModel new];
        model.name = @"新建专辑";
        cell.model = model;
    }else{
        cell.model = self.dataArray[indexPath.section];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
    [self hidePickView];
    if(indexPath.section == self.dataArray.count){
        //新建专辑
        HKAlbumModel *model = [HKAlbumModel new];
        self.selectContainerBlock(model);
    }else{
        //搜藏到现有专辑
        //self.selectContainerBlock(self.dataArray[indexPath.section]);
        HKAlbumModel *model = self.dataArray[indexPath.section];
        [self collectVideoWithAlbumId:model.album_id videoId:self.detailModel.video_id];
    }
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



- (void)editContainerTitleNotification:(NSNotification*)noti {
    
    NSDictionary *dict = noti.userInfo;
    __block HKAlbumModel *model = [dict objectForKey:@"model"];
    [self.dataArray insertObject:model atIndex:0];
    [self.tableView reloadData];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    __block NSInteger count = self.dataArray.count;
    if (count>0) {
        _bgViewHeith = (count+1)*84 +PADDING_25;
        _maskView.frame = CGRectMake(0, self.height - _bgViewHeith , SCREEN_WIDTH, _bgViewHeith);
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _bgViewHeith);
    }
}


#pragma mark - 刷新
- (void)refreshUI {
    WeakSelf;
//    MJRefreshStateHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
//        NSString  *pageNum = [NSString stringWithFormat:@"%lu",weakSelf.page];
//        [weakSelf getAlbumByPage:pageNum];
//    }];
//    header.automaticallyChangeAlpha = YES;
//    _tableView.mj_header = header;
//    header.lastUpdatedTimeLabel.hidden = YES;// 隐藏时间
//    header.stateLabel.hidden = NO;
//    _tableView.mj_header.lastUpdatedTimeKey.accessibilityElementsHidden = YES;
    
    [HKRefreshTools footerAutoRefreshWithTableView:_tableView completion:^{
        NSString  *pageNum = [NSString stringWithFormat:@"%lu",weakSelf.page];
        [weakSelf getAlbumByPage:pageNum];
    }];
}


- (void)tableHeaderEndRefreshing {
    [_tableView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [_tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [_tableView.mj_footer endRefreshing];
}



#pragma mark - 收藏视频到指定专辑
- (void)collectVideoWithAlbumId:(NSString*)albumId  videoId:(NSString*)videoId{
    WeakSelf;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:videoId,@"video_id",albumId,@"album_id",nil];
    [HKHttpTool POST:ALBUM_COLLECT_VIDEO parameters:parameters success:^(id responseObject) {
        showTipDialog([responseObject objectForKey:@"msg"]);
        
    } failure:^(NSError *error) {
        
    }];
}




#pragma mark - 获取用户创建专辑
- (void)getAlbumByPage:(NSString*)page {
    WeakSelf;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page",@"1",@"type",nil];//type //1-我的专辑 2-收藏专辑
    [HKHttpTool POST:ALBUM_MY_ALBUM parameters:parameters success:^(id responseObject) {
        
        [weakSelf tableHeaderEndRefreshing];
        HKContainerModel *model =[HKContainerModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
        
        weakSelf.totalPage = [[responseObject objectForKey:@"total_page"] intValue];
        if ([page isEqualToString:@"1"]) {
            weakSelf.dataArray = model.album_list;
        }else{
            [weakSelf.dataArray addObjectsFromArray:model.album_list];
        }
        if (weakSelf.page == weakSelf.totalPage) {
            [weakSelf tableFooterEndRefreshing];
        }else{
            [weakSelf tableFooterEndRefreshing];
            weakSelf.page++;
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf tableFooterEndRefreshing];
        [weakSelf tableHeaderEndRefreshing];
    }];
}




@end








