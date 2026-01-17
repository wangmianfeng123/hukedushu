//
//  HKChoiceNoteListVC.m
//  Code
//
//  Created by Ivan li on 2021/3/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKChoiceNoteListVC.h"
//#import "XRCollectionViewCell.h"
#import "XRWaterfallLayout.h"
#import "XRImage.h"
#import "HKChooseNoteCell.h"
#import "HKRecommendTxtModel.h"
#import "VideoPlayVC.h"
#import "VideoServiceMediator.h"

@interface HKChoiceNoteListVC ()<UICollectionViewDataSource, XRWaterfallLayoutDelegate,UICollectionViewDelegate,HKChooseNoteCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) NSMutableArray<XRImage *> *images;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , assign) int page ;
@end

@implementation HKChoiceNoteListVC

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//- (NSMutableArray *)images {
//    //从plist文件中取出字典数组，并封装成对象模型，存入模型数组中
//    if (!_images) {
//        _images = [NSMutableArray array];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil];
//        NSArray *imageDics = [NSArray arrayWithContentsOfFile:path];
//        for (NSDictionary *imageDic in imageDics) {
//            XRImage *image = [XRImage imageWithImageDic:imageDic];
//            [_images addObject:image];
//        }
//    }
//    return _images;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安利墙";
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    self.page = 1;
    //创建瀑布流布局
    XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
        
    //或者一次性设置
    [waterfall setColumnSpacing:0 rowSpacing:0 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    //设置代理，实现代理方法
    waterfall.delegate = self;
    
    //创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, SCREEN_HEIGHT - KNavBarHeight64) collectionViewLayout:waterfall];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HKChooseNoteCell" bundle:nil] forCellWithReuseIdentifier:@"HKChooseNoteCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = COLOR_FFFFFF_333D48;
    [self loadNewData];
    
    @weakify(self);
    [HKRefreshTools headerRefreshWithTableView:self.collectionView completion:^{
        @strongify(self);
        [self loadNewData];
    }];
    [HKRefreshTools footerAutoRefreshWithTableView:self.collectionView completion:^{
        @strongify(self);
        [self loadListData];
    }];
    // 成功登录
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, userloginSuccess);
}

- (void)userloginSuccess{
    [self loadNewData];
}

//- (void)click {
//    [self.images removeAllObjects];
//    [self.collectionView reloadData];
//}

- (void)loadNewData{
    self.page = 1;
    [self loadListData];
}


- (void)loadListData{
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paramDic setObject:[NSNumber numberWithInt:20] forKey:@"page_size"];
    @weakify(self);
    [HKHttpTool POST:@"/recommend-comments/list" parameters:paramDic success:^(id responseObject) {
        @strongify(self);
        [self.collectionView.mj_header endRefreshing];
        if (HKReponseOK) {
            NSMutableArray * arr = [HKRecommendTxtModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (arr.count) {
                if (self.page == 1) {
                    [self.dataArray removeAllObjects];
                    [self.dataArray addObjectsFromArray:arr];
                }else{
                    [self.dataArray addObjectsFromArray:arr];
                }
                if (arr.count == 20) {
                    [self.collectionView.mj_footer endRefreshing];
                    self.page ++;
                }else{
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.collectionView.mj_footer endRefreshing];
            }
            [self.collectionView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    //XRImage *image = self.images[indexPath.item];
    //return image.imageH / image.imageW * itemWidth;
    HKRecommendTxtModel * model = self.dataArray[indexPath.row];
    return model.cellHeight;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.images.count;
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKChooseNoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKChooseNoteCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    HKRecommendTxtModel * model = self.dataArray[indexPath.row];
    if (model.video_id.length) {
        [MobClick event:shouye_recommend_more_content];
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                    videoName:model.title
                                             placeholderImage:nil
                                                   lookStatus:LookStatusInternetVideo videoId:model.video_id model:nil];
        [self pushToOtherController:VC];
    }
}

- (void)chooseNoteCellDidZanClick:(HKRecommendTxtModel *)model{
    if (isLogin()) {
        if (model.is_thumb) return;
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:model.relation_id forKey:@"id"];
        [dic setObject:model.type forKey:@"connectType"];
        
        [HKHttpTool POST:@"/switch/likes" parameters:dic success:^(id responseObject) {
            if ([CommonFunction detalResponse:responseObject]) {
                model.is_thumb = YES;
                model.thumbs = model.thumbs + 1;
                [self.collectionView reloadData];
            }
        } failure:^(NSError *error) {
                
        }];
    }else{
        [self setLoginVC];
    }
}


@end
