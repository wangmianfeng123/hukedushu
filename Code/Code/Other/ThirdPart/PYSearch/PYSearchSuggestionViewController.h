//
//  GitHub: https://github.com/iphone5solo/PYSearch
//  Created by CoderKo1o.
//  Copyright © 2016 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PYSearchSuggestionDidSelectCellBlock)(UITableViewCell *selectedCell);

@protocol PYSearchSuggestionViewDataSource <NSObject, UITableViewDataSource>

@required
- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section;
@optional
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView;
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PYSearchSuggestionViewController : UITableViewController

@property (nonatomic, weak) id<PYSearchSuggestionViewDataSource> dataSource;
@property (nonatomic, copy) NSArray<NSString *> *searchSuggestions;
@property (nonatomic, copy) PYSearchSuggestionDidSelectCellBlock didSelectCellBlock;
@property (nonatomic, copy) NSString *searchText;

+ (instancetype)searchSuggestionViewControllerWithDidSelectCellBlock:(PYSearchSuggestionDidSelectCellBlock)didSelectCellBlock;

@end



@interface HKSearchSuggestionCell : UITableViewCell

@property (nonatomic,strong) UILabel *suggestLB;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIImageView *iconIV;

@property (nonatomic,strong) UIButton *btn;

@property(nonatomic,copy)void(^searchSuggestionBlock)();

- (void)testValue:(NSString*)suggest targetStr:(NSString*)targetStr;

@end


