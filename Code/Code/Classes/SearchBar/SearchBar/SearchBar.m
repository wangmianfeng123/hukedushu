//
//  XCFSearchBar.m
//  XCFApp
//
//  Created by callmejoejoe on 16/4/2.
//  Copyright © 2016年 Joey. All rights reserved.
//
///

#import "SearchBar.h"
#import "UIView+SNFoundation.h"
#import "XBTextLoopView.h"

@interface SearchBar () <UISearchBarDelegate>
@property (nonatomic , strong) XBTextLoopView *loopView;

@end

@implementation SearchBar

+ (SearchBar *)searchBarWithPlaceholder:(NSString *)placeholder frame:(CGRect)frame {

    SearchBar *searchBar = [[SearchBar alloc]initWithFrame:frame];
//    if (@available(iOS 13.0, *)) {
//        searchBar.searchTextField.enabled = NO;
//    } else {
//        // Fallback on earlier versions
//    }
    searchBar.delegate = searchBar;
    searchBar.placeholder = @"";
    //光标颜色
    searchBar.tintColor = [UIColor hkdm_colorWithColorLight:COLOR_dddddd dark:COLOR_EFEFF6]; //COLOR_dddddd;
    // 替换放大镜
    //search_gray_dark
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"search_gray") darkImage:imageName(@"search_gray_dark")];
    [searchBar setImage:image forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    //修改placeholder字体的颜色和大小
//    if (@available(iOS 13.0, *)) {
//
//        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : COLOR_7B8196_A8ABBE,NSFontAttributeName :HK_FONT_SYSTEM(13)}];
//        searchBar.searchTextField.attributedPlaceholder = placeholderString;
//
//    }else{
//        UITextField *searchField = [searchBar valueForKey:@"_searchField"];
//        [searchField setValue:HK_FONT_SYSTEM(13) forKeyPath:@"_placeholderLabel.font"];
//        [searchField setValue:COLOR_7B8196_A8ABBE forKeyPath:@"_placeholderLabel.textColor"];
//    }

    if (@available(iOS 11.0, *)) {

    }else{
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    
    
    
    return searchBar;
}

//-(instancetype)initWithFrame:(CGRect)frame{
//    if ([super initWithFrame:frame]) {
//        XBTextLoopView *loopView = [XBTextLoopView textLoopViewWith:@[@"我是跑马灯跑马灯跑马灯跑马灯跑马灯😆1", @"我是跑马灯😆2", @"我是跑马灯😆3"] loopInterval:2.0 initWithFrame:CGRectMake(10, 5, frame.size.width - 10, frame.size.height - 10) selectBlock:^(NSString *selectString, NSInteger index) {
//            NSLog(@"%@===index%ld", selectString, index);
//        }];
//        self.loopView = loopView;
//        [self addSubview:loopView];
//    }
//    return self;
//}

- (void)setSearchBarBackgroundColor:(UIColor *)searchBarBackgroundColor {
    _searchBarBackgroundColor = searchBarBackgroundColor;
    
    if (@available(iOS 13.0, *)) {
        
        [self.searchTextField setBackgroundColor:searchBarBackgroundColor];
    }else{
        UITextField *searchField = [self valueForKey:@"_searchField"];
        searchField.backgroundColor = searchBarBackgroundColor;
        
    }
}

-(void)setHotWordArray:(NSMutableArray<NSString *> *)hotWordArray{
    _hotWordArray = hotWordArray;
    [self.loopView removeFromSuperview];
    if (hotWordArray.count) {
        WeakSelf
        XBTextLoopView *loopView = [XBTextLoopView textLoopViewWith:self.hotWordArray loopInterval:2.0 initWithFrame:CGRectMake(10, 5, self.frame.size.width - 10, self.frame.size.height - 10) selectBlock:^(NSString *selectString, NSInteger index) {
//            NSLog(@"%@===index%ld", selectString, index);
            if (weakSelf.didClickBlock) {
                weakSelf.didClickBlock(weakSelf,selectString);
            }
        }];
        self.loopView = loopView;
        [self.superview addSubview:loopView];
    }
}


- (void)setTextColor:(UIColor *)textColor {
     _textColor = textColor;
    
    if (@available(iOS 13.0, *)) {
        [self.searchTextField setValue:textColor forKeyPath:@"_placeholderLabel.textColor"];
    }else{
        UITextField *searchField = [self valueForKey:@"_searchField"];
        [searchField setValue:textColor forKeyPath:@"_placeholderLabel.textColor"];
    }
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    
    if (@available(iOS 13.0, *)) {
        [self.searchTextField setValue:textFont forKeyPath:@"_placeholderLabel.font"];
    }else{
        UITextField *searchField = [self valueForKey:@"_searchField"];
        [searchField setValue:textFont forKeyPath:@"_placeholderLabel.font"];
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subView in self.subviews[0].subviews) {

        if (@available(iOS 13.0, *)) {
            self.searchTextField.layer.masksToBounds = YES;
            self.searchTextField.layer.cornerRadius = 18;
            self.searchTextField.borderStyle = UITextBorderStyleNone;
            self.searchTextField.enabled = YES;
        }

        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subView removeFromSuperview];
        }

        if ([subView isKindOfClass:[UITextField class]]) {
            subView.layer.masksToBounds = YES;
            subView.layer.cornerRadius = 15;

            if (@available(iOS 11.0, *)) {
                CGFloat height = self.height;
                CGFloat width = self.width;
                UIEdgeInsets  _contentInset = UIEdgeInsetsMake(8, 5, 8, 0);
                subView.frame = CGRectMake(_contentInset.left, _contentInset.top, width - 2*_contentInset.left, height - 2 * _contentInset.top);
            }
        }
    }
    
    [self.superview bringSubviewToFront:self.loopView];
    
}



//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//
//    return NO;
//}
//
//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text API_AVAILABLE(ios(3.0)){
//    return NO;
//}
//
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
//    return NO;
//}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

    self.searchBarShouldBeginEditingBlock ? self.searchBarShouldBeginEditingBlock(searchBar) :nil;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    !self.searchBarTextDidChangedBlock ? nil : self.searchBarTextDidChangedBlock();
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    !self.searchBarDidSearchBlock ? nil : self.searchBarDidSearchBlock();
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    return self.loopView.tableView;
//}
@end


