//
//  HKYeasVipPrivilegeCell.m
//  Code
//
//  Created by eon Z on 2021/11/9.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKYeasVipPrivilegeCell.h"
#import "HKVipPrivilegeInCell.h"
#import "HKVipPrivilegeModel.h"
#import "UIView+HKLayer.h"
#import "UIView+SNFoundation.h"

@interface HKYeasVipPrivilegeCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@end

@implementation HKYeasVipPrivilegeCell

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.topView.backgroundColor = COLOR_F8F9FA_333D48;
    self.collectionView.backgroundColor = COLOR_F8F9FA_333D48;

    self.titleLabel.textColor = COLOR_694C2F_EFEFF6;
    
    self.desLabel.textColor = [UIColor colorWithHexString:@"#7B8196"];
    self.nameLabel.textColor = COLOR_27323F_EFEFF6;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setpCollectionView];
    [self.collectionView addCornerRadius:5];
    [self.topView addCornerRadius:5];
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
//    [self.moreBtn layoutButtonWithEdgeInsetsStyle:<#(HKButtonEdgeInsetsStyle)#> imageTitleSpace:<#(CGFloat)#>]
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
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKVipPrivilegeInCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKVipPrivilegeInCell class])];
    [self.collectionView setContentInset:UIEdgeInsetsMake(15, 0, 25, 0)];
}

-(void)setDataSource:(NSMutableArray<HKVipPrivilegeModel *> *)dataSource{
    _dataSource = dataSource;
    if (dataSource.count) {
        HKVipPrivilegeModel * model = self.dataSource[0];
        [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:HK_PlaceholderImage];
        self.nameLabel.text = model.name;
        self.desLabel.text = model.des;
        
        [self.dataArray removeAllObjects];
        for (int i = 1; i < dataSource.count; i++) {
            HKVipPrivilegeModel * model = self.dataSource[i];
            [self.dataArray addObject:model];
        }
    }
    
    [self.collectionView reloadData];
    
}

- (IBAction)moreBtnClick {
    if (self.didMoreBlock) {
        self.didMoreBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKVipPrivilegeInCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKVipPrivilegeInCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

@end
