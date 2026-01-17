//
//  ZFHKPlayerLandScapeSimilarVideoCollectionView.m
//  Code
//
//  Created by Ivan li on 2019/3/18.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "ZFHKPlayerLandScapeSimilarVideoCollectionView.h"



#pragma mark--HKPlayerCollectionViewCell

@interface ZFHKPlayerLandScapeSimilarCollectionViewCell()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *iconImageView;

@end


@implementation ZFHKPlayerLandScapeSimilarCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconImageView];
        [self singleGesture];
    }
    return self;
}


- (void)singleGesture {
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playerCollectionViewCell:)];
    [self  addGestureRecognizer:gest];
}


- (void)playerCollectionViewCell:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKPlayerLandScapeSimilarCollectionViewCell:)]) {
        [self.delegate zfHKPlayerLandScapeSimilarCollectionViewCell:self.model];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(1);
        make.size.mas_equalTo(CGSizeMake(330/2, 199/2));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.iconImageView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(PADDING_5);
        make.height.equalTo(@20);
    }];
}



- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        //_iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = PADDING_5;
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[COLOR_ffffff colorWithAlphaComponent:0.8]
                                     titleFont:@"14" titleAligment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}


- (void)setModel:(VideoModel *)model {
    _model = model;
    self.titleLabel.text = model.video_title;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
}

@end






@interface ZFHKPlayerLandScapeSimilarVideoCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZFHKPlayerLandScapeSimilarCollectionViewCellDelagate>

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation ZFHKPlayerLandScapeSimilarVideoCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.delegate = self;
        self.dataSource = self;
        //self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        //Cell
        [self registerClass:[ZFHKPlayerLandScapeSimilarCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZFHKPlayerLandScapeSimilarCollectionViewCell class])];
    }
    return self;
}


- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}


#pragma mark <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZFHKPlayerLandScapeSimilarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZFHKPlayerLandScapeSimilarCollectionViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


- (void)zfHKPlayerLandScapeSimilarCollectionViewCell:(VideoModel*)model {
    if (self.playerCollectionViewDelagate && [self.playerCollectionViewDelagate respondsToSelector:@selector(zfHKPlayerLandScapeSimilarVideoCollectionView:videoModel:)]) {
        [self.playerCollectionViewDelagate zfHKPlayerLandScapeSimilarVideoCollectionView:self videoModel:model];
    }
}


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    if ([self.playerCollectionViewDelagate respondsToSelector:@selector(hkplayerCollectionCellClick:sender:collectionView:)]) {
    //        VideoModel *model = self.dataArray[indexPath.row];
    //        [self.playerCollectionViewDelagate hkplayerCollectionCellClick:indexPath sender:model collectionView:collectionView];
    //    }
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //return UIEdgeInsetsMake(0, 50, 0, 0);
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}



@end










