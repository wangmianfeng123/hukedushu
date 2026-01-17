//
//  HKMyVIPHeaderCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/11.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMyVIPHeaderCell.h"

@interface HKMyVIPHeaderCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionMidView;


@end

@implementation HKMyVIPHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
