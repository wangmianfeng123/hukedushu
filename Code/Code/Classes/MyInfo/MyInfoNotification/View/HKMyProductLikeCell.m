//
//  HKMyInfoNotificationCell.m
//  Code 11
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMyProductLikeCell.h"



@interface HKMyProductLikeCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIImageView *leftIV;
@property (weak, nonatomic) IBOutlet UIView *redPointView;

@end


@implementation HKMyProductLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headerIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatorClick)];
    [self.headerIV addGestureRecognizer:tap];
    
    self.redPointView.clipsToBounds = YES;
    self.redPointView.layer.cornerRadius = 3.0;
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = 20.0;
    self.leftIV.clipsToBounds = YES;
    self.leftIV.layer.cornerRadius = 5.0;
    
}

- (void)avatorClick {
    !self.avatorClickBlock? :  self.avatorClickBlock(self.model);
}

@end






@implementation HKMyProductLikeCellModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}
@end
