//
//  HKMusicDescrCell.h
//  Code
//
//  Created by Ivan li on 2019/7/16.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HtmlHeightBlock)(float height);

NS_ASSUME_NONNULL_BEGIN

@class HKBookModel;

@interface HKListeningDescrCell : UICollectionViewCell

@property(nonatomic, copy)HtmlHeightBlock htmlHeightBlock;

@property(nonatomic, strong)HKBookModel *model;

- (void)removeBriderHandler;

@end

NS_ASSUME_NONNULL_END

