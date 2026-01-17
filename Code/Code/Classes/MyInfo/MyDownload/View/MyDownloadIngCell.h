//
//  MyDownloadIngCell.h
//  Code
//
//  Created by Ivan li on 2017/8/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDownloadIngCell : UITableViewCell

//@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UIImageView *fLAnimatedImageView;
@property(nonatomic,strong)UILabel *countLabel;

- (void)setCount:(NSInteger)count;

- (void)setGifImage;

@end
