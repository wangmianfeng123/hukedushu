//
//  YUFoldingSectionFooter.m
//  Code
//
//  Created by Ivan li on 2019/6/11.
//  Copyright © 2019 pg. All rights reserved.
//

#import "YUFoldingSectionFooter.h"

@interface YUFoldingSectionFooter()

@property (nonatomic,strong) UILabel *sepertorLine;

@end



@implementation YUFoldingSectionFooter

- (instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = tag;
        [self createUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
}



- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.sepertorLine];
    [self.sepertorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self);
        make.left.equalTo(self).offset(30);
        make.height.mas_equalTo(1);
    }];
}


- (UILabel *)sepertorLine {
    if (!_sepertorLine) {
        _sepertorLine = [[UILabel alloc]initWithFrame:CGRectZero];
        _sepertorLine.backgroundColor = [UIColor clearColor];
    }
    return _sepertorLine;
}

@end
