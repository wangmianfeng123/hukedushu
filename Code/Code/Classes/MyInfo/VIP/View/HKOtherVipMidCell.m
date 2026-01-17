//
//  HKOtherVipMidCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKOtherVipMidCell.h"
#import "HKOtherVipInCell.h"


@interface HKOtherVipMidCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)HKBuyVipModel *selectedModel; // 当前选中的model

//@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (nonatomic, strong)NSMutableArray<HKBuyVipModel *> *dataSource;

@end

@implementation HKOtherVipMidCell

- (void)setSelectedModel:(HKBuyVipModel *)selectedModel {
    _selectedModel = selectedModel;
//    // 调用代理
//    if ([self.delegate respondsToSelector:@selector(HKOtherVIPSelected:)]) {
//        [self.delegate HKOtherVIPSelected:selectedModel];
//    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setpCollectionView];
    
    //self.collectionView.backgroundColor = COLOR_F8F9FA_333D48;
    self.collectionView.backgroundColor = COLOR_FFFFFF_3D4752;

}

- (void)setDataSource:(NSMutableArray<HKBuyVipModel *> *)dataSource vipInfoExModel:(HKVipInfoExModel *)model {
    _dataSource = dataSource;
    
    // 是否是3个整数
    if (dataSource.count > 0 && dataSource.count % 3 != 0) {
        HKBuyVipModel *model = [[HKBuyVipModel alloc] init];
        model.name = @"更新中";
        model.class_name = @"更新中";
        model.price = @"敬请期待";
        model.is_lastBtn = YES;
        [dataSource addObject:model];
    }
    
    // 多少分类vip数量
//    NSString *stringCount = [NSString stringWithFormat:@"%@大分类", model.class_total];
//    NSString *wholeString = [NSString stringWithFormat:@"%@(更多分类更新中)", stringCount];
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:wholeString];
//    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_27323F_EFEFF6 range:NSMakeRange(0, stringCount.length)];
//    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium] range:NSMakeRange(0, stringCount.length)];
//    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_A8ABBE_7B8196 range:NSMakeRange(stringCount.length, wholeString.length - stringCount.length)];
//    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0 weight:UIFontWeightMedium] range:NSMakeRange( stringCount.length, wholeString.length - stringCount.length)];
//    self.titleName.attributedText = attr;

    [self.collectionView reloadData];
}

- (void)setpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 8.0;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 15.0 * 2 - 2 * 8.0 - 0.1) / 3.0, (IS_IPHONEMORE4_7INCH? 70 : 65)+9);
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKOtherVipInCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKOtherVipInCell class])];
    //[self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 0.5)), dispatch_get_main_queue(), ^{
        NSLog(@"self.collectionView.frame %@", NSStringFromCGRect(self.collectionView.frame));
        NSLog(@"layout.itemSize %@", NSStringFromCGSize(layout.itemSize));
    });
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKOtherVipInCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKOtherVipInCell class]) forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    // 设置选中的model
    if (cell.model.is_selected) {
        self.selectedModel = cell.model;
    }
    return cell;
}


#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 最后"更新中"一个不可点击
    if (self.dataSource[indexPath.row].is_lastBtn) return;
    
    // 更新选中的model
    if (self.selectedModel) {
        self.selectedModel.is_selected = NO;
    }
    self.dataSource[indexPath.row].is_selected = YES;
    self.selectedModel = self.dataSource[indexPath.row];
    [self.collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(HKOtherVIPSelected:)]) {
        [self.delegate HKOtherVIPSelected:self.selectedModel];
    }
}



@end
