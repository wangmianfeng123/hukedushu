//
//  HKDesignListCell.m
//  Code
//
//  Created by Ivan li on 2020/12/14.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKDesignListCell.h"
#import "UIView+HKLayer.h"
#import "UILabel+Helper.h"

@interface HKDesignListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *tuwenLabel;
@property (weak, nonatomic) IBOutlet UIView *tuwenView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLabel;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *imgFatherView;

@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;
@end

@implementation HKDesignListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.contentView.backgroundColor = [UIColor lightGrayColor];
    [self.timeLabel addCornerRadius:3];
    [UILabel changeLineSpaceForLabel:self.titleLabel WithSpace:2 * Ratio];
    //[self.iconImgV addCornerRadius:6];
    [self addShadow:self.shadowView];
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.leftBottomLabel.textColor = COLOR_A8ABBE_7B8196;
    self.rightBottomLabel.textColor = COLOR_A8ABBE_7B8196;
    self.shadowView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.rightBottomLabel.font = [UIFont systemFontOfSize:11 * (IS_IPAD ? iPadHRatio : Ratio)];
    self.titleLabel.font = [UIFont systemFontOfSize:13 *(IS_IPAD ? iPadHRatio : Ratio)];
    self.leftBottomLabel.font = [UIFont systemFontOfSize:11 *(IS_IPAD ? iPadHRatio : Ratio)];
    self.imgFatherView.layer.cornerRadius = 5;
    self.imgFatherView.layer.masksToBounds = YES;
    self.imgFatherView.backgroundColor = COLOR_FFFFFF_3D4752;
}

- (void)addShadow:(UIView *)view{
    view.layer.cornerRadius = 6;
    view.layer.shadowOffset = CGSizeMake(0,0);
    view.layer.shadowColor = [UIColor colorWithHexString:@"#D2D6E4"].CGColor;
    view.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    view.layer.shadowRadius = 3;//阴影半径，默认3
    view.clipsToBounds = NO;
}


-(void)setModel:(VideoModel *)model{
    _model = model;
    NSString *url = model.img_cover_url.length? model.img_cover_url : model.img_cover_url_big;
    
    [self.iconImgV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:url]) placeholderImage:imageName(HK_Placeholder)];
    //self.iconImageView.courseCount = model.total_course;    
    
    // 图文
    self.tuwenLabel.hidden = !model.has_pictext;
    self.tuwenLabel.superview.hidden = !model.has_pictext;

    _titleLabel.text = [NSString stringWithFormat:@"%@",model.video_titel];
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",model.video_duration];
    
    _leftBottomLabel.text = model.difficulty;
    //_leftBottomLabel.hidden = NO;
    _rightBottomLabel.hidden = model.is_series ? NO : YES;
        
    //_categoryLabel.text = [NSString stringWithFormat:@"软件：%@",model.video_application];
}

@end
