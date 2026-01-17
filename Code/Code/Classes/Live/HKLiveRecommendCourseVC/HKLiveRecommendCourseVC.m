//
//  HKLiveRecommendCourseVC.m
//  Code
//
//  Created by ivan on 2020/8/26.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKLiveRecommendCourseVC.h"
#import "HKLiveRecommendCourseCell.h"
#import "HKLiveRecommendCourseModel.h"
#import "HKLiveCourseVC.h"

@interface HKLiveRecommendCourseVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,assign)NSInteger page;

@end



@implementation HKLiveRecommendCourseVC



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UICollectionView*)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, 295);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = COLOR_FFFFFF_333D48;

        HKAdjustsScrollViewInsetNever(self, _collectionView);
        [_collectionView registerClass:[HKLiveRecommendCourseCell class] forCellWithReuseIdentifier:NSStringFromClass([HKLiveRecommendCourseCell class])];
    }
    return _collectionView;
}
 


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKLiveRecommendCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKLiveRecommendCourseCell class]) forIndexPath:indexPath];
    cell.model = self.courseModel;
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *courseId = [NSString stringWithFormat:@"%ld",(long)self.courseModel.next_small_catalog_id];
    if (!isEmpty(courseId)) {
        HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
        VC.course_id = courseId;
        [self pushToOtherController:VC];
    }
}


@end

