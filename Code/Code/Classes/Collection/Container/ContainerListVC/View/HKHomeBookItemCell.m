//
//  HKHomeBookItemCell.m222
//  Code
//
//  Created by hanchuangkeji on 2019/7/16.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKHomeBookItemCell.h"

@interface HKHomeBookItemCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UIImageView *coverIV;

@property (weak, nonatomic) IBOutlet UIButton *freeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *listenIV;
@property (weak, nonatomic) IBOutlet UIImageView *shadowIV;

@end

@implementation HKHomeBookItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 圆角
    self.freeBtn.clipsToBounds = YES;
    self.freeBtn.layer.cornerRadius = 5.0;
    self.coverIV.clipsToBounds = YES;
    self.coverIV.layer.cornerRadius = 5.0;
    self.freeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.freeBtn.layer.borderWidth = 1.0;

    // 解决右下角和左下角 凸出的问题
    [self.coverIV addSubview:self.shadowIV];

}


- (void)setModel:(HKBookModel *)model {
    
    _model = model;
    self.titleLB.text = model.title;
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    
    self.freeBtn.hidden = !model.is_free;
    
}
@end
