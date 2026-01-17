//
//  HKHomeNewAlbumCell.m
//  Code
//
//  Created by yxma on 2020/11/11.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKHomeNewAlbumCell.h"
#import "HKHomeAlbumSubCell.h"
#import "HKContainerModel.h"

@interface HKHomeNewAlbumCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic , strong)UICollectionView * collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end

@implementation HKHomeNewAlbumCell

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * layout= [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, IS_IPAD ? 180 : 139) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKHomeAlbumSubCell" bundle:nil] forCellWithReuseIdentifier:@"HKHomeAlbumSubCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator =  NO;
        _collectionView.showsHorizontalScrollIndicator =  NO;
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _collectionView.bounces = NO;
    }
    return _collectionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineLabel.backgroundColor = COLOR_F8F9FA_333D48;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    [self addSubview:self.collectionView];
}

-(void)setDataArray:(NSArray *)dataArray{
    _model = nil;
    _dataArray = dataArray;
    if (_dataArray) {
        [self.collectionView reloadData];
        self.titleLabel.text = @"精选专辑";
        [_moreBtn setTitle:@"更多专辑" forState:UIControlStateNormal];
    }
    
}

-(void)setModel:(HKAlbumModel *)model{
    _dataArray = nil;
    _model = model;
    if (_model) {
        [self.collectionView reloadData];
        self.titleLabel.text = model.name;
        [_moreBtn setTitle:[NSString stringWithFormat:@"共%@节课",model.video_num] forState:UIControlStateNormal];

    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArray.count) {
        if (self.dataArray.count >= 10) {
            return 11;
        }
        return self.dataArray.count;
    }else if (self.model) {
        if (self.model.video.count >= 10) {
            return 11;
        }
        return self.model.video.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    HKHomeAlbumSubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKHomeAlbumSubCell" forIndexPath:indexPath];
    if (indexPath.row >= 10){
        cell.moreLabel.hidden = NO;
        cell.titleLabel.hidden = YES;
        cell.imgV.hidden = YES;
    }else{
        cell.moreLabel.hidden = YES;
        cell.titleLabel.hidden = NO;
        cell.imgV.hidden = NO;
        if (self.model) {
            if (indexPath.row < self.model.video.count) {
                cell.videoModel = self.model.video[indexPath.row];
            }
        }else if (self.dataArray.count){
            if (indexPath.row < self.dataArray.count) {
                cell.albumModel = self.dataArray[indexPath.row];
            }
        }else{
            cell.videoModel = nil;
            cell.albumModel = nil;
        }
    }
     
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= 10) {
        if (self.model) {//推荐的专辑
            !self.moreClickBlock ? : self.moreClickBlock(NO);
        }else if (self.dataArray.count){//全部专辑
            !self.moreClickBlock ? : self.moreClickBlock(YES);
        }
    }else{
        if (self.model) {//推荐的专辑
            !self.cellClickBlock ? : self.cellClickBlock(self.model.video[indexPath.row]);
        }else if (self.dataArray.count){//全部专辑
            !self.cellClickBlock ? : self.cellClickBlock(self.dataArray[indexPath.row]);
        }        
    }    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 16, 0, 16);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    return IS_IPAD ? CGSizeMake(220, 180) : CGSizeMake(140, 140);
}

- (IBAction)moreBtnClick {
    if (self.model) {
        !self.moreClickBlock ? : self.moreClickBlock(NO);
    }else if (self.dataArray.count){
        !self.moreClickBlock ? : self.moreClickBlock(YES);
    }
}
@end
