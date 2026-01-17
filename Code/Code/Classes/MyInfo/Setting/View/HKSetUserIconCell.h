//
//  HKSetUserIconCell.h
//  Code
//
//  Created by Ivan li on 2018/5/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKSetUserIconCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIV;

@property(nonatomic,strong)HKUserModel *userModel;

@property(nonatomic,strong)UIImage *iconImage;

@end
