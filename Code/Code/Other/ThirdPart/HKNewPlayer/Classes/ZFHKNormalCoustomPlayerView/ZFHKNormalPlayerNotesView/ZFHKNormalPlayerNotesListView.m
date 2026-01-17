//
//  ZFHKNormalPlayerNotesListView.m
//  Code
//
//  Created by Ivan li on 2020/12/29.
//  Copyright © 2020 pg. All rights reserved.
//

#import "ZFHKNormalPlayerNotesListView.h"
#import "HKPlayViewNoteCell.h"
#import "HKNotesListModel.h"

@interface ZFHKNormalPlayerNotesListView ()<UITableViewDelegate,UITableViewDataSource,HKPlayViewNoteCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , assign) int page ;

@end

@implementation ZFHKNormalPlayerNotesListView

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(instancetype)init{
    if ([super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.5];
    [self addSubview:self.tableView];
    
    @weakify(self);
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        @strongify(self);
        [self loadNewListData];
    }];

    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        @strongify(self);
        [self loadListData];
    }];
}

- (UITableView*)tableView {
    if (!_tableView) {//138 * Ratio + KNavBarHeight64
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        //_tableView.y = 1; // 分割线
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.estimatedRowHeight = 150;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //任务项cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKPlayViewNoteCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKPlayViewNoteCell class])];
    }
    return _tableView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKPlayViewNoteCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKPlayViewNoteCell class])];
    cell.delegate = self;
    cell.noteModel = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WeakSelf
    cell.didOpenBlock = ^{
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HKNotesModel * noteModel = self.dataArray[indexPath.row];
    return noteModel.cellHeight;
}

-(void)setVideoDetailModel:(DetailModel *)videoDetailModel{
    _videoDetailModel = videoDetailModel;
    [self loadNewListData];
}

- (void)loadNewListData{
    self.page = 1;
    [self loadListData];
}

- (void)loadListData{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [dic setObject:self.videoDetailModel.video_id forKey:@"video_id"];
    @weakify(self);
    [HKHttpTool POST:@"/note/visitable-list-in-video" parameters:dic success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSArray * resultArray = [HKNotesModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            if (resultArray.count) {
                if (pageModel.current_page >= self.page) {
                    
                    for (HKNotesModel * model in resultArray) {
                        model.isPalyMenuNote = YES;
                        model.unfold = 0;
                    }
                    [self.dataArray addObjectsFromArray:resultArray];
                    if (pageModel.current_page >= pageModel.page_total) {
                        [self tableFooterEndRefreshing];
                    }else{
                        [self tableFooterStopRefreshing];
                    }
                    self.page ++ ;
                    [self.tableView.mj_header endRefreshing];
                }
                
            }else{
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }
        }else{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)tableFooterEndRefreshing {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.mj_footer.hidden = YES;
}

- (void)tableFooterStopRefreshing {
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}

#pragma mark ======= HKPlayViewNoteCellDelegate
-(void)notesListCellDidZanBtn:(HKNotesModel *)noteModel{
    [MobClick event: detailpage_note_select_like];
    [HKHttpTool POST:@"/note/switch-liked" parameters:@{@"note_id":noteModel.ID} success:^(id responseObject) {
        [HKProgressHUD hideHUD];
        if ([CommonFunction detalResponse:responseObject]) {
            //showTipDialog(@"作业已提交");
            //int likeCount = [noteModel.likes_count intValue];
            noteModel.liked = [NSNumber numberWithInt:1];
            //noteModel.likes_count = [NSString stringWithFormat:@"%d",likeCount+1];
            //showTipDialog(responseObject[@"msg"]);
        }else{
            int likeCount = [noteModel.likes_count intValue];
            noteModel.likes_count = [NSString stringWithFormat:@"%d",likeCount-1];
            noteModel.liked = [NSNumber numberWithInt:0];
            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)notesListCellDidTimeBtn:(HKNotesModel *)noteModel{
    [MobClick event: detailpage_note_select_time];
    if (self.didPlayTimeBtnBlock) {
        self.didPlayTimeBtnBlock([noteModel.seconds intValue]);
    }
};

@end
