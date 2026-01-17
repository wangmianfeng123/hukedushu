//
//  HKMomentRankMenu.h
//  Code
//
//  Created by Ivan li on 2021/1/22.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HKMomentRankMenuDelegate <NSObject>

- (void)momentRankMenuDidRankBtn:(NSInteger)tag;
- (void)momentRankMenuDidfiltrateBtn;

@end

@interface HKMomentRankMenu : UIView
@property(nonatomic,weak)id<HKMomentRankMenuDelegate>delegate;
@property (nonatomic , strong) NSArray * typeArray;
@property (nonatomic , assign) BOOL needFiltrateBtn ;
@property (nonatomic , assign) BOOL isRequestion ;
@property (weak, nonatomic) IBOutlet UIButton *filtrateBtn;
@property (nonatomic , strong) UIColor * selectedTitleColor;
@property (nonatomic , strong) UIColor * selectedBgColor;

@end

NS_ASSUME_NONNULL_END
