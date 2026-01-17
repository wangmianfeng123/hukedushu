//
//  HKOtherVipMidCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKVipPrivilegeCell.h"
#import "HKVipPrivilegeInCell.h"
#import "HKVipPrivilegeModel.h"
  
#import "UIView+SNFoundation.h"

@interface HKVipPrivilegeCell() <UICollectionViewDelegate, UICollectionViewDataSource,TBSrollViewEmptyDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)HKVipPrivilegeModel *selectedModel; // 当前选中的model

@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (nonatomic, strong)NSMutableArray<HKVipPrivilegeModel *> *dataSource;

// 数据集合
@property (nonatomic, strong)NSMutableArray *headerArray;
@property (nonatomic, strong)NSMutableArray *nameArray;
@property (nonatomic, strong)NSMutableArray *desArray;

@property (nonatomic, strong)HKVipPrivilegeTagView *tagView;

@end

@implementation HKVipPrivilegeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setpCollectionView];
    
    [self.contentView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleName.mas_right).offset(3);
        make.top.equalTo(self.titleName.mas_top).offset(-10);
    }];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.titleName.textColor = COLOR_27323F_EFEFF6;
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.collectionView.backgroundColor = COLOR_F8F9FA_333D48;
}

- (void)setDataSource:(NSMutableArray<HKVipPrivilegeModel *> *)dataSource vipInfoExModel:(HKVipInfoExModel *)model {
    _dataSource = dataSource;
    
    // 权益
    //self.titleName.text = model.privilegeString;
    self.titleName.text = @"6大权益";

    [self.collectionView reloadData];
}

- (void)setpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 15;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 20 * 2 - 2 * 15 - 0.1) / 3.0, IS_IPHONEMORE4_7INCH? 74 : 68);
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.tb_EmptyDelegate = self;
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKVipPrivilegeInCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKVipPrivilegeInCell class])];
    [self.collectionView setContentInset:UIEdgeInsetsMake(15, 0, 25, 0)];
}


#pragma mark -- tb_EmptyDelegate
- (BOOL)tb_showEmptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return NO;
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKVipPrivilegeInCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKVipPrivilegeInCell class]) forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}



/** 隐藏 职业路径 tag view */
- (void)hiddenPrivilegeTagView {
    self.tagView.hidden = YES;
}

- (HKVipPrivilegeTagView*)tagView {
    if (!_tagView) {
        _tagView = [[HKVipPrivilegeTagView alloc]init];
    }
    return _tagView;
}


@end




@interface HKVipPrivilegeTagView()

@property (strong, nonatomic)  UILabel *tagLB;

@end



@implementation HKVipPrivilegeTagView

- (instancetype)init {
    if (self = [super init]) {
        
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.image = [self bgImage];
    [self addSubview:self.tagLB];
    
    [self.tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.lessThanOrEqualTo(self);
    }];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomRight radius:10];
}


- (UIImage*)bgImage {
    UIColor *color = [UIColor colorWithHexString:@"#FF961F"];
    UIColor *color1 = [UIColor colorWithHexString:@"#FF7838"];
    UIColor *color2 = [UIColor colorWithHexString:@"#FF5555"];
    
    UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(106, 20) gradientColors:@[color2,color1,color] percentage:@[@(0.1),@(0.5),@(1)] gradientType:GradientFromLeftToRight];
    
    return image;
}


- (UILabel*)tagLB {
    if (!_tagLB) {
        _tagLB = [UILabel labelWithTitle:CGRectZero title:@"新增职业路径权益" titleColor:COLOR_ffffff titleFont:@"11" titleAligment:NSTextAlignmentCenter];
        [_tagLB sizeToFit];
    }
    return _tagLB;
}

@end

