//
//  HKHomeVipVideoCell.m
//  Code
//
//  Created by ivan on 2020/6/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKHomeVipVideoCell.h"



@interface HKHomeVipVideoCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic)UICollectionView *collectionView;

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation HKHomeVipVideoCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}


- (void)setVideoArr:(NSMutableArray<VideoModel *> *)videoArr {
    _videoArr = videoArr;
    // 刷新CollectionView
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([self.collectionView cellForItemAtIndexPath:indexPath2]) {
        [self.collectionView scrollToItemAtIndexPath:indexPath2 atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self.collectionView reloadData];
}




- (UICollectionView*)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = IS_IPAD ? CGSizeMake(220, 190) : CGSizeMake(145, 160);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HKHomeVipVideoChildCell class] forCellWithReuseIdentifier:NSStringFromClass([HKHomeVipVideoChildCell class])];
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _collectionView;
}



#pragma mark <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.videoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKHomeVipVideoChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHomeVipVideoChildCell class]) forIndexPath:indexPath];
    cell.model = self.videoArr[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    !self.videoSelectedBlock? : self.videoSelectedBlock(indexPath, self.videoArr[indexPath.row]);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 0);
}
@end






@interface HKHomeVipVideoChildCell()

@property (strong, nonatomic)  UIImageView *imageView;

@property (strong, nonatomic)  UILabel *titleLB;

@end



@implementation HKHomeVipVideoChildCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLB];
        [self makeConstraints];

    }
    return self;
}


- (void)makeConstraints {
        
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView);
        make.size.mas_equalTo(IS_IPAD ? CGSizeMake(210, 127) : CGSizeMake(135, 82));
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(8);
        make.left.right.equalTo(self.imageView);
        make.bottom.lessThanOrEqualTo(self.contentView);
    }];
}



- (UIImageView*)imageView {
    if(!_imageView){
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 5;
    }
    return _imageView;
}


- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_0A1A39 titleFont:@"14" titleAligment:0];
        _titleLB.numberOfLines = 2;
        _titleLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_0A1A39 dark:COLOR_EFEFF6];
    }
    return _titleLB;
}


- (void)setModel:(VideoModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.cover_image_url]) placeholderImage:imageName(HK_Placeholder)];
    self.titleLB.text = model.title;
}


@end
