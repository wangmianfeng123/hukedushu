//
//  HKAttentionTopCell.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKAttentionTopCell.h"


@interface HKAttentionTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end

@implementation HKAttentionTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.descLabel.textColor = COLOR_7B8196_A8ABBE;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;

    self.imgV.image = [UIImage hkdm_imageWithNameLight:@"img_follow_none_2_31" darkImageName:@"img_follow_none_dark_2_31"];
    
//    if (!isLogin()) {
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didLogin)];
//        [self addGestureRecognizer:tap];
//    }
}

//- (void)didLogin{
//    if (self.didLoginBlock) {
//        self.didLoginBlock();
//    }
//}

-(void)setDataCount:(int)dataCount{
    _dataCount = dataCount;
    if (isLogin()) {
        if (_dataCount == 0) {
            self.titleLabel.text = @"你还没有关注任何人";
            self.descLabel.text = @"以下是为你推荐的优质虎课er";
        }else{
            self.titleLabel.text = @"你关注的人最近不太活跃哦";
            self.descLabel.text = @"以下是为你推荐的优质虎课er";
        }
    }else{
        self.titleLabel.text = @"登录查看关注的动态";
        self.descLabel.text = @"以下是为你推荐的优质虎课er";
    }
}

@end
