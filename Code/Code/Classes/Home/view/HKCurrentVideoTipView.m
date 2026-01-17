//
//  HKCurrentVideoTipView.m
//  Code
//
//  Created by hanchuangkeji on 2018/5/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCurrentVideoTipView.h"


@interface HKCurrentVideoTipView()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation HKCurrentVideoTipView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn.userInteractionEnabled = NO;
    [self.btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -110)];
    [self.btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    //
}

- (void)setModel:(VideoModel *)model {
    _model = model;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
    self.nameLB.text = model.title.length? model.title : model.name;
}


//- (void)dealloc {
////    NSLog(@"%s", __func__);
//}
@end
