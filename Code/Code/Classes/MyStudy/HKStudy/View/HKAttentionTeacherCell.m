//
//  HKAttentionTeacherCell.m
//  Code
//
//  Created by yxma on 2020/9/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKAttentionTeacherCell.h"
#import "HKAttentionTeacherElementCell.h"

@interface HKAttentionTeacherCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HKAttentionTeacherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, 90);
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKAttentionTeacherElementCell class]) bundle:nil] forCellWithReuseIdentifier:@"HKAttentionTeacherElementCell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_followTeacherArray.count == 10) {
        return 11;
    }
    return self.followTeacherArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HKAttentionTeacherElementCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKAttentionTeacherElementCell" forIndexPath:indexPath];
    if (indexPath.row <= 9) {
        cell.isShowMore =  NO;
        cell.teacherModel = self.followTeacherArray[indexPath.row];
    }else{
        cell.isShowMore = YES;
    }
    
    
    return cell;
}

-(void)setFollowTeacherArray:(NSMutableArray *)followTeacherArray{
    _followTeacherArray = followTeacherArray;
    
    [self.collectionView reloadData];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 9) {
        if (self.didCellBlock) {
            self.didCellBlock(nil,indexPath.row);
        }
    }else{
        HKFollowTeacherModel * model = self.followTeacherArray[indexPath.row];
        if (self.didCellBlock) {
            self.didCellBlock(model,indexPath.row);
        }
    }
}


@end
