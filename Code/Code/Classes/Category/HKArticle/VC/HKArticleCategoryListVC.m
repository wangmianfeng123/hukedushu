//
//  HKArticleCategoryListVC.m
//  Code
//
//  Created by hanchuangkeji on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved. 
//

#import "HKArticleCategoryListVC.h"
#import "HKArticleCategoryListCell.h"

@interface HKArticleCategoryListVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *barTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *headerLB;

@end

@implementation HKArticleCategoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionViewCust];
    
    self.barTitleLB.textColor = COLOR_27323F_EFEFF6;
    self.headerLB.textColor = COLOR_27323F_EFEFF6;
}

- (void)setCollectionViewCust {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKArticleCategoryListCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKArticleCategoryListCell class])];
    [self.collectionView setContentInset:UIEdgeInsetsMake(28, 10, 0, 10)];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 22;
    layout.minimumInteritemSpacing = 19;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 19.0 * 3 - 2 * 10 - 0.1) / 4.0, IS_IPHONEMORE4_7INCH? 32 : 28);
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
}

// 退出VC
- (IBAction)closeBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKArticleCategoryListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKArticleCategoryListCell class]) forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消上次的选中
    for (HKArticleCategoryModel *model in self.dataSource) {
        if (model.isSelected){
            model.isSelected = NO;
        }
    }

    // 选中当前的
    HKArticleCategoryModel *model = self.dataSource[indexPath.row];
    model.isSelected = YES;


    // 回调block
    !self.didSelectHKArticleCategoryModelBlock? : self.didSelectHKArticleCategoryModelBlock(model, (int)(indexPath.row));
    
    // 退出
    [self closeBtnClick:nil];
}

@end
