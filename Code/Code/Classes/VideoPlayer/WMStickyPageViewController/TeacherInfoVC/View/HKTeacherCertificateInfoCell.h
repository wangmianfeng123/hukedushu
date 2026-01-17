//
//  HKTeacherCertificateInfoCell.h
//  Code
//
//  Created by ivan on 2020/8/28.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HKTeacherCertificateInfoView :UIView

@property (nonatomic, strong)UILabel *themeLB;

@property (nonatomic, strong)UIImageView *iconIV;

@property (nonatomic, copy) NSString *theme;

@end


@interface HKTeacherCertificateInfoCell : UITableViewCell

@property (nonatomic, strong)UIImageView *bgView;

@property (nonatomic, strong)UIView *smallBgView;

@property (nonatomic, strong)UILabel *leftLine;

@property (nonatomic, strong)UILabel *rightLine;

@property (nonatomic, strong)UILabel *themeLB;

@property (nonatomic, strong)UIImageView *leftIconIV;

@property (nonatomic, strong)UIImageView *rightIconIV;

@property (nonatomic, strong)UIImageView *arrowIconIV;

@property (nonatomic, strong)DetailModel *model;

@property (nonatomic, strong)NSMutableArray <HKTeacherCertificateInfoView*>* viewArr;

@end

NS_ASSUME_NONNULL_END
