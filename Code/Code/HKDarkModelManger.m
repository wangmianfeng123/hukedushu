//
//  HKDarkModelManger.m
//  Code
//
//  Created by ivan on 2020/6/5.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKDarkModelManger.h"
#import "Code-Swift.h"

#define  lastThemeIndexKey @"lastedThemeIndex"


@implementation HKDarkModelManger

+ (instancetype)shareInstance {
    static HKDarkModelManger *darkModelManger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         darkModelManger = [[HKDarkModelManger alloc] init];
    });
    return darkModelManger;
}


- (void)setAPPUserTheme {
    if (@available(iOS 13.0, *)) {
        NSInteger index = [[self class] hk_lastTheme];
        isFouceLight = (2 == index) ? NO :YES;
        DMTraitCollection *trait =[DMTraitCollection traitCollectionWithUserInterfaceStyle: isFouceLight ?DMUserInterfaceStyleLight :DMUserInterfaceStyleDark];
        [DMTraitCollection setCurrentTraitCollection:trait];
    }
}









///  更新APP主题模式
- (void)updateAPPUserTheme {
    if (@available(iOS 13.0, *)) {
        DMUserInterfaceStyle faceStyle = [DMTraitCollection currentTraitCollection].userInterfaceStyle;
        faceStyle = (DMUserInterfaceStyleDark ==faceStyle) ? DMUserInterfaceStyleLight :DMUserInterfaceStyleDark;
        DMTraitCollection *trait = [DMTraitCollection traitCollectionWithUserInterfaceStyle:faceStyle];
            [DMTraitCollection setCurrentTraitCollection:trait];
        // 更新主题
        [DarkModeManager updateAppearanceFor:[UIApplication sharedApplication] animated:YES];
    }
}




#pragma mark 上次保存的主题 0-默认  1-强制浅色  2-黑夜模式
+ (NSInteger)hk_lastTheme {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger type = [defaults integerForKey:lastThemeIndexKey];
    return type;
}


#pragma mark 保存的主题
+ (void)hk_saveLastTheme:(NSInteger)themeIndex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:themeIndex forKey:lastThemeIndexKey];
}



@end

