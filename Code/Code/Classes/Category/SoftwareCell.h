//
//  SoftwareCell.h
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SoftwareModel;

@interface SoftwareCell : TBCollectionHighLightedCell

@property(nonatomic,strong)SoftwareModel *model;

@property(nonatomic,copy)NSString *imageName;



@end
