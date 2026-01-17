//
//  GitHub: https://github.com/iphone5solo/PYSearch
//  Created by CoderKo1o.
//  Copyright © 2016 iphone5solo. All rights reserved.
//

#import "PYSearchSuggestionViewController.h"
#import "PYSearchConst.h"
// HK add 0201
#import <TBScrollViewEmpty/TBScrollViewEmpty.h>
#import "UIColor+PYSearchExtension.h"
#import "Masonry.h"

@interface PYSearchSuggestionViewController ()<TBSrollViewEmptyDelegate>

@property (nonatomic, assign) UIEdgeInsets originalContentInsetWhenKeyboardShow;
@property (nonatomic, assign) UIEdgeInsets originalContentInsetWhenKeyboardHidden;

@property (nonatomic, assign) BOOL keyboardDidShow;

@end

@implementation PYSearchSuggestionViewController


// HK add 0201 隐藏空视图 提示
- (BOOL)tb_showEmptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return YES;
}



+ (instancetype)searchSuggestionViewControllerWithDidSelectCellBlock:(PYSearchSuggestionDidSelectCellBlock)didSelectCellBlock
{
    PYSearchSuggestionViewController *searchSuggestionVC = [[PYSearchSuggestionViewController alloc] init];
    searchSuggestionVC.didSelectCellBlock = didSelectCellBlock;
    searchSuggestionVC.automaticallyAdjustsScrollViewInsets = NO;
    return searchSuggestionVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) { // For the adapter iPad
        if (@available(iOS 9.0, *)) {
            self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
        } else {
            // Fallback on earlier versions
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradFrameDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradFrameDidHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.keyboardDidShow) {
        self.originalContentInsetWhenKeyboardShow = self.tableView.contentInset;
    } else {
        self.originalContentInsetWhenKeyboardHidden = self.tableView.contentInset;
    }
}

- (void)keyboradFrameDidShow:(NSNotification *)notification
{
    self.keyboardDidShow = YES;
    [self setSearchSuggestions:_searchSuggestions];
}

- (void)keyboradFrameDidHidden:(NSNotification *)notification
{
    self.keyboardDidShow = NO;
    self.originalContentInsetWhenKeyboardHidden = UIEdgeInsetsMake(-30, 0, 30, 0);
    [self setSearchSuggestions:_searchSuggestions];
}

#pragma mark - setter
- (void)setSearchSuggestions:(NSArray<NSString *> *)searchSuggestions
{
    _searchSuggestions = [searchSuggestions copy];
    
    [self.tableView reloadData];
    
    /**
     * Adjust the searchSugesstionView when the keyboard changes.
     * more information can see : https://github.com/iphone5solo/PYSearch/issues/61
     */
    if (self.keyboardDidShow && !UIEdgeInsetsEqualToEdgeInsets(self.originalContentInsetWhenKeyboardShow, UIEdgeInsetsZero) && !UIEdgeInsetsEqualToEdgeInsets(self.originalContentInsetWhenKeyboardShow, UIEdgeInsetsMake(-30, 0, 30 - CGRectGetMaxY(self.navigationController.navigationBar.frame), 0))) {
        self.tableView.contentInset =  self.originalContentInsetWhenKeyboardShow;
    } else if (!self.keyboardDidShow && !UIEdgeInsetsEqualToEdgeInsets(self.originalContentInsetWhenKeyboardHidden, UIEdgeInsetsZero) && !UIEdgeInsetsEqualToEdgeInsets(self.originalContentInsetWhenKeyboardHidden, UIEdgeInsetsMake(-30, 0, 30 - CGRectGetMaxY(self.navigationController.navigationBar.frame), 0))) {
        self.tableView.contentInset =  self.originalContentInsetWhenKeyboardHidden;
    }
    self.tableView.contentOffset = CGPointMake(0, -self.tableView.contentInset.top);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) { // iOS 11
        self.tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
    }
    UIColor *bgColor = [UIColor pydm_colorWithColorLight:[UIColor whiteColor] dark:[UIColor py_colorWithHexString:@"#3D4752"]];
    //UIColor *bgColor = [UIColor pydm_colorWithColorLight:[UIColor whiteColor] dark:[UIColor py_colorWithHexString:@"#333D48"]];
    self.tableView.backgroundColor = bgColor;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInSearchSuggestionView:)]) {
        return [self.dataSource numberOfSectionsInSearchSuggestionView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:numberOfRowsInSection:)]) {
        return [self.dataSource searchSuggestionView:tableView numberOfRowsInSection:section];
    }
    return self.searchSuggestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:cellForRowAtIndexPath:)]) {
        UITableViewCell *cell= [self.dataSource searchSuggestionView:tableView cellForRowAtIndexPath:indexPath];
        if (cell) return cell;
    }
    
    
    HKSearchSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSearchSuggestionCell class])];
    if (!cell) {
        cell = [[HKSearchSuggestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HKSearchSuggestionCell class])];
    }
    if (self.searchSuggestions.count) {
        NSString *title = self.searchSuggestions[indexPath.row];
        [cell testValue:title targetStr:self.searchText];
    }
    return cell;
    
//    static NSString *cellID = @"PYSearchSuggestionCellID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        cell.textLabel.textColor = [UIColor darkGrayColor];
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.backgroundColor = [UIColor clearColor];
//        UIImageView *line = [[UIImageView alloc] initWithImage: [NSBundle py_imageNamed:@"cell-content-line"]];
//        line.py_height = 0.5;
//        line.alpha = 0.7;
//        line.py_x = PYSEARCH_MARGIN;
//        line.py_y = 43;
//        line.py_width = PYScreenW;
//        [cell.contentView addSubview:line];
//    }
//    cell.imageView.image = [NSBundle py_imageNamed:@"search"];
//    cell.textLabel.text = self.searchSuggestions[indexPath.row];
//    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:heightForRowAtIndexPath:)]) {
        return [self.dataSource searchSuggestionView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 44.0;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.didSelectCellBlock) self.didSelectCellBlock([tableView cellForRowAtIndexPath:indexPath]);
}

@end







@implementation HKSearchSuggestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    UIColor *bgColor = [UIColor pydm_colorWithColorLight:[UIColor whiteColor] dark:[UIColor py_colorWithHexString:@"#3D4752"]];
    //UIColor *bgColor = [UIColor pydm_colorWithColorLight:[UIColor whiteColor] dark:[UIColor py_colorWithHexString:@"#333D48"]];
    self.contentView.backgroundColor = bgColor;
    [self.contentView addSubview:self.suggestLB];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.iconIV];
    [self makeConstraints];
}




- (void)makeConstraints {
    [self.suggestLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.left.equalTo(self.suggestLB);
        make.height.mas_equalTo(1);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    

}



- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_goto_v2_18"]];
    }
    return _iconIV;
}

- (UILabel*)suggestLB {
    if (!_suggestLB) {
        _suggestLB = [UILabel new];
        _suggestLB.font = [UIFont systemFontOfSize:14];
        UIColor *textColor = [UIColor pydm_colorWithColorLight:[UIColor py_colorWithHexString:@"#7B8196"] dark:[UIColor py_colorWithHexString:@"#A8ABBE"]];
        _suggestLB.textColor = textColor;
    }
    return _suggestLB;
}


- (UIView*)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        UIColor *bgColor = [UIColor pydm_colorWithColorLight:[UIColor py_colorWithHexString:@"#F8F9FA"] dark:[UIColor py_colorWithHexString:@"#333D48"]];
        _lineView.backgroundColor = bgColor;
        _lineView.hidden = YES;
    }
    return _lineView;
}




- (void)testValue:(NSString*)suggest targetStr:(NSString*)targetStr {
    
    UIColor *textColor = [UIColor pydm_colorWithColorLight:[UIColor py_colorWithHexString:@"#27323F"] dark:[UIColor py_colorWithHexString:@"#EFEFF6"]];
    NSMutableAttributedString *attributed = [[self class] changeCorlorWithColor: textColor
                                                                                 TotalString:suggest
                                                                 SubStringArray:(targetStr.length) ?@[targetStr] :nil];
    self.suggestLB.attributedText = attributed;
}


+ (NSMutableAttributedString *) changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (NSString *rangeStr in subArray) {
        
        NSMutableArray *array = [self  getRangeWithTotalString:totalStr SubString:rangeStr];
        
        for (NSNumber *rangeNum in array) {
            
            NSRange range = [rangeNum rangeValue];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
            if (@available(iOS 8.2, *)) {
                [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold] range:range];
            }
        }
    }
    return attributedStr;
}


/**
 *  获取某个字符串中子字符串的位置数组
 *
 *  @param totalString 总的字符串
 *  @param subString   子字符串
 *
 *  @return 位置数组
 */
+ (NSMutableArray *) getRangeWithTotalString:(NSString *)totalString SubString:(NSString *)subString {
    
    NSMutableArray *arrayRanges = [NSMutableArray array];
    
    if (subString == nil && [subString isEqualToString:@""]) {
        return nil;
    }
    
    NSRange rang = [totalString rangeOfString:subString];
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber valueWithRange:rang]];
        
        NSRange      rang1 = {0,0};
        NSInteger location = 0;
        NSInteger   length = 0;
        
        for (int i = 0;; i++) {
            
            if (0 == i) {
                
                location = rang.location + rang.length;
                length = totalString.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                
                location = rang1.location + rang1.length;
                length = totalString.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            
            rang1 = [totalString rangeOfString:subString options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
            } else {
                
                [arrayRanges addObject:[NSNumber valueWithRange:rang1]];
            }
        }
        return arrayRanges;
    }
    return nil;
}


@end



