//
//  XCFSearchBar.h
//  XCFApp
//
//  Created by callmejoejoe on 16/4/2.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBar : UISearchBar

/**  点击回调*/
@property (nonatomic, copy) void (^searchBarShouldBeginEditingBlock)(UISearchBar *searchBar);
/**  编辑回调 */
@property (nonatomic, copy) void (^searchBarTextDidChangedBlock)();
/**  编辑回调*/
@property (nonatomic, copy) void (^searchBarDidSearchBlock)();
@property (nonatomic , strong) void(^didClickBlock)(UISearchBar *searchBar,NSString * searchWord);


/**  搜索框背景色*/
@property (nonatomic, strong) UIColor *searchBarBackgroundColor;
/**  placeholder 字体色*/
@property (nonatomic, strong) UIColor *textColor;
/**  字体 size */
@property (nonatomic, strong) UIFont *textFont;


@property(nonatomic,strong)NSMutableArray<NSString*> *hotWordArray;


+ (SearchBar *)searchBarWithPlaceholder:(NSString *)placeholder frame:(CGRect)frame;


@end

