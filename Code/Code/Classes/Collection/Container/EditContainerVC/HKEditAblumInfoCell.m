//
//  HKEditAblumInfoCell.m
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKEditAblumInfoCell.h"

@implementation HKEditAblumInfoCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView{
    
    HKEditAblumInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKEditAblumInfoCell"];
    if (!cell) {
        cell = [[HKEditAblumInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKEditAblumInfoCell"];
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
    
//    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.placeholderTextView];
    [_placeholderTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(3);
    }];
}


- (UIImageView*)coverImageView {
    
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.image = imageName(HK_Placeholder);
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return  _coverImageView;
}



- (HKPlaceholderTextView*)placeholderTextView {
    if (!_placeholderTextView) {
        _placeholderTextView = [[HKPlaceholderTextView alloc]initWithMaxTextLenght:200 isShowLimitCount:YES];
        _placeholderTextView.textContainerInset = UIEdgeInsetsMake(15, 8, 10, 8);
        _placeholderTextView.placeholder = @"请输入专辑简介";
        _placeholderTextView.textColor = COLOR_27323F_EFEFF6;
        _placeholderTextView.delegate = self;
        [_placeholderTextView setFont:HK_FONT_SYSTEM(14)];
        
        _placeholderTextView.keyboardType = UIKeyboardTypeDefault;
        _placeholderTextView.returnKeyType = UIReturnKeyDone;
        WeakSelf;
        [_placeholderTextView addTextViewEndEvent:^(HKPlaceholderTextView *text) {
            
            if ([weakSelf.delegate respondsToSelector:@selector(albumInfo:)]) {
                [weakSelf.delegate albumInfo:text.text];
            }
        }];
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_38434E];
        _placeholderTextView.backgroundColor = bgColor;
    }
    return _placeholderTextView;
}



#pragma mark    HKPlaceholderTextView   delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)setIntroduceText:(NSString *)introduceText {
    
    _introduceText = introduceText;
    _placeholderTextView.text = introduceText;
}

@end







