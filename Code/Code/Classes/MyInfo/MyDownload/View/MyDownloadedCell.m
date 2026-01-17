//
//  MyDownloadedCell.m
//  Cod
//
//  Created by Ivan li on 2017/8/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "MyDownloadedCell.h"
#import "HKDownloadModel.h"
#import "HKAlbumShadowImageView.h"

@implementation MyDownloadedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setObserver];
    }
    return self;
}


- (void)createUI {
    
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.isStudyBtn];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.contentView insertSubview:self.bgImageView belowSubview:self.iconImageView];
    
    [self.iconImageView addSubview:self.blackView];
    [self.blackView addSubview:self.countLB];
    
    [self makeConstraints];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.sizeLabel.textColor =  COLOR_A8ABBE_7B8196;
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)updateEditAllConstraints {
    
    WeakSelf;
    [_selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(PADDING_10);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    
    [_bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView).offset(-9);
        make.right.left.bottom.equalTo(_iconImageView);
        //make.left.top.equalTo(_iconImageView).offset(-6);
        //make.right.bottom.equalTo(_iconImageView);
    }];
    
    [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(weakSelf.contentView).offset(PADDING_10);
        make.left.equalTo(weakSelf.selectBtn.mas_right).offset(PADDING_15);
        make.top.equalTo(weakSelf.contentView).offset(PADDING_15);
        make.bottom.equalTo(weakSelf.contentView).offset(-PADDING_15);
        //make.width.mas_equalTo(SCREEN_WIDTH/3+PADDING_20);
        make.width.mas_equalTo(IS_IPHONE6PLUS ?165:155);
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView).offset(5);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(12);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
    }];
    
    [_categoryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_15);
        make.right.left.equalTo(weakSelf.titleLabel);
    }];
    
    [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.iconImageView.mas_bottom).offset(-PADDING_5);
        make.right.left.equalTo(weakSelf.titleLabel);
    }];
    
    [_isStudyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel);
        make.bottom.equalTo(_timeLabel.mas_top).mas_offset(-6);
        make.size.mas_equalTo(CGSizeMake(42, 15));
    }];
    
    [_sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.timeLabel.mas_top).offset(-PADDING_5);
        make.right.left.equalTo(weakSelf.titleLabel);
    }];
}

- (void)updateNoEditAllConstraints {
    
    WeakSelf;
    [_selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(-PADDING_25);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    
    [_bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(_iconImageView).offset(-6);;
//        make.right.bottom.equalTo(_iconImageView);//.offset(6);
        
        make.top.equalTo(_iconImageView).offset(-9);
        make.right.left.bottom.equalTo(_iconImageView);
    }];
    
    
    [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(weakSelf.contentView).offset(PADDING_10);
        make.left.equalTo(weakSelf.selectBtn.mas_right).offset(PADDING_15);
        make.top.equalTo(weakSelf.contentView).offset(PADDING_15);
        make.bottom.equalTo(weakSelf.contentView).offset(-PADDING_15);
        //make.width.mas_equalTo(SCREEN_WIDTH/3+PADDING_20);
        make.width.mas_equalTo(IS_IPHONE6PLUS ?165:155);
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView).offset(5);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(12);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
    }];
    
    [_categoryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_15);
        make.right.left.equalTo(weakSelf.titleLabel);
    }];
    
    [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.iconImageView.mas_bottom).offset(-PADDING_5);
        make.right.left.equalTo(weakSelf.titleLabel);
    }];
    
    [_isStudyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel);
        make.bottom.equalTo(_timeLabel.mas_top).mas_offset(-6);
        make.size.mas_equalTo(CGSizeMake(42, 15));
    }];
    
    
    [_sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.timeLabel.mas_top).offset(-PADDING_5);
        make.right.left.equalTo(weakSelf.titleLabel);
    }];
    

}


- (void)updateConstraints {
    
    [super updateConstraints];
}

- (void)makeConstraints {
    
    WeakSelf;
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(-PADDING_25);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.top.equalTo(_iconImageView).offset(-6);
        //make.right.bottom.equalTo(_iconImageView);
        
        make.top.equalTo(_iconImageView).offset(-9);
        make.right.left.bottom.equalTo(_iconImageView);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(weakSelf.contentView).offset(PADDING_15);
        make.left.equalTo(weakSelf.selectBtn.mas_right).offset(PADDING_15);
        make.top.equalTo(weakSelf.contentView).offset(PADDING_15);
        make.bottom.equalTo(weakSelf.contentView).offset(-PADDING_15);
        //make.width.mas_equalTo(SCREEN_WIDTH/3+PADDING_20);
        make.width.mas_equalTo(IS_IPHONE6PLUS ?165:155);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView).offset(5);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(12);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_15);
        make.right.left.equalTo(weakSelf.titleLabel);
    }];
    
    [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.iconImageView.mas_bottom).offset(-PADDING_5);
        make.right.left.equalTo(weakSelf.titleLabel);
    }];
    
    [_isStudyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel);
        make.bottom.equalTo(_timeLabel.mas_top).mas_offset(-6);
        make.size.mas_equalTo(CGSizeMake(42, 15));
    }];
    
    [_sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.timeLabel.mas_top).offset(-PADDING_5);
        make.right.left.equalTo(weakSelf.titleLabel);
    }];
    
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(weakSelf.iconImageView);
        make.height.mas_equalTo(25.0);
    }];
    
    [_countLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_blackView);
        make.left.mas_equalTo(15.0);
    }];
}


- (UIImageView*)iconImageView {
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
//        _iconImageView.image = imageName(@"iconBg");
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 3.0;
    }
    return _iconImageView;
}


- (UIView *)blackView {
    if (_blackView == nil) {
        UIView *blackView = [[UIView alloc] init];
        _blackView = blackView;
        
        // 半透明的view
        UIView *myView = [[UIView alloc] init];
        myView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        [blackView addSubview:myView];
        [myView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.left.mas_equalTo(blackView);
        }];
    }
    return _blackView;
}

- (UILabel *)countLB {
    if (_countLB == nil) {
        _countLB = [[UILabel alloc] init];
        _countLB.font = [UIFont systemFontOfSize:14.0];
        _countLB.textColor = [UIColor whiteColor];
    }
    return _countLB;
}

- (HKAlbumShadowImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[HKAlbumShadowImageView alloc]init];
        //_bgImageView.offSet = 3;
        _bgImageView.offSet = 4.5;
        _bgImageView.hidden = YES;
    }
    return _bgImageView;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:HKColorFromHex(0x27323F, 1.0)];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 16:15 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}



- (UILabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [[UILabel alloc] init];
        [_categoryLabel setTextColor:COLOR_999999];
        _categoryLabel.textAlignment = NSTextAlignmentLeft;
        _categoryLabel.hidden = YES;
        _categoryLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
    }
    return _categoryLabel;
}


#pragma mark - 视频大小
- (UILabel*)sizeLabel {
    
    if (!_sizeLabel) {
        _sizeLabel  = [[UILabel alloc] init];
        [_sizeLabel setTextColor:COLOR_999999];
        _sizeLabel.textAlignment = NSTextAlignmentLeft;
        _sizeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
    }
    return _sizeLabel;
}



#pragma mark -时长
- (UILabel*)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel  = [[UILabel alloc] init];
        [_timeLabel setTextColor:HKColorFromHex(0xA8ABBE, 1.0)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}


- (UIButton*)selectBtn {
    
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.tag = 30;
        [_selectBtn setImage:imageName(@"cirlce_gray") forState:UIControlStateNormal];
        [_selectBtn setImage:imageName(@"right_green") forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIButton *)isStudyBtn {
    
    if (!_isStudyBtn) {
        _isStudyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_isStudyBtn setTitle:@"未观看" forState:UIControlStateNormal];
        [_isStudyBtn setTitleColor:HKColorFromHex(0xFF7820, 1.0) forState:UIControlStateNormal];
        _isStudyBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [_isStudyBtn setBackgroundColor:HKColorFromHex(0xFFF4E7, 1.0)];
        _isStudyBtn.clipsToBounds = YES;
        _isStudyBtn.layer.cornerRadius = 6.0;
    }
    return _isStudyBtn;
}




-(void)checkboxClick:(UIButton *)btn {
    
    //NSInteger tag = btn.tag;
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        _downloadModel.cellClickState = 1;
    }else{
        _downloadModel.cellClickState = 0;
    }
    self.selectBlock ? self.selectBlock(btn.selected) : nil;
}


#pragma mark - 编辑状态下 点击 cell 选中
- (void)clickAllRow:(BOOL)selected {
    
    if (selected == YES) {
        UIButton *btn = self.selectBtn;
        btn.selected = !btn.selected;
        if (btn.selected) {
            _downloadModel.cellClickState = 1;
        }else{
            _downloadModel.cellClickState = 0;
        }
        self.selectBlock ? self.selectBlock(btn.selected) : nil;
    }
}


- (void)setDownloadModel:(HKDownloadModel *)downloadModel {
    _downloadModel = downloadModel;
    // 非目录
    if (!downloadModel.isDirectory) {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:downloadModel.imageUrl]] placeholderImage:imageName(HK_Placeholder)];
        _titleLabel.text = [NSString stringWithFormat:@"%@",downloadModel.name];
        //_categoryLabel.text = [NSString stringWithFormat:@"软件:%@",downloadModel.category];
        //_sizeLabel.text = [NSString stringWithFormat:@"难度：%@",downloadModel.hardLevel];
        _timeLabel.text = [NSString stringWithFormat:@"视频时长：%@",downloadModel.videoDuration];
        _sizeLabel.hidden = NO;
    } else {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:downloadModel.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
        _titleLabel.text = [NSString stringWithFormat:@"%@",downloadModel.title];
        _sizeLabel.hidden = YES;
        _timeLabel.text = [NSString stringWithFormat:@"已下载%lu个", (unsigned long)downloadModel.children.count];
        self.countLB.text = [NSString stringWithFormat:@"共%lu节", (unsigned long)downloadModel.children.count];
    }
    //阴影图片
//    _bgImageView.hidden = !downloadModel.isDirectory;
    self.blackView.hidden = !downloadModel.isDirectory;
//    _iconImageView.layer.cornerRadius = downloadModel.isDirectory ?3 :0;
    // 判断选中状态
    if (_downloadModel.cellClickState == 1) {
        _selectBtn.selected = YES;
    } else {
        _selectBtn.selected = NO;
    }
    
    // 本地是否已经观看
    self.isStudyBtn.hidden = !downloadModel.needStudyLocal;
}


#pragma mark - 赋值 并设置 控件约束
- (void)setAllModel:(HKDownloadModel *)downloadModel isEdit:(BOOL)isEdit {
    
    [self setDownloadModel:downloadModel];
    if (isEdit){
        [self updateEditAllConstraints];
    }else{
        [self updateNoEditAllConstraints];
    }
}

#pragma mark - 网络改变通知通知
- (void)setObserver {
    
    [MyNotification addObserver:self
                       selector:@selector(editNotification:)
                           name:@"edit"
                         object:nil];
    
    [MyNotification addObserver:self
                       selector:@selector(allOrQuitSelect:)
                           name:@"allOrQuitSelect"
                         object:nil];
}


- (void)editNotification:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSInteger  status = [dict[@"edit"] integerValue];
    self.edit = status;
    if (status == 1) {
        [self updateEditAllConstraints];
    }else{
        [self updateNoEditAllConstraints];

    }
}


- (void)allOrQuitSelect:(NSNotification *)noti {
    
    if (_downloadModel.cellClickState == 1) {
        _selectBtn.selected = YES;
    } else {
        _selectBtn.selected = NO;
    }
}






@end

