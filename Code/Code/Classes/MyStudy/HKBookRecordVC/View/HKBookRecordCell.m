//
//  HKBookRecordCell.m
//  Code
//
//  Created by Ivan li on 2019/8/20.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookRecordCell.h"
#import "HKBookModel.h"
#import "HKCustomMarginLabel.h"

@interface HKBookRecordCell()

@property (strong, nonatomic)  UIImageView *coverIV;

@property (strong, nonatomic)  UIImageView *listenIV;

@property (strong, nonatomic)  UILabel *titleLB;

@property (strong, nonatomic)  HKCustomMarginLabel *descrLB;

@property (strong, nonatomic)  UILabel *timeLB;

@property (strong, nonatomic)  UIImageView *shadowIV;

@property(nonatomic,strong)UIView  *cellBgView;

@property(nonatomic,strong)UIButton  *selectBtn;

@end



@implementation HKBookRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        HK_NOTIFICATION_ADD(@"HKBookStudyRecordVC", updateCell:);
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.cellBgView];
    [self.cellBgView addSubview:self.selectBtn];

    [self.cellBgView addSubview:self.coverIV];
    [self.cellBgView addSubview:self.shadowIV];
    [self.cellBgView addSubview:self.listenIV];
    
    [self.cellBgView addSubview:self.titleLB];
    [self.cellBgView addSubview:self.descrLB];
    [self.cellBgView addSubview:self.timeLB];
    [self hkDarkModel];
}


- (UIView*)cellBgView {
    if (!_cellBgView) {
        _cellBgView = [UIView new];
    }
    return _cellBgView;
}


- (void)updateCell:(NSNotification*)noti {
    NSDictionary *dict = noti.userInfo;
    NSInteger  state = [dict[@"isEditing"] integerValue];
    self.isEdit = state;
    if (state) {
        [self updateEditAllConstraints];
    }else{
        [self updateNoEditAllConstraints];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isEdit) {
        [self updateEditAllConstraints];
    }else{
        [self makeConstraints];
    }
}

- (void)updateEditAllConstraints {
//    [self.cellBgView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(PADDING_30);
//    }];
    [self.cellBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(PADDING_30);
        make.right.top.bottom.equalTo(self);
    }];
    
    [_selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cellBgView.mas_centerY);
        make.left.equalTo(self.cellBgView.mas_left).offset(-PADDING_25);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    [self.coverIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.cellBgView).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(70, 105));
    }];
    
    [self.listenIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.coverIV).offset(-PADDING_5);
        make.bottom.equalTo(self.coverIV).offset(-PADDING_5);
    }];
    
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverIV);
        make.left.equalTo(self.coverIV.mas_right).offset(PADDING_10);
        make.right.equalTo(self.cellBgView).offset(-PADDING_15);
    }];
     
    [self.descrLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(5);
    }];
    
    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.coverIV);
        make.left.right.equalTo(self.descrLB);
    }];
    
    [self.shadowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.coverIV);
    }];
}

- (void)updateNoEditAllConstraints {
    [self.cellBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)makeConstraints {
    [self.cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cellBgView.mas_centerY);
        make.left.equalTo(self.cellBgView.mas_left).offset(-PADDING_25);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.cellBgView).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(70, 105));
    }];
    
    [self.listenIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.coverIV).offset(-PADDING_5);
        make.bottom.equalTo(self.coverIV).offset(-PADDING_5);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverIV);
        make.left.equalTo(self.coverIV.mas_right).offset(PADDING_10);
        make.right.equalTo(self.cellBgView).offset(-PADDING_15);
    }];
     
    [self.descrLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(5);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.coverIV);
        make.left.right.equalTo(self.descrLB);
    }];
    
    [self.shadowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.coverIV);
    }];
}

- (void)checkboxClick:(UIButton*)btn {
    self.model.isCellSelected = !self.model.isCellSelected;
    btn.selected = self.model.isCellSelected;
    self.bookCellBlock ?self.bookCellBlock(self.model) :nil;
}

/**编辑状态下 点击 cell 选中 */
- (void)editSelectRow {
    [self checkboxClick:self.selectBtn];
}


- (void)setModel:(HKBookModel *)model {
    _model = model;
    
    [self.coverIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.cover]) placeholderImage:HK_PlaceholderImage];
    self.titleLB.text = isEmpty(model.title)? @"" :model.title;
    
    self.descrLB.text = model.short_introduce;
    self.descrLB.hidden = isEmpty(model.short_introduce);
    //self.timeLB.text = [NSString stringWithFormat:@"时长 %@",isEmpty(model.time)? @"" :model.time];
    
    NSString *text = nil;
    if (!isEmpty(model.time)) {
        text = [NSString stringWithFormat:@"时长 %@",model.time];
    }
    if (!isEmpty(model.rate)) {
        NSString *rate = [NSString stringWithFormat:@"  %@",model.rate];
        if (isEmpty(text)) {
            text = rate;
        }else{
            text = [text stringByAppendingString:rate];
        }
    }
    self.timeLB.text = text;
    self.selectBtn.selected = self.model.isCellSelected;
}


- (void)hkDarkModel {
    self.titleLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_2C3949 dark:COLOR_EFEFF6];
    self.timeLB.textColor = COLOR_A8ABBE_7B8196;
    self.descrLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_7B8196 dark:COLOR_A8ABBE];
    self.descrLB.backgroundColor = COLOR_F8F9FA_333D48;
}

- (UIImageView*)coverIV {
    if (!_coverIV) {
        _coverIV = [UIImageView new];
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.clipsToBounds = YES;
        _coverIV.layer.cornerRadius = 5.0;
    }
    return _coverIV;
}


- (UIImageView*)listenIV {
    if (!_listenIV) {
        _listenIV = [UIImageView new];
        _listenIV.image = imageName(@"ic_video_v2_14");
    }
    return _listenIV;
}


- (UIImageView*)shadowIV {
    if (!_shadowIV) {
        _shadowIV = [UIImageView new];
        _shadowIV.image = imageName(@"hk_book_shadow_black");
    }
    return _shadowIV;
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_2C3949 titleFont:@"16" titleAligment:0];
        _titleLB.font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightMedium);
    }
    return _titleLB;
}


- (HKCustomMarginLabel*)descrLB {
    if (!_descrLB) {
        _descrLB = [HKCustomMarginLabel new];
        _descrLB.textColor = COLOR_7B8196;
        _descrLB.textAlignment = NSTextAlignmentLeft;
        _descrLB.font = HK_FONT_SYSTEM(13);
        _descrLB.backgroundColor = COLOR_F8F9FA;
        _descrLB.textInsets = UIEdgeInsetsMake(4,8, 4, 8);
        _descrLB.clipsToBounds = YES;
        _descrLB.layer.cornerRadius = 5;
        _descrLB.numberOfLines = 2;
    }
    return _descrLB;
}



- (UILabel*)timeLB {
    if (!_timeLB) {
        _timeLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:0];
    }
    return _timeLB;
}









- (UIButton*)selectBtn {
    
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:imageName(@"cirlce_gray") forState:UIControlStateNormal];
        [_selectBtn setImage:imageName(@"right_green") forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setEnlargeEdgeWithTop:PADDING_30 right:PADDING_30 bottom:PADDING_30 left:PADDING_5];
    }
    return _selectBtn;
}

@end
