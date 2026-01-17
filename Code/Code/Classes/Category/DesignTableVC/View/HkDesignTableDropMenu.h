//
//  HKCategoryReusableView.h
//  Code
//
//  Created by Ivan li on 2019/7/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HkDesignTableDropMenu,HKDropMenuModel,HKDropMenu,HKFiltrateModel;

@protocol HkDesignTableDropMenuDelegate <NSObject>

- (void)categoryReusableView:(HkDesignTableDropMenu*)categoryReusableView
                    dropMenu:(HKDropMenu *)dropMenu
                selectIndex:(NSInteger)selectIndex
          dropMenuTitleModel:(HKDropMenuModel *)dropMenuTitleModel;

- (void)categoryReusableView:(HkDesignTableDropMenu*)categoryReusableView
                    dropMenu:(HKDropMenu *)dropMenu tagArray:(nullable NSArray<HKDropMenuModel *> *)tagArray;

- (void)categoryReusableView:(HkDesignTableDropMenu*)categoryReusableView
                    dropMenu: (HKDropMenu *)dropMenu reset:(BOOL)reset;

- (void)categoryReusableView:(HkDesignTableDropMenu*)categoryReusableView
                    dropMenu:(HKDropMenu *)dropMenu itemIndex:(NSInteger)itemIndex;

- (void)categoryReusableView:(HkDesignTableDropMenu*)categoryReusableView
                    dropMenu:(HKDropMenu *)dropMenu withParam:(HKFiltrateModel *)dic;

@end


@interface HkDesignTableDropMenu : UICollectionReusableView

@property(nonatomic,weak)id <HkDesignTableDropMenuDelegate> delegate;

@property(nonatomic,strong) HKDropMenu *dropMenu;

@property(nonatomic,assign) NSInteger videoCount;

@property(nonatomic,copy) NSString *defaultTag;

@property(nonatomic,copy) NSString *categoryId;

- (void)resetMenuStatus;

- (void)createUI;

@end

NS_ASSUME_NONNULL_END


