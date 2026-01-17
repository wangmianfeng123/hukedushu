//
//  HKStudyCertificateDetailVC.m
//  Code
//
//  Created by Ivan li on 2018/4/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyCertificateDetailVC.h"
#import "HKLineLabel.h"
#import <YYText/YYText.h>
#import "StudyCertificateModel.h"
#import "UINavigationBar+Awesome.h"
#import "UIBarButtonItem+Extension.h"
#import "UMpopView.h"




@interface HKStudyCertificateDetailVC ()<UMpopViewDelegate>

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *headImageView;

@property (nonatomic,strong) UIImageView *footImageView;

@property (nonatomic,strong) HKLineLabel *nameLabel;

@property (nonatomic,strong) UILabel *congrationLabel;

@property (nonatomic,strong) UILabel *congrationWordLabel;

@property (nonatomic,strong) UILabel *detailLabel;
/** 虎课网 */
@property (nonatomic,strong) UILabel *hukeLabel;
/** 日期*/
@property (nonatomic,strong) UILabel *dateLabel;
/** 左侧 英文 */
@property (nonatomic,strong) UILabel *lefWordLabel;

@property (nonatomic,strong) UIView *lefLineview;
/** 左侧 英文 */
@property (nonatomic,strong) UILabel *rightWordLabel;

@property (nonatomic,strong) UIView *rightLineview;

@property (nonatomic,strong)StudyCertificateModel *certificateModel;

@end





@implementation HKStudyCertificateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_183442;
    [self createLeftBarItemWithImageName:@"hkplayer_back"];
    [self requestCertificateDetail];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:COLOR_183442];
    [self setNavigationBarTitleColor:[UIColor whiteColor]];
    HKStatusBarStyleLightContent;
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    [self setNavigationBarTitleColor:COLOR_27323F];
    HKStatusBarStyleDefault;
}





- (void)createShareButtonItem {
    
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"um_ic_share"
                                                                            highBackgroudImageName:@"um_ic_share"
                                                                                            target:self
                                                                                            action:@selector(shareBtnItemAction)        size:CGSizeMake(40, 40)];
}


/** 分享 */
- (void)shareBtnItemAction {
    ShareModel *model = [ShareModel new];
    model.share_type = @"2";
    model.type = @"15";
    //截图
    UIImage *shootImage = [UIImage imageWithUIView:self.bgView];
    //图片拼接
    UIImage *image = [UIImage combineWithtopImage:shootImage bottomImage:imageName(@"hk_screenshot") withMargin:IS_IPHONE5S ?0 : -40];
    model.share_image = image;
    [self shareWithUI:model];
}



- (void)createUI {

    [self.view addSubview:self.bgView];

    [self.bgView addSubview:self.headImageView];
    [self.bgView addSubview:self.footImageView];
    [self.bgView addSubview:self.congrationLabel];

    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.congrationWordLabel];

    [self.bgView addSubview:self.detailLabel];
    [self.bgView addSubview:self.hukeLabel];
    [self.bgView addSubview:self.dateLabel];

    [self.bgView addSubview:self.lefLineview];
    [self.bgView addSubview:self.rightLineview];

    [self.bgView addSubview:self.lefWordLabel];
    [self.bgView addSubview:self.rightWordLabel];

    [self makeConstraints];
    [self createShareButtonItem];
}

- (void)makeConstraints {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)){
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.top.equalTo(self.view).offset(KNavBarHeight64);
            make.left.right.bottom.equalTo(self.view);
        }
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.width.mas_equalTo(351);
        make.centerY.equalTo(self.view.mas_centerY).offset(-_headImageView.image.size.height/2-KNavBarHeight64/2);
    }];
    
    [self.footImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.headImageView.mas_bottom);
        make.right.left.equalTo(self.headImageView);
    }];
    
    
    [self.congrationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footImageView).offset(10);
        make.left.equalTo(self.footImageView).offset(93/2);
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.congrationLabel.mas_bottom).offset(-2);
        make.left.equalTo(self.congrationLabel.mas_right).offset(PADDING_10);
        make.right.lessThanOrEqualTo(self.bgView);
    }];
    

    [self.congrationWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.congrationLabel.mas_bottom).offset(5);
        make.left.equalTo(self.congrationLabel);
    }];
    
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.congrationWordLabel.mas_bottom).offset(25);
        make.left.equalTo(self.congrationLabel).offset(2);
        make.right.equalTo(self.footImageView).offset(-35);
    }];

    [self.lefWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footImageView.mas_bottom).offset(-PADDING_20*2);
        make.left.equalTo(self.footImageView.mas_left).offset(18+10);
        make.width.equalTo(@80);

    }];

    [self.lefLineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lefWordLabel.mas_top).offset(-2);
        make.centerX.equalTo(self.lefWordLabel);
        make.height.equalTo(@1);
        make.width.equalTo(@80);
    }];

    [self.hukeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lefLineview.mas_top).offset(-5);
        make.centerX.equalTo(self.lefLineview);
    }];

    [self.rightWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footImageView.mas_bottom).offset(-PADDING_20*2);
        make.right.equalTo(self.footImageView.mas_right).offset(-18-10);
        make.width.equalTo(@80);
    }];

    [self.rightLineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rightWordLabel.mas_top).offset(-2);
        make.centerX.equalTo(self.rightWordLabel);
        make.width.equalTo(@80);
        make.height.equalTo(@1);
    }];

    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rightLineview.mas_top).offset(-5);
        make.centerX.equalTo(self.rightLineview);
    }];
    
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_183442;
    }
    return _bgView;
}


- (UIImageView*)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
        _headImageView.image = imageName(@"certificate_head_bg");
    }
    return _headImageView;
}



- (UIImageView*)footImageView {
    if (!_footImageView) {
        _footImageView = [UIImageView new];
        _footImageView.contentMode = UIViewContentModeScaleAspectFit;
        _footImageView.image = imageName(@"certificate_foot_bg");
    }
    return _footImageView;
}


- (HKLineLabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [HKLineLabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = HK_FONT_SYSTEM_BOLD(14);
        _nameLabel.strikeThroughEnabled = YES;
        _nameLabel.strikeThroughColor = COLOR_A8ABBE;
        _nameLabel.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        _nameLabel.textColor = COLOR_27323F;
        _nameLabel.isBottom = YES;
    }
    return _nameLabel;
}



- (UILabel*)congrationLabel {
    if (!_congrationLabel) {
        _congrationLabel = [UILabel labelWithTitle:CGRectZero title:@"恭喜" titleColor:COLOR_27323F titleFont:@"12" titleAligment:NSTextAlignmentLeft];
        _congrationLabel.font = HK_FONT_SYSTEM_BOLD(12);
    }
    return _congrationLabel;
}



- (UILabel*)congrationWordLabel {
    if (!_congrationWordLabel) {
        _congrationWordLabel = [UILabel labelWithTitle:CGRectZero title:@"congratulations" titleColor:COLOR_7B8196 titleFont:@"9" titleAligment:NSTextAlignmentLeft];
        _congrationWordLabel.font = HK_FONT_SYSTEM_BOLD(9);
    }
    return _congrationWordLabel;
}


- (UILabel*)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}


- (UIView*)lefLineview {
    if (!_lefLineview) {
        _lefLineview = [UIView new];
        _lefLineview.backgroundColor = COLOR_27323F;
    }
    return _lefLineview;
}


- (UIView*)rightLineview {
    if (!_rightLineview) {
        _rightLineview = [UIView new];
        _rightLineview.backgroundColor = COLOR_27323F;
    }
    return _rightLineview;
}


- (UILabel*)lefWordLabel {
    if (!_lefWordLabel) {

        _lefWordLabel = [UILabel labelWithTitle:CGRectZero title:@"pricipal" titleColor:COLOR_27323F titleFont:@"14" titleAligment:NSTextAlignmentCenter];
        _lefWordLabel.font = HK_FONT_SYSTEM_BOLD(11);
    }
    return _lefWordLabel;
}


- (UILabel*)rightWordLabel {
    if (!_rightWordLabel) {
        _rightWordLabel = [UILabel labelWithTitle:CGRectZero title:@"pricipal" titleColor:COLOR_27323F titleFont:@"14" titleAligment:NSTextAlignmentCenter];
        _rightWordLabel.font = HK_FONT_SYSTEM_BOLD(11);
    }
    return _rightWordLabel;
}




- (UILabel*)hukeLabel {
    if (!_hukeLabel) {
        _hukeLabel = [UILabel new];
        _hukeLabel.text = @"虎课网";
        _hukeLabel.textAlignment = NSTextAlignmentCenter;
        _hukeLabel.font = HK_FONT_SYSTEM_BOLD(12);
        _hukeLabel.textColor = COLOR_27323F;
    }
    return _hukeLabel;
}


- (UILabel*)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        //_dateLabel.text = @"2018-111-11";
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = HK_FONT_SYSTEM(12);
        _dateLabel.textColor = COLOR_27323F;
    }
    return _dateLabel;
}


//
- (void)setDetailText:(NSString*)title  name:(NSString*)name progress:(NSString*)progress  {

    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];

    NSString *String = @"经过不懈的努力\n";// 经过不懈的努力\n你出色的完成了零基础学习SAI软件\n你的名字\n完成率超过100%的同学，名列前茅！
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:String
                                                                                   attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];

    NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:@"你出色的完成了\n" attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];

    NSString *userTitle = [NSString stringWithFormat:@"%@\n",title];
    NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:userTitle attributes:@{NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:COLOR_FF7820}];


    NSString *userName = [NSString stringWithFormat:@"%@\n",name];
    NSAttributedString *str3 = [[NSAttributedString alloc]initWithString:userName attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];

    NSAttributedString *str4 = [[NSAttributedString alloc]initWithString:@"完成率超过" attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];

    NSString *userPro = [NSString stringWithFormat:@"%@",progress];
    NSAttributedString *str5 = [[NSAttributedString alloc]initWithString:userPro attributes:@{NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:COLOR_FF7820}];

    NSAttributedString *str6 = [[NSAttributedString alloc]initWithString:@"的同学，名列前茅！" attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];

    [attrString appendAttributedString:str1];
    [attrString appendAttributedString:str2];
    [attrString appendAttributedString:str3];

    [attrString appendAttributedString:str4];
    [attrString appendAttributedString:str5];
    [attrString appendAttributedString:str6];

    _detailLabel.attributedText = attrString;

}



- (void)setCertificateModel:(StudyCertificateModel *)certificateModel {
    _certificateModel = certificateModel;
    
    _dateLabel.text = certificateModel.date;
    
    _nameLabel.text = certificateModel.username;
    
    self.title = certificateModel.software_name;
    
    [self setDetailText:certificateModel.software_name name:certificateModel.username progress:@"100%"];
    
    
}




- (void)requestCertificateDetail {
    
    NSDictionary *dict = @{@"id":self.certificateId};
    [HKHttpTool POST:USER_GET_DIPLOMA parameters:dict success:^(id responseObject) {
        
        if (HKReponseOK) {
            [self createUI];
            StudyCertificateModel *model = [StudyCertificateModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self setCertificateModel:model];
        }
    } failure:^(NSError *error) {
        
    }];
}





#pragma mark - UMpopView 友盟分享
- (void)shareWithUI:(ShareModel*)model {
    
    UMpopView *popView = [UMpopView sharedInstance];
    [popView createUIWithModel:model];
    popView.delegate = self;
}


#pragma mark - UMpopView 代理
- (void)uMShareWebSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}

#pragma mark - 分享网页成功 回调 后台
- (void)shareSucessWithModel:(ShareModel*)model {
    
    if (!isLogin()) {
        showTipDialog(Share_Sucess);
        return;
    }
    [HKCommonRequest shareDataSucess:model success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)uMShareImageSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}


- (void)uMShareImageFail:(id)sender {
    
}



@end











