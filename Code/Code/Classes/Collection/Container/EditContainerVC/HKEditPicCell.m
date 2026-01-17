
//
//  HKEditPicCell.m
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKEditPicCell.h"
#import "HKCategoryAlbumModel.h"

@implementation HKEditPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView{
    
    HKEditPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKEditPicCell"];
    if (!cell) {
        cell = [[HKEditPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKEditPicCell"];
    } 
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.textLabel.text = @"更换封面";
    [self.textLabel setTextColor:COLOR_27323F_EFEFF6];
    [self.textLabel setFont:HK_FONT_SYSTEM(PADDING_15)];
    
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.rightIV];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.rightIV.mas_left).offset(-PADDING_15);
        make.size.mas_equalTo(CGSizeMake(200/2, 60));
    }];
    
    [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
}


- (UIImageView*)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        //_coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = PADDING_5;
    }
    return  _coverImageView;
}


- (UIImageView*)rightIV {
    if (!_rightIV) {
        _rightIV = [UIImageView new];
        _rightIV.contentMode = UIViewContentModeScaleAspectFit;
        _rightIV.image = imageName(@"arrow_right_gray");
    }
    return  _rightIV;
}


- (void)setImage:(UIImage *)image {
    _image = image;
    _coverImageView.image = image;
}


- (void)setModel:(HKCategoryAlbumModel *)model {
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
}




@end
