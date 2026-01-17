//
//  HKPlayerCollectionView.m
//  Code
//
//  Created by Ivan li on 2018/4/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPlayerCollectionView.h"




#pragma mark--HKPlayerCollectionViewCell

@interface HKPlayerCollectionViewCell()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *iconImageView;

@end


@implementation HKPlayerCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconImageView];
    }
    return self;
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
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[COLOR_ffffff colorWithAlphaComponent:0.8]
                                     titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _titleLabel.userInteractionEnabled = YES;
    }
    return _titleLabel;
}


- (void)setModel:(VideoModel *)model {
    _model = model;
    self.titleLabel.text = model.video_title;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
}

@end




@interface HKPlayerCollHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *categoryLabel;

@end

@implementation HKPlayerCollHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.categoryLabel];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}



- (UILabel*)categoryLabel {
    if (!_categoryLabel) {
        _categoryLabel = [UILabel labelWithTitle:CGRectZero title:@"相似推荐" titleColor:COLOR_ffffff titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _categoryLabel;
}


@end









@interface HKPlayerCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation HKPlayerCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        //Cell
        [self registerClass:[HKPlayerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HKPlayerCollectionViewCell class])];
//        //head
//        [self registerClass:[HKPlayerCollHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKPlayerCollHeaderView"];
    }
    return self;
}




- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

//- (NSMutableArray*)dataArray {
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}



#pragma mark <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKPlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKPlayerCollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.playerCollectionViewDelagate respondsToSelector:@selector(hkplayerCollectionCellClick:sender:collectionView:)]) {
        VideoModel *model = self.dataArray[indexPath.row];
        [self.playerCollectionViewDelagate hkplayerCollectionCellClick:indexPath sender:model collectionView:collectionView];
        //[self removeFromSuperview];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {   
    return UIEdgeInsetsMake(0, 50, 0, 0);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    if (0 == section) {
//        return CGSizeMake(220, 72/2);
//    }
    return CGSizeZero;
}



@end










