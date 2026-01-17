//
//  DesignTableVC.h
//  Code
//
//  Created by Ivan li on 2017/8/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class HKDropMenu,HKDropMenuModel,DesignTableChlidrenVC,HKFiltrateModel;


@protocol DesignTableChlidrenVCDelegate <NSObject>

- (void)designTableChlidren:(DesignTableChlidrenVC*_Nullable)vc jobArr:(NSMutableArray*_Nullable)jobArr  videoArr:(NSMutableArray*_Nullable)videoArr  c4dArr:(NSMutableArray*_Nonnull)c4dArr title:(NSString*_Nonnull)title;

@end


@interface DesignTableChlidrenVC : HKBaseVC

- (instancetype _Nullable )initWithNibName:(NSString *_Nullable)nibNameOrNil
                                    bundle:(NSBundle *_Nullable)nibBundleOrNil
                                  category:(NSString*_Nonnull)category
                                      name:(NSString*_Nonnull)name;


@property(nonatomic,weak) id <DesignTableChlidrenVCDelegate> _Nullable delegate;

@property(nonatomic,copy)void (^ _Nullable videoCountCallBack) (NSInteger videoCount);

/**  默认选中筛选tag */
@property(nonatomic,copy)NSString * _Nullable defaultSelectedTag;

- (void)dropMenu:(HKDropMenu *_Nullable)dropMenu dropMenuTitleModel:(HKDropMenuModel *_Nullable)dropMenuTitleModel;

- (void)dropMenu:(HKDropMenu *_Nullable)dropMenu tagArray:(nullable NSArray<HKDropMenuModel *> *)tagArray;
/** 重置筛选 */
- (void)dropMenu:(HKDropMenu *_Nullable)dropMenu reset:(BOOL)reset;

- (void)dropMenu:(HKDropMenu *_Nullable)dropMenu withParam:(HKFiltrateModel *)model;

#pragma mark - 刷新
- (void)refreshUI;

@end
