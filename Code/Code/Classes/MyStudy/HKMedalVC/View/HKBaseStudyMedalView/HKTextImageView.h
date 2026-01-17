//
//  HKTextImageView.h
//  Code
//
//  Created by Ivan li on 2018/12/9.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKTextImageView : UIView

@property (nonatomic,strong) UILabel *textLB;

@property (nonatomic,strong) UIImageView *iconIV;

@property (nonatomic,strong) UILabel *desLB;

@property (nonatomic,copy) NSString *text;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *des;

- (void)setText:(NSString *)text url:(NSString*)url;

- (void)setText:(NSString *)text url:(NSString*)url des:(NSString *)des;

@end
