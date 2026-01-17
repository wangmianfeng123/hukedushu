//
//  TabBarControllerConfig.m
//  gcnsxp
//
//  Created by happying on 16/11/8.
//  Copyright © 2016年 gcn. All rights reserved.
//


//static CGFloat const CYLTabBarControllerHeight = 44 * Ratio;

#import "TabBarControllerConfig.h"
#import "HomeVideoVC.h"
#import "HKNavigationController.h"
#import "FWDefine.h"
#import "MyInfoViewController.h"
#import "HKStudyVC.h"
#import "HKCategoryVC.h"
#import "HKSoftwareVC.h"
#import "HKTabBarModel.h"
#import "HKBookTabMainVC.h"
//#import "HKCommunityVC.h"
#import "HKStudyNewVC.h"



@interface TabBarControllerConfig()

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;
@property (nonatomic, strong) UIImage * itemImage;
@property (nonatomic, strong) UIImage * itemSelectedImage;
@end
@implementation TabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                                   tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                             imageInsets:IS_IPHONE_ProMax ? UIEdgeInsetsMake(-1 * Ratio, -1 * Ratio, -1 * Ratio, -1 * Ratio):UIEdgeInsetsZero
                                                                                 titlePositionAdjustment:UIOffsetZero];
        [self customizeTabBarAppearance:tabBarController];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

-(void)setTabModel:(HKTabBarModel *)tabModel{
    _tabModel = tabModel;
    self.itemImage =[self tabBarItemImageUrl:tabModel.icon_url];
    self.itemSelectedImage =[self tabBarItemImageUrl:tabModel.click_icon_url];
    self.tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                               tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                         imageInsets:IS_IPHONE_ProMax ? UIEdgeInsetsMake(-1 * Ratio, -1 * Ratio, -1 * Ratio, -1 * Ratio):UIEdgeInsetsZero
                                                             titlePositionAdjustment:UIOffsetZero];
    [self customizeTabBarAppearance:_tabBarController];
}

- (NSArray *)viewControllers {
        
    HomeVideoVC *homeVC = [HomeVideoVC new];
    HKNavigationController *homeNavigationController = [[HKNavigationController alloc] initWithRootViewController:homeVC];

    HKCategoryVC *learnedVC = [HKCategoryVC new];
    HKNavigationController *learnNavigationController = [[HKNavigationController alloc] initWithRootViewController:learnedVC];

    HKNavigationController *bookNavigationController = nil;
    if (self.itemImage && self.itemSelectedImage) {
        UIViewController * vc = [HKH5PushToNative runtimePush:self.tabModel.redirect_package.className arr:self.tabModel.redirect_package.list];
        bookNavigationController = [[HKNavigationController alloc] initWithRootViewController:vc];
    }else{
        HKSoftwareVC *VC = [HKSoftwareVC new];
        //HKBookTabMainVC * VC=  [HKBookTabMainVC new];
        bookNavigationController = [[HKNavigationController alloc] initWithRootViewController:VC];        
    }
    
    HKStudyNewVC *studyVC = [HKStudyNewVC new];
    HKNavigationController *collectionNavigationController = [[HKNavigationController alloc] initWithRootViewController:studyVC];
    
    MyInfoViewController *myInfoVC = [MyInfoViewController new];
    HKNavigationController *myInfoNavigationController = [[HKNavigationController alloc] initWithRootViewController:myInfoVC];
    
    
    NSArray *viewControllers = @[
                                 homeNavigationController,
                                 learnNavigationController,
                                 bookNavigationController,
                                 collectionNavigationController,
                                 myInfoNavigationController
                                 ];
    return viewControllers;
    
    
    /**
     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
     * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
     * 更推荐后一种做法。
     */
    //_tabBarController.imageInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    //_tabBarController.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
    
}


- (NSArray *)tabBarItemsAttributesForController {
    
//            NSArray *itemSelectedLightImage = @[@"house_yellow_select_dark",@"category_yellow_select_dark",@"ic_readingbook_selected_v2_18_dark",@"tab_study_select_dark",@"tab_me_select_dark"];
    BOOL isFouceLightModel = NO;
    if (@available(iOS 13.0, *)) {
        if (isFouceLight) {
            isFouceLightModel = YES;
        }
    }
    
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"house_gray",
                                                 CYLTabBarItemSelectedImage :
                                                     (isFouceLightModel ?@"house_yellow_select" :@"house_yellow_select_dark"),
                                                     //(isFouceLightModel ?@"house_yellow_select_dark" :@"house_yellow_select"),
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"分类",
                                                  CYLTabBarItemImage : @"category_gray",
                                                  CYLTabBarItemSelectedImage :
                                                      (isFouceLightModel ?@"category_yellow_select" : @"category_yellow_select_dark"),
//                                                      (isFouceLightModel ?@"category_yellow_select_dark" : @"category_yellow_select"),
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"学习",
                                                 CYLTabBarItemImage : @"tab_study",
                                                 CYLTabBarItemSelectedImage :
                                                     (isFouceLightModel ?@"tab_study_select" : @"tab_study_select_dark"),
                                                     //(isFouceLightModel ?@"tab_study_select_dark" : @"tab_study_select"),
                                                 };
    

    NSDictionary *fiveTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : @"我的",
                                                CYLTabBarItemImage : @"tab_me",
                                                CYLTabBarItemSelectedImage :
                                                    (isFouceLightModel ?@"tab_me_select" : @"tab_me_select_dark"),
                                                    //(isFouceLightModel ?@"tab_me_select_dark" : @"tab_me_select"),
                                                };
    
    NSDictionary *sixTabBarItemsAttributes = nil;
    if (self.itemSelectedImage && self.itemImage) {
        sixTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : self.tabModel.name,
                                                 CYLTabBarItemImage : self.itemImage,
                                                 CYLTabBarItemSelectedImage :self.itemSelectedImage,
                                                 };

    }else{
        sixTabBarItemsAttributes = @{
                                                   CYLTabBarItemTitle : @"软件入门",
                                                   CYLTabBarItemImage : @"ic_software_nor",
                                                   CYLTabBarItemSelectedImage :
                                                       (isFouceLightModel ?@"ic_software_sel" : @"ic_software_sel"),
                                                       //(isFouceLightModel ?@"ic_readingbook_selected_v2_18_dark" : @"ic_readingbook_selected_v2_18"),
                                                   };
    }

        
    NSArray *tabBarItemsAttributes = @[  firstTabBarItemsAttributes,
                                         secondTabBarItemsAttributes,
                                         sixTabBarItemsAttributes,
                                         thirdTabBarItemsAttributes,
                                         fiveTabBarItemsAttributes
                                         ];
    return tabBarItemsAttributes;
}



/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    //#warning CUSTOMIZE YOUR TABBAR APPEARANCE
    // Customize UITabBar height

    if (IS_IPHONE_ProMax) {
        // 自定义 TabBar 高度
        tabBarController.tabBarHeight = 83 * Ratio;

    }
    // set the text color for unselected state
    
    /***** v 2.17
     
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = COLOR_7B8196;//COLOR_666666;


    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = COLOR_27323F;//COLOR_ffd500;

    //字体大小
    //    NSMutableDictionary *fontAttrs = [NSMutableDictionary dictionary];
    //    fontAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];

    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    ******/
    
    // v2.18
    [[self class]tabBarItemTextColor:COLOR_7B8196 selectColor:COLOR_27323F_EFEFF6];
    
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    // [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:COLOR_FFFFFF_3D4752];
    
    UIImage *darkImage = [UIImage imageWithColor:COLOR_3D4752 size:CGSizeMake(SCREEN_WIDTH, 1)];
    UIImage *lightImage = [UIImage imageNamed:@"tapbar_top_line"];
    UIImage *shadowImage = lightImage;
    if (@available(iOS 13.0, *)) {
        DMUserInterfaceStyle mode = DMTraitCollection.currentTraitCollection.userInterfaceStyle;
        shadowImage = (mode == DMUserInterfaceStyleDark) ? darkImage :lightImage;
    }
    [[UITabBar appearance] setShadowImage:shadowImage];
    
    // set the bar background image
    // 设置背景图片
    // UITabBar *tabBarAppearance = [UITabBar appearance];
    // [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    // [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}



#pragma mark - tab 文字 颜色
+ (void)tabBarItemTextColor:(UIColor*)normalColor selectColor:(UIColor*)selectColor {
        
    if (@available(iOS 13.0, *)) {
        [[UITabBar appearance] setUnselectedItemTintColor:normalColor];
        [[UITabBar appearance] setTintColor:selectColor];
    }else{
        // 普通状态下的文字属性
        NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
        normalAttrs[NSForegroundColorAttributeName] = normalColor;
//        normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:27];
        
        // 选中状态下的文字属性
        NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
        selectedAttrs[NSForegroundColorAttributeName] = selectColor;
//        normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:27];
        // 设置文字属性
        UITabBarItem *tabBar = [UITabBarItem appearance];
        [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    }
    
    if (IS_IPHONE_ProMax) {
        // 普通状态下的文字属性
        NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
        normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11 * Ratio];
        
        // 选中状态下的文字属性
        NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
        normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11 * Ratio];
        // 设置文字属性
        UITabBarItem *tabBar = [UITabBarItem appearance];
        [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    }
}




//横竖屏相关

- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            SXPNSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait) {
            SXPNSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    UITabBarController *tabBarController = [self cyl_tabBarController] ?: [[UITabBarController alloc] init];
    //    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    CGFloat tabBarHeight = 40;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor redColor] size:selectionIndicatorImageSize]];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    
    HK_NOTIFICATION_REMOVE();
}


/**
网络图片存入沙盒并返回（针对tabBarIcon使用）

@param imageUrl 网络图片地址
@return 沙盒图片返回
*/
- (UIImage *)tabBarItemImageUrl:(NSString *)imageUrl{
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    NSString *name = [[imageName componentsSeparatedByString:@"."] firstObject];
    imageName = [NSString stringWithFormat:@"%@@2x.png",name];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    NSLog(@"%@",path);

    NSString *iconFilePath = [path stringByAppendingPathComponent:@"tabbarIcon"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [iconFilePath stringByAppendingPathComponent:imageName];

    // 判断文件是否已存在，存在直接读取
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        NSLog(@"存在了");
        return [UIImage imageWithContentsOfFile:fullPath];
    }
    //获取iconFilePath下文件个数
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:iconFilePath error:nil];
    //超过8个说明icon需要更换清除iconFilePath文件
    if (subPathArr.count >= 8) {
        [fileManager removeItemAtPath:iconFilePath error:nil];
    }
    //再从新创建iconFilePath文件
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:iconFilePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        // 在 Caches 目录下创建一个 tabbarIcon 目录
        [fileManager createDirectoryAtPath:iconFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *image = [UIImage imageWithData:data];
    // 将image写入沙河
    if ( [UIImagePNGRepresentation(image) writeToFile:fullPath atomically:YES]) {
        return [UIImage imageWithContentsOfFile:fullPath];
    }else{
        return nil;
    }
}

@end







