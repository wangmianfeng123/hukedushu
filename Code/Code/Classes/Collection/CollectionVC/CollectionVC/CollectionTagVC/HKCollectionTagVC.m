//
//  HKCollectionTagVC.m
//  Code
//
//  Created by Ivan li on 2017/12/19.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKCollectionTagVC.h"
#import "SeriesCourseTagCell.h"
#import "SeriseCourseModel.h"

@interface HKCollectionTagVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView  *collectionView;
@property(nonatomic,strong)NSMutableArray<SeriseTagModel*> *tagModelArr;


@end

@implementation HKCollectionTagVC

- (instancetype)initWithModelArray: (NSMutableArray<SeriseTagModel*>*)modelArr {
    
    if (self = [super init]) {
        self.tagModelArr = modelArr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createUI {
    self.title = @"筛选教程";
    [self createLeftBarButton];
    [self.view addSubview:self.collectionView];
    //[self refreshUI];
}


- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 1.5;
        layout.minimumInteritemSpacing = 1;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[SeriesCourseTagCell class] forCellWithReuseIdentifier:@"SeriesCourseTagCell"];
        //[_collectionView registerClass:[SeriesCourseTagHeadCell class] forCellWithReuseIdentifier:@"SeriesCourseTagHeadCell"];
        _collectionView.backgroundColor = COLOR_F6F6F6;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}



- (NSMutableArray<SeriseTagModel*>*)tagModelArr {
    if (!_tagModelArr) {
        _tagModelArr = [NSMutableArray array];
    }
    return  _tagModelArr;
}



#pragma mark - CollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return (_tagModelArr.count>0) ?1 :0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _tagModelArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake(SCREEN_WIDTH/2-1, 80);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SeriesCourseTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SeriesCourseTagCell class]) forIndexPath:indexPath];
    cell.model = _tagModelArr[[indexPath row]];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    if (_tagModelArr[row].isSelected  == YES) {
        
    }else{
        
        for (NSInteger j = 0; j < _tagModelArr.count; j++) {
            _tagModelArr[j].isSelected = NO;
        }
        _tagModelArr[row].isSelected = !_tagModelArr[row].isSelected;
        self.tagSelectBlock(indexPath, _tagModelArr[row]);
        [self.collectionView  reloadData];
    }
    [self backAction];
}



@end





