//
//  HKSearchScrollCell.m
//  Code
//
//  Created by Ivan li on 2018/3/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSearchScrollCell.h"
#import "HKSearchScrollVideoCell.h"
#import "HKSearchCourseModel.h"
#import "HKImageTextIV.h"
#import "UIButton+ImageTitleSpace.h"



#define cellHeight 150


@interface HKSearchScrollCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic)  UICollectionView *contentCollectionView;
/** 目录 */
@property(nonatomic,strong)UILabel *categoryLb;
/** 更多 按钮 */
@property (strong, nonatomic)  UIButton *moreBtn;


@property (nonatomic ,  strong) UIView * lineView;

@end

@implementation HKSearchScrollCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.contentCollectionView];
        [self.contentView addSubview:self.categoryLb];
        [self.contentView addSubview:self.moreBtn];
//        [self.contentView addSubview:self.lineView];
        //self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}




- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    [self.categoryLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(PADDING_15);
    }];
    
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryLb.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(IS_IPAD ? 180: 105);//155
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.centerY.equalTo(self.categoryLb);
    }];
    
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(10);
//        make.bottom.left.right.equalTo(self.contentView);
//    }];
    
}


- (UILabel*)categoryLb {
    if (!_categoryLb) {
        _categoryLb  = [UILabel labelWithTitle:CGRectZero title:@"系列课"
                                    titleColor:COLOR_27323F_EFEFF6
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _categoryLb.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
    }
    return _categoryLb;
}


- (UIButton*)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = HK_FONT_SYSTEM(13);
        
        [_moreBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        [_moreBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateHighlighted];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setHKEnlargeEdge:20];
        _moreBtn.hidden = YES;
    }
    return _moreBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _lineView;
}


- (void)moreBtnClick:(UIButton*)btn {
    if (self.moreBtnClickBackCall) {
        self.moreBtnClickBackCall();
    }
}


- (void)setSerieslistModel:(HKSerieslistModel *)serieslistModel {
    _serieslistModel  = serieslistModel;
    
    if (serieslistModel.total_count >5) {
        NSString *title = [NSString stringWithFormat:@"查看%ld条结果",serieslistModel.total_count];
        [self.moreBtn setTitle:title forState:UIControlStateNormal];
        [self.moreBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:3];
        self.moreBtn.hidden = NO;
    }
}


- (void)setSeriesArr:(NSMutableArray<VideoModel *> *)seriesArr {
    _seriesArr = seriesArr;
    // 刷新CollectionView
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([self.contentCollectionView cellForItemAtIndexPath:indexPath2]) {
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath2 atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self.contentCollectionView reloadData];
}


- (UICollectionView*)contentCollectionView {
    if (!_contentCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        //layout.itemSize = CGSizeMake(170, 105);
        layout.itemSize = IS_IPAD ? CGSizeMake(280 , 180):CGSizeMake(135, 105);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 15);
        [_contentCollectionView registerClass:[HKSearchScrollVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([HKSearchScrollVideoCell class])];
    }
    return _contentCollectionView;
}



#pragma mark <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSInteger count = self.seriesArr.count;
    if (count>5) {
        return 5;
    }else{
        return self.seriesArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    HKSearchScrollVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchScrollVideoCell class]) forIndexPath:indexPath];
//    if (row>=3) {
//        [cell setDefaultImageWithName:@"look_more"];
//    }else{
//        cell.model = self.seriesArr[indexPath.row];
//    }    
    cell.model = self.seriesArr[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !self.searchScrollVideoSelectedBlock? : self.searchScrollVideoSelectedBlock(indexPath, self.seriesArr[indexPath.row]);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

@end




