//
//  HKDetailRecommandView.m
//  Code
//
//  Created by Ivan li on 2021/5/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKDetailRecommandView.h"
#import "HKHomeAlbumSubCell.h"
#import "UIScrollView+HKGestureRecognizer.h"

@interface HKDetailRecommandView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , strong) UILabel * titleLabel;
@property (nonatomic , strong) UIButton * moreBtn;
@property (nonatomic , strong) UICollectionView * collectionView;
@property (nonatomic , strong) UIView * lineView;
@end

@implementation HKDetailRecommandView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)createUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.moreBtn];
    [self addSubview:self.collectionView];
    [self addSubview:self.lineView];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _lineView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:@"选择小节" titleColor:COLOR_27323F_EFEFF6 titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIButton *)moreBtn{
    if (_moreBtn == nil) {
        _moreBtn = [UIButton buttonWithTitle:@"全部" titleColor:COLOR_A8ABBE_7B8196 titleFont:@"13" imageName:@"ic_go"];
        [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _moreBtn;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * layout= [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKHomeAlbumSubCell" bundle:nil] forCellWithReuseIdentifier:@"HKHomeAlbumSubCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator =  NO;
        _collectionView.showsHorizontalScrollIndicator =  NO;
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _collectionView.bounces = NO;
        // 1.设置代理
//        _collectionView.panGestureRecognizer.delegate = self;
    }
    return _collectionView;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self makeConstraints];
}

- (void)makeConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(50);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(50);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(140);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(7);
    }];
}

-(void)setDetaiModel:(DetailModel *)detaiModel{
    _detaiModel = detaiModel;
    [self.dataArray removeAllObjects];
    
    if ([self.detaiModel.video_type isEqualToString:@"6"] || [self.detaiModel.video_type isEqualToString:@"7"] || (self.detaiModel.is_series && (self.detaiModel.is_buy_series == 1))) {
        //HKCourseModel *secCourse 一级Model
        for (int k = 0; k < self.detaiModel.dataSource.count; k++) {
            HKCourseModel * secCourse = self.detaiModel.dataSource[k];
            NSInteger tempCount = secCourse.children.count;
            if (tempCount == 0) {
                secCourse.praticeNO = [NSString stringWithFormat:@"第%d节",k+1];
                [self.dataArray addObject:secCourse];
            }else{
                for (int i = 0; i < secCourse.children.count; i++) {
                    //HKCourseModel * course  二级model
                    HKCourseModel * courseModel = secCourse.children[i];
                    courseModel.praticeNO = [NSString stringWithFormat:@"%d-%d",k+1,i+1];
                    [self.dataArray addObject:courseModel];

                    if (courseModel.children.count) {
                        for (int j = 0; j < courseModel.children.count; j++) {
                            //HKCourseModel * model 三级model
                            HKCourseModel * model = courseModel.children[j];
                            model.praticeNO = [NSString stringWithFormat:@"练习%d",j+1];
                            [self.dataArray addObject:model];
                        }
                    }
                }
            }
        }
    }else{
        [self.dataArray addObjectsFromArray:self.detaiModel.dataSource];
    }
    
    NSIndexPath * index = nil;
    for (int i = 0; i < self.dataArray.count; i++) {
        HKCourseModel * model = self.dataArray[i];
        if (model.currentWatching == YES) {
            index = [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    [self.collectionView reloadData];
    
    [self.moreBtn setTitle:[NSString stringWithFormat:@"全部%ld节",self.dataArray.count] forState:UIControlStateNormal];
    [self.moreBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:3];

    if (index) {
        [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    HKHomeAlbumSubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKHomeAlbumSubCell" forIndexPath:indexPath];
    // 系列课
    NSInteger type = [self.detaiModel.video_type integerValue];
    HKCourseModel *seriesCourseModel = self.dataArray[indexPath.row];
    cell.isVideoDetail = YES;
    [cell setModel:seriesCourseModel videoType:type];
    cell.numberLabel.hidden = NO;
    if (type == 6|| type == 7 || (self.detaiModel.is_series && (self.detaiModel.is_buy_series == 1))) {
        cell.numberLabel.text = seriesCourseModel.praticeNO;
    }else{
        cell.numberLabel.text = [NSString stringWithFormat:@"第%ld节",indexPath.row + 1];
    }
    // 课程
//    if ([self.detaiModel.video_type isEqualToString:@"6"]|| [self.detaiModel.video_type isEqualToString:@"7"] || (self.detaiModel.is_series && (self.detaiModel.is_buy_series == 1))) {
//        HKCourseModel *secCourseModel = self.detaiModel.dataSource[indexPath.section];
//        HKCourseModel *courseModel = secCourseModel.children[indexPath.row];
//        [cell setModel:courseModel videoType:type];
//        cell.numberLabel.text = courseModel.praticeNO;
//    }else{
//        HKCourseModel *seriesCourseModel = self.detaiModel.dataSource[indexPath.row];
//        [cell setModel:seriesCourseModel videoType:type];
//        cell.numberLabel.text = [NSString stringWithFormat:@"第%ld节",indexPath.row + 1];
//    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HKCourseModel *seriesCourseModel = self.dataArray[indexPath.row];
    
    NSIndexPath * index = nil;
    for (int i = 0; i < self.dataArray.count; i++) {
        HKCourseModel * model = self.dataArray[indexPath.row];
        if ([model.video_id isEqualToString:seriesCourseModel.video_id]) {
            model.currentWatching = YES;
            index = [NSIndexPath indexPathForRow:i inSection:0];
        }else{
            model.currentWatching = NO;
        }
    }
    
    if (self.cellClickBlock) {
        self.cellClickBlock(seriesCourseModel);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 16, 0, 16);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    return CGSizeMake(140, 140);
}

- (void)moreBtnClick{
    if (self.moreClickBlock) {
        self.moreClickBlock();
    }
}


// 2.实现方案
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//
//    // 开启侧滑返回功能
//
//    // 是否为平移手势
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        // 获取平移方向
//        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
//        // 向右滑动 && scrollView滑动到最左侧
//        if (translation.x >= 0 && self.collectionView.contentOffset.x <= 0) {
//            return NO;
//        }
//
//    }
//    return YES;
//}


@end
