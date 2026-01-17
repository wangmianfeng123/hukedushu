//
//  HKStudyTagHeader.m
//  Code
//
//  Created by Ivan li on 2019/3/24.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKStudyTagHeader.h"
#import "HKDropMenuModel.h"

@implementation HKStudyTagHeader



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.title];
        [self addSubview:self.imageView];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self.imageView.mas_right).offset(7.5);
        }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.title);
            make.left.equalTo(self).offset(PADDING_15);
        }]; 
    }
    return self;
}




- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _title.textColor = COLOR_27323F_EFEFF6;
    }
    return _title;
}


- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = imageName(@"ic_interesting_v2_10");
    }
    return _imageView;
}



@end
