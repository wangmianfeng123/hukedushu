//
//  HKCollectionTagView.h
//  Code
//
//  Created by Ivan li on 2017/12/19.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKCollectionTagViewDelegate <NSObject>
@optional
- (void)collectionTagAction:(id)sender;
@end



@interface HKCollectionTagView : UIView

@property(nonatomic,weak)id <HKCollectionTagViewDelegate>delegate;

- (void)setTagBtnByTitle:(NSString*)title;

@end
