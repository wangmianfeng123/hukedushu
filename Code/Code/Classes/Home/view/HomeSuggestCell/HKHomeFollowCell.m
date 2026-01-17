//
//  HKHomeFollowCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKHomeFollowCell.h"
#import "HomeMyFollowVideoCell.h"
#import "HKMyFollowVC.h"


@interface HKHomeFollowCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *avatorIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *goodAtLB;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@end


@implementation HKHomeFollowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    
    self.tb_hightedLigthedInset = UIEdgeInsetsMake(13, 0, 5 + 20, 0);
    [self setFollowBtnStyle];
    
    [self setupCollectionView];
    
    if (IS_IPAD) {
        [self.avatorIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }
    self.avatorIV.clipsToBounds = YES;
    self.avatorIV.layer.cornerRadius = self.avatorIV.height * 0.5;
    
    self.nameLB.textColor = COLOR_27323F_EFEFF6;
    self.separator.backgroundColor = COLOR_F8F9FA_333D48;
}

- (void)setFollowBtnStyle {
    [self.followBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [self.followBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateSelected];
    [self.followBtn setImage:imageName(@"add_sign_black") forState:UIControlStateNormal];
    // 设置关注按钮
    self.followBtn.clipsToBounds = YES;
    self.followBtn.layer.borderWidth = 0.5;
    self.followBtn.layer.cornerRadius = PADDING_25 * 0.5;
    self.followBtn.layer.borderColor = COLOR_333333.CGColor;
    [self.followBtn addTarget:self action:@selector(focusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 关注 讲师
- (void)focusBtnClick:(UIButton*)btn {
    
    
    UIButton *followBtn = btn;
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    NSValue *value1 = [NSNumber numberWithFloat:1.0];
    NSValue *value2 = [NSNumber numberWithFloat:1.2];
    NSValue *value3 = [NSNumber numberWithFloat:1.0];
    anima.values = @[value1,value2,value3];
    anima.duration = 0.2;
    [followBtn.layer addAnimation:anima forKey:@"scale"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * anima.duration)), dispatch_get_main_queue(), ^{
        !self.followTeacherSelectedBlock? : self.followTeacherSelectedBlock(self.indexPath, self.teacher_info);
    });
}



- (void)setTeacher_info:(HKUserModel *)teacher_info hiddenSeparator:(BOOL)hiddenSeparator index:(NSIndexPath *)index {
    _teacher_info = teacher_info;
    _indexPath = index;
    [self.avatorIV sd_setImageWithURL:[NSURL URLWithString:teacher_info.avator] placeholderImage:imageName(HK_Placeholder)];
    self.nameLB.text = teacher_info.name;
    self.goodAtLB.text = [NSString stringWithFormat:@"擅长：%@", teacher_info.tags];
    self.goodAtLB.hidden = teacher_info.tags.length ? NO : YES;
    
    // 关注按钮
    [self setFocusBtnStyle:self.followBtn isFollow:teacher_info.is_follow];
    
    // 刷新CollectionView
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([self.contentCollectionView cellForItemAtIndexPath:indexPath2]) {
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath2 atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self.contentCollectionView reloadData];
    self.followBtn.hidden = NO;
    // 隐藏分割线
    self.separator.hidden = hiddenSeparator;
}

- (void)setTeacher_info:(HKUserModel *)teacher_info {
    _teacher_info = teacher_info;
    [self.avatorIV sd_setImageWithURL:[NSURL URLWithString:teacher_info.avator] placeholderImage:imageName(HK_Placeholder)];
    self.nameLB.text = teacher_info.name;
    self.goodAtLB.text = [NSString stringWithFormat:@"擅长：%@", teacher_info.tags];
    
    // 刷新CollectionView
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([self.contentCollectionView cellForItemAtIndexPath:indexPath2]) {
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath2 atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    [self.contentCollectionView reloadData];
}


- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 8.0;
    layout.minimumInteritemSpacing = 8.0;
    layout.itemSize = CGSizeMake(312 * 0.5, 195 * 0.5);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    [self.contentCollectionView setCollectionViewLayout:layout];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeMyFollowVideoCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HomeMyFollowVideoCell class])];
    self.contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
}



#pragma mark <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.teacher_info.video_list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeMyFollowVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeMyFollowVideoCell class]) forIndexPath:indexPath];
    cell.model = self.teacher_info.video_list[indexPath.row];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return IS_IPAD? CGSizeMake(200, 150) : CGSizeMake(312 * 0.5, 118);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    !self.homeMyFollowVideoSelectedBlock? : self.homeMyFollowVideoSelectedBlock(indexPath, self.teacher_info.video_list[indexPath.row]);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}


//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (cell) {
//        [UIView animateWithDuration:0.1 animations:^{
//            cell.transform = CGAffineTransformMakeScale(0.5, 0.5);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.1 animations:^{
//                cell.transform = CGAffineTransformMakeScale(1, 1);
//            } completion:^(BOOL finished) {
//
//            }];
//        }];
//    }
//}


#pragma mark -设置 关注按钮 样式
- (void)setFocusBtnStyle:(UIButton *)btn isFollow:(BOOL)isFollow {
    btn.selected = isFollow;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,isFollow ? -8 : PADDING_5, 0, 0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, isFollow ? -PADDING_30*2: -PADDING_5, 0, 0)];
    
    [btn setBackgroundColor:isFollow ? COLOR_EFEFF6_7B8196:COLOR_FFFFFF_3D4752];
    btn.layer.borderColor = isFollow ? COLOR_EFEFF6_7B8196.CGColor :COLOR_27323F_FFFFFF.CGColor;
}


- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    
    if (@available(iOS 13.0, *)) {
        // 主题模式 发生改变
        [self setFocusBtnBorderColor];
    }
}



- (void)setFocusBtnBorderColor {
    if (_followBtn) {
        [self setFocusBtnStyle:_followBtn isFollow:_teacher_info.is_follow];
    }
}

@end

