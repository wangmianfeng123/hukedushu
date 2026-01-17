//
//  HKNewLearnerCell.h
//  Code
//
//  Created by hanchuangkeji on 2018/5/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoftwareModel.h"

@interface HKNewLearnerCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet UILabel *courseLB;

@property (weak, nonatomic) IBOutlet UIView *sepMidView;
@property (weak, nonatomic) IBOutlet UIView *sepBtmView;

@property (nonatomic, strong)SoftwareModel *model;

@end
