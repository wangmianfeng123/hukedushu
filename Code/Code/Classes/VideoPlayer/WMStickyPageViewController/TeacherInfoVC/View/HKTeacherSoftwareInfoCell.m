//
//  HKTeacherSoftwareInfoCell.m
//  Code
//
//  Created by Ivan li on 2018/4/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTeacherSoftwareInfoCell.h"


@interface HKTeacherSoftwareInfoCell()
/**  简介  */
@property (strong, nonatomic)  UILabel *courseDesContentLB;
/**  简介 详情  */
@property (strong, nonatomic)  UILabel *courseDetailLB;
/**  能学到的内容  */
@property (strong, nonatomic)  UILabel *applicationLB;
/**  能学到的内容 详情 */
@property (strong, nonatomic)  UILabel *applicationDetailLB;
/**  底部横线 */
@property (strong, nonatomic)  UIView  *headLineView;

@end

@implementation HKTeacherSoftwareInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView {
    
    HKTeacherSoftwareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKTeacherSoftwareInfoCell"];
    if (!cell) {
        cell = [[HKTeacherSoftwareInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKTeacherSoftwareInfoCell"];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}



- (void)createUI {
    
    [self.contentView addSubview:self.headLineView];
    [self.contentView addSubview:self.courseDesContentLB];
    [self.contentView addSubview:self.courseDetailLB];
    
    [self.contentView addSubview:self.applicationLB];
    [self.contentView addSubview:self.applicationDetailLB];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.headLineView.backgroundColor = COLOR_F8F9FA_333D48;
    self.courseDesContentLB.textColor = COLOR_27323F_EFEFF6;
    self.courseDetailLB.textColor = COLOR_7B8196_A8ABBE;
    self.applicationLB.textColor = COLOR_27323F_EFEFF6;
    self.applicationDetailLB.textColor = COLOR_7B8196_A8ABBE;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    [self.courseDesContentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(PADDING_15);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        //make.height.mas_equalTo(15);
    }];
    
    [self.courseDetailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.courseDesContentLB.mas_bottom).offset(PADDING_15);
        make.left.equalTo(self.courseDesContentLB);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
    
    [self.applicationLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.lessThanOrEqualTo(self.courseDetailLB.mas_bottom).offset(PADDING_15);
        make.left.equalTo(self.courseDesContentLB);
    }];
    
    [self.applicationDetailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.applicationLB.mas_bottom).offset(PADDING_15);
        make.left.equalTo(self.courseDesContentLB);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
}


- (UILabel*)courseDesContentLB {
    
    if (!_courseDesContentLB) {
        _courseDesContentLB = [UILabel labelWithTitle:CGRectZero title:@"教程介绍" titleColor:COLOR_27323F titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _courseDesContentLB;
}


- (UILabel*)courseDetailLB {
    
    if (!_courseDetailLB) {
        _courseDetailLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _courseDetailLB.numberOfLines = 0;
    }
    return _courseDetailLB;
}


- (UILabel*)applicationLB {
    
    if (!_applicationLB) {
        _applicationLB = [UILabel labelWithTitle:CGRectZero title:@"你能学到什么？" titleColor:COLOR_27323F titleFont:nil titleAligment:NSTextAlignmentLeft];
        _applicationLB.font = HK_FONT_SYSTEM(15);
    }
    return _applicationLB;
}


- (UILabel*)applicationDetailLB {
    
    if (!_applicationDetailLB) {
        _applicationDetailLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _applicationDetailLB.numberOfLines = 0;
    }
    return _applicationDetailLB;
}


- (UIView*)headLineView {
    if (!_headLineView) {
        _headLineView = [UIView new];
        _headLineView.backgroundColor = COLOR_F8F9FA;
    }
    return _headLineView;
}


- (void)setVideoDetailModel:(DetailModel *)videoDetailModel {
    _videoDetailModel = videoDetailModel;
    
    NSInteger count = videoDetailModel.obtain_info.app_obtain.count;
    if (count) {
        _headLineView.hidden = (count >1);
    }
    
    HKCourseModel *courseModel = videoDetailModel.lessons_data;
    self.courseDesContentLB.text = courseModel.summary;
    

    if (videoDetailModel.software_info.count == 1) {
        _courseDesContentLB.text = videoDetailModel.software_info[0].name;
        NSString *str = videoDetailModel.software_info[0].info;
        _courseDetailLB.attributedText = [NSMutableAttributedString changeLineSpaceWithTotalString:str LineSpace:7.5];
        
    }else if (videoDetailModel.software_info.count>1) {
        
        _courseDesContentLB.text = videoDetailModel.software_info[0].name;
        NSString *str = videoDetailModel.software_info[0].info;
        _courseDetailLB.attributedText = [NSMutableAttributedString changeLineSpaceWithTotalString:str LineSpace:7.5];
        
        _applicationLB.text = videoDetailModel.software_info[1].name;
        NSString *str1 = videoDetailModel.software_info[1].info;
        _applicationDetailLB.attributedText = [NSMutableAttributedString changeLineSpaceWithTotalString:str1 LineSpace:7.5];
    }
}



- (CGSize)sizeThatFits:(CGSize)size {
    
    CGFloat totalHeight = 95;
    totalHeight += [self.courseDesContentLB sizeThatFits:CGSizeMake(size.width - 15, 0)].height;
    totalHeight += [self.courseDetailLB sizeThatFits:CGSizeMake(size.width - 15 * 2, 0)].height;
    
    totalHeight += [self.applicationLB sizeThatFits:CGSizeMake(size.width - 15, 0)].height;
    totalHeight += [self.applicationDetailLB sizeThatFits:CGSizeMake(size.width - 15 * 2, 0)].height;
    return CGSizeMake(size.width, totalHeight);
}

@end
