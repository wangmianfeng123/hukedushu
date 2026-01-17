//
//  HKDetailAlbumView.m
//  Code
//
//  Created by Ivan li on 2021/5/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKDetailAlbumView.h"
#import "CategoryModel.h"
#import "UIView+HKLayer.h"

@interface HKDetailAlbumView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maxWidth;

@end

@implementation HKDetailAlbumView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.contentView.backgroundColor = COLOR_FFF0E6;
    self.titleLabel.textColor = COLOR_FF7820;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
    
    [self.contentView addCornerRadius:5];
}

-(void)setDetaiModel:(DetailModel *)detaiModel{
    _detaiModel = detaiModel;

    if (detaiModel.album) {
        self.titleLabel.text = detaiModel.album.name;
        self.collectLabel.hidden = NO;
        self.maxWidth.constant = 175;
    }else{
        if (detaiModel.is_series) {
            self.titleLabel.text = @"超职套课当前仅支持PC端购买";
            self.iconImg.image = [UIImage imageNamed:@"ic_pc_series_2_34"];
            self.rightBtn.text = @"点击复制链接";
            self.collectLabel.hidden = YES;
            self.maxWidth.constant = 250;
        }
    }
    
}

- (void)tapClick{
    if (self.detaiModel.is_series && (self.detaiModel.is_buy_series == NO)) {
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        pab.string = self.detaiModel.series_url;
        if (pab.string.length) {
            showTipDialog(@"链接已复制，请在电脑浏览器打开");
            [MobClick event: detailpage_taoke_copylink];
            return;
        }
    }
    if (self.didTapBlock) {
        [MobClick event: detailpage_album_click];
        self.didTapBlock(self.detaiModel);
    }
}

@end
