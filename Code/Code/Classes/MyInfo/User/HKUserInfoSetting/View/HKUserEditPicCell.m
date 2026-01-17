//
//  HKUserEditPicCell.m
//  Code
//
//  Created by Ivan li on 2018/3/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUserEditPicCell.h"


@implementation HKUserEditPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView{
    
    HKUserEditPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKEditPicCell"];
    if (!cell) {
        cell = [[HKUserEditPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKEditPicCell"];
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
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageName(@"arrow_right_gray")];
    self.accessoryView = imageView;
    
    [self.contentView addSubview:self.setLabel];
    [self.contentView addSubview:self.coverImageView];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(144/2, 144/2));
    }];
    
    [_setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(_coverImageView.mas_right).offset(PADDING_10);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = COLOR_FFFFFF_3D4752;
}



- (UILabel*)setLabel {
    if (!_setLabel) {
        _setLabel = [UILabel labelWithTitle:CGRectZero title:@"设置头像" titleColor:COLOR_27323F_EFEFF6 titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _setLabel;
}


- (UIImageView*)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = 144/4;
    }
    return  _coverImageView;
}


- (void)setImageData:(NSData *)imageData{
    _imageData = imageData;
    if (nil == imageData) {
        NSString *url = [HKAccountTool shareAccount].avator;
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:url]] placeholderImage:imageName(HK_Placeholder)];
    }else{
        _coverImageView.image = [UIImage imageWithData:imageData];
    }
}




@end
