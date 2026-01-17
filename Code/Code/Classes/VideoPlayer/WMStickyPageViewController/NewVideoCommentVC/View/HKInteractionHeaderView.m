//
//  HKInteractionHeaderView.m
//  Code
//
//  Created by eon Z on 2021/9/1.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKInteractionHeaderView.h"
#import "UIView+HKLayer.h"
#import "HKCommentImgCell.h"

@interface HKInteractionHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , strong) UIView * bgView;
@property (nonatomic , strong) UILabel * topRightLabel;
@property (nonatomic , strong) UILabel * detailLabel;
@property (nonatomic , strong) UIButton * tipBtn;
@property (nonatomic , strong) NSMutableArray * imgArray;
@property (nonatomic , strong) UICollectionView * collectionView;

@end

@implementation HKInteractionHeaderView

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0;
        CGFloat w = ((IS_IPAD ? iPadContentWidth :SCREEN_WIDTH) - 30 - 20) / 3.0;//(SCREEN_WIDTH - 30 - 20)/3.0;
        layout.itemSize = CGSizeMake(w, w);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.collectionViewLayout = layout;
        _collectionView.showsVerticalScrollIndicator =  NO;
        _collectionView.showsHorizontalScrollIndicator =  NO;
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCommentImgCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKCommentImgCell class])];
    }
    return _collectionView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createUI];
//        self.backgroundColor = COLOR_F8F9FA_3D4752;
    }
    return self;
}

- (void)createUI{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.topRightLabel];
    [self.bgView addSubview:self.detailLabel];
    [self.bgView addSubview:self.tipBtn];
    [self.bgView addSubview:self.collectionView];
    [self makeConstraints];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (NSMutableArray *)imgArray{
    if (_imgArray == nil) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (void)makeConstraints{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.left.equalTo(self).offset(15);
    }];
    
    [self.topRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.bgView).offset(10);
        make.height.mas_equalTo(@20);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topRightLabel.mas_right).offset(5);
        make.bottom.equalTo(self.topRightLabel);
        make.height.mas_equalTo(@20);
    }];
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.topRightLabel);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(32);
        make.left.equalTo(self.bgView).offset(10);
        make.right.equalTo(self.bgView).offset(-10);
        make.bottom.equalTo(self.bgView);
    }];
}

-(void)setUrlArray:(NSMutableArray *)urlArray{
    _urlArray = urlArray;
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.urlArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HKCommentImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCommentImgCell class]) forIndexPath:indexPath];
    NSString * url = self.urlArray[indexPath.row];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:url]] placeholderImage:HK_PlaceholderImage];
    cell.deleteBtn.hidden = YES;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didImgBlock) {
        self.didImgBlock(indexPath.row);
    }
}


//- (void)clickImage:(UITapGestureRecognizer *)tap{
//    if (self.didImgBlock) {
//        self.didImgBlock(tap.view.tag);
//    }
//}

- (UIButton*)tipBtn {
    if (!_tipBtn) {
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_quiz_download_2_37" darkImageName:@"ic_quiz_download_dark_2_37"] forState:UIControlStateNormal];
        [_tipBtn addTarget:self action:@selector(tipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
}

- (void)tipBtnClick{
    if (self.tipBlock) {
        self.tipBlock();
    }
}

- (UIView * )bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = COLOR_FFFFFF_3D4752;
        
        [_bgView addCornerRadius:5 addBoderWithColor:COLOR_EFEFF6_333D48];
    }
    return _bgView;
}

- (UILabel*)topRightLabel {
    
    if (!_topRightLabel) {
        _topRightLabel  = [[UILabel alloc] init];
        [_topRightLabel setTextColor:COLOR_7B8196_A8ABBE];
        _topRightLabel.textAlignment = NSTextAlignmentLeft;
        _topRightLabel.font = [UIFont systemFontOfSize:14];//[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14: 13 weight:<#UIFontWeightMedium];
        _topRightLabel.text = @"本课作业";
    }
    return _topRightLabel;
}

- (UILabel*)detailLabel {
    
    if (!_detailLabel) {
        _detailLabel  = [[UILabel alloc] init];
        [_detailLabel setTextColor:COLOR_A8ABBE_7B8196];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [UIFont systemFontOfSize:13];//[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14: 13 weight:<#UIFontWeightMedium];
        _detailLabel.text = @"100%作业点评";
    }
    return _detailLabel;
}

@end
