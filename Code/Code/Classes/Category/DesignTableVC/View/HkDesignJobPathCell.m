//
//  HkDesignJobPathCell.m
//  Code
//
//  Created by Ivan li on 2019/8/1.
//  Copyright © 2019 pg. All rights reserved.
//


#import "HkDesignJobPathCell.h"
#import "HKJobPathModel.h"
#import "UIImageView+LBBlurredImage.h"
#import "HKCustomMarginLabel.h"
#import "HKCoverBaseIV.h"
#import "HKDesignJobPathTopCell.h"

@interface HkDesignJobPathCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic)UICollectionView *contentCollectionView;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton * vipBtn;
@end

@implementation HkDesignJobPathCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentCollectionView];
        self.titleLabel.textColor = COLOR_27323F_EFEFF6;
        
        
        self.vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.vipBtn.titleLabel setFont:HK_FONT_SYSTEM(13)];
        [self.vipBtn setTitle:@"全站通VIP尊享" forState:UIControlStateNormal];
        [self.vipBtn setTitle:@"全站通VIP尊享" forState:UIControlStateHighlighted];
        [self.vipBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
        [self.vipBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateHighlighted];
        self.vipBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [self.vipBtn addTarget:self action:@selector(vipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image = [UIImage imageNamed:@"ic_vip_2_30"];
        [self.vipBtn setImage:image forState:UIControlStateNormal];
        [self.vipBtn setImage:image forState:UIControlStateHighlighted];
        [self.vipBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [self.vipBtn sizeToFit];
        
        [self.contentView addSubview:self.vipBtn];
    }
    return self;
}

- (void)vipBtnClick{
    [MobClick event: list_vip_prime];
    if (self.didVipBlock) {
        self.didVipBlock();
        [HKALIYunLogManage sharedInstance].button_id = @"13";
    }

}

- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"" titleColor:COLOR_27323F
                                  titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    }
    return _titleLabel;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(17);
        make.top.equalTo(self.contentView).offset(12);
        //make.height.mas_equalTo(44);
    }];
    
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView);
        //make.height.mas_equalTo(120);
        make.height.mas_equalTo(96);
    }];
    
    [self.vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-17);
        make.top.equalTo(self).offset(12);
    }];
}




- (void)setSeriesArr:(NSMutableArray<HKJobPathModel *> *)seriesArr {
    _seriesArr = seriesArr;
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([self.contentCollectionView cellForItemAtIndexPath:indexPath2]) {
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath2 atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    // 刷新CollectionView
    [self.contentCollectionView reloadData];
    if (seriesArr.count) {
        HKJobPathModel * model = seriesArr[0];
        if (!isEmpty(model.master_video_total)) {
            self.titleLabel.text = @"课程推荐";
        }else{
            self.titleLabel.text = @"职业路径";
        }
    }
    //[[HKAccountTool shareAccount].vip_class iseq]
    if (isLogin()) {
        if ([[HKAccountTool shareAccount].vip_class isEqualToString:@"2"] || [[HKAccountTool shareAccount].vip_class isEqualToString:@"3"]) {
            self.vipBtn.hidden = YES;
        }else{
            self.vipBtn.hidden = NO;
        }
    }else{
        self.vipBtn.hidden = NO;
    }
    self.vipBtn.hidden = NO;
}


- (UICollectionView*)contentCollectionView {
    if (!_contentCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(250, 96);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        //[_contentCollectionView registerClass:[HkDesignJobPathChildrenCell class] forCellWithReuseIdentifier:NSStringFromClass([HkDesignJobPathChildrenCell class])];
        [_contentCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKDesignJobPathTopCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKDesignJobPathTopCell class])];
        _contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _contentCollectionView;
}



#pragma mark <UICollectionViewDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.seriesArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    HkDesignJobPathChildrenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HkDesignJobPathChildrenCell class]) forIndexPath:indexPath];
//    cell.model = self.seriesArr[indexPath.section];
//    return cell;
    
    HKDesignJobPathTopCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKDesignJobPathTopCell class]) forIndexPath:indexPath];
    cell.model = self.seriesArr[indexPath.section];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    !self.videoSelectedBlock? : self.videoSelectedBlock(indexPath, self.seriesArr[indexPath.section]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 10);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}


@end





@interface HkDesignJobPathChildrenCell()

@property (strong,nonatomic)HKCoverBaseIV *coverIV;

@property (nonatomic,strong)UILabel *titleLabel;

@end



@implementation HkDesignJobPathChildrenCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.coverIV];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(156, 96));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.coverIV.mas_bottom).offset(4);
    }];
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM(14);
    }
    return _titleLabel;
}



- (HKCoverBaseIV*)coverIV {
    if(!_coverIV){
        _coverIV = [HKCoverBaseIV new];
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.clipsToBounds = YES;
        _coverIV.layer.cornerRadius = 3;
        _coverIV.hiddenText = NO;
        _coverIV.textLBHeight = 25;
        _coverIV.textLB.font = HK_FONT_SYSTEM(13);
        _coverIV.textLB.textInsets = UIEdgeInsetsMake(3, 5, 3, 0);
    }
    return _coverIV;
}



- (void)setModel:(HKJobPathModel *)model {
    _model = model;
    
    if (!isEmpty(model.career_type)) {
        NSString *str = nil;
        if (!isEmpty(model.master_video_total)) {
            str = [NSString stringWithFormat:@"%@课   ",model.master_video_total];
        }
        if (!isEmpty(model.slave_video_total)) {
            if (isEmpty(str)) {
                str = [NSString stringWithFormat:@"%@练习",model.slave_video_total];
            }else{
                str = [str stringByAppendingFormat:@"%@练习",model.slave_video_total];
            }
        }
        self.titleLabel.text = model.video_title;
        self.coverIV.textLB.text = str;
        self.coverIV.textLB.hidden = NO;
        
    }else{
        self.titleLabel.text = model.title;
        NSString *str = model.course_number ?[NSString stringWithFormat:@"共%ld节",(long)model.course_number] : @"";
        self.coverIV.textLB.text = str;
        self.coverIV.textLB.hidden = isEmpty(str);
    }
    
    [self.coverIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.cover]) placeholderImage:HK_PlaceholderImage];
//        //高斯模糊
//        [self.coverIV setImageToBlur:image
//                          blurRadius:35
//                     completionBlock:^(NSError *error){
//                         NSLog(@"The blurred image has been setted");
//                     }];
}


@end
