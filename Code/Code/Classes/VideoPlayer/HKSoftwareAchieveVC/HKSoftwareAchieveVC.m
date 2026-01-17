
//
//  HKSoftwareAchieveVC.m
//  Code
//
//  Created by Ivan li on 2018/4/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSoftwareAchieveVC.h"
#import "HKLineLabel.h"
#import <YYText/YYText.h>

@interface HKSoftwareAchieveVC ()

@property (nonatomic,strong) UIImageView *headImageView;

@property (nonatomic,strong) UIImageView *footImageView;

@property (nonatomic,strong) UIButton *okBtn;

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

@property (nonatomic,copy) NSString *softwareName;



@end




@implementation HKSoftwareAchieveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestAchieve];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

- (void)loadView {
    [super loadView];
    [self createUI];
    
}


- (void)setModel:(DetailModel *)model {
    _model = model;
}


/** 证书 详情请求 */
- (void)requestAchieve {
    
    WeakSelf;
    NSDictionary *dict = @{@"video_id":self.model.video_id};
    [HKHttpTool POST:VIDEO_GET_DIPLOMA parameters:dict success:^(id responseObject) {
        StrongSelf;
        if (HKReponseOK) {
            NSString *softwareName = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"software_name"]];
            NSString *userName = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"username"]];
            NSString *date = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"date"]];
            
            strongSelf.softwareName = softwareName;
            
            [strongSelf setDetailText:softwareName name:userName progress:@"100%"];
            strongSelf.dateLabel.text = date;
            strongSelf.nameLabel.text = userName;
            strongSelf.dataArr = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"video_list"]];
        }
    } failure:^(NSError *error) {
        
    }];
}



- (NSMutableArray*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}



- (void)createUI {
    
    self.view.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
    [self.view addSubview:self.headImageView];
    [self.view addSubview:self.footImageView];
    [self.view addSubview:self.congrationLabel];
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.congrationWordLabel];
    [self.view addSubview:self.okBtn];
    
    [self.view addSubview:self.detailLabel];
    [self.view addSubview:self.hukeLabel];
    [self.view addSubview:self.dateLabel];
    
    [self.view addSubview:self.lefLineview];
    [self.view addSubview:self.rightLineview];
    
    [self.view addSubview:self.lefWordLabel];
    [self.view addSubview:self.rightWordLabel];
    
    [self makeConstraints];
    //[self setDetailText:@"软件入门课" name:@"虎课网" progress:@"10%"];
}


- (void)makeConstraints {
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(Ratio*70);
    }];
    
    [self.footImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.headImageView.mas_bottom);
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.footImageView);
        make.top.equalTo(self.footImageView.mas_bottom).offset(PADDING_30);
    }];
    

    [self.congrationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footImageView).offset(10);
        make.left.equalTo(self.footImageView).offset(18);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.congrationLabel.mas_bottom).offset(-2);
        make.left.equalTo(self.congrationLabel.mas_right).offset(PADDING_10);
    }];
    
    [self.congrationWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.congrationLabel.mas_bottom).offset(5);
        make.left.equalTo(self.congrationLabel);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.congrationWordLabel.mas_bottom).offset(25);
        make.left.equalTo(self.congrationLabel).offset(2);
        make.right.equalTo(self.footImageView);
    }];
    
    [self.lefWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footImageView.mas_bottom).offset(-PADDING_20);
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
        make.bottom.equalTo(self.footImageView.mas_bottom).offset(-PADDING_20);
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



- (UIImageView*)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
        _headImageView.image = imageName(@"software_achieve_head_bg");
    }
    return _headImageView;
}



- (UIImageView*)footImageView {
    if (!_footImageView) {
        _footImageView = [UIImageView new];
        _footImageView.contentMode = UIViewContentModeScaleAspectFit;
        _footImageView.image = imageName(@"software_achieve_foot_bg");
    }
    return _footImageView;
}



- (UIButton*)okBtn {
    if (!_okBtn) {
        _okBtn = [UIButton new];
        [_okBtn setBackgroundImage:imageName(@"software_achieve_redbg") forState:UIControlStateNormal];
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_okBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
        [_okBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.8]forState:UIControlStateSelected];
        [_okBtn addTarget:self action:@selector(removeVc) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}


/** 销毁 */
- (void)removeVc {
    
    self.removeVCBlcok ?self.removeVCBlcok(self.dataArr,self.softwareName) :nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


- (HKLineLabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [HKLineLabel new];
        _nameLabel.text = @"我的名字";
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
        _congrationLabel = [UILabel labelWithTitle:CGRectZero title:@"恭喜" titleColor:COLOR_27323F titleFont:@"12"
                                     titleAligment:NSTextAlignmentLeft];
        _congrationLabel.font = HK_FONT_SYSTEM_BOLD(12);
    }
    return _congrationLabel;
}



- (UILabel*)congrationWordLabel {
    if (!_congrationWordLabel) {
        _congrationWordLabel = [UILabel labelWithTitle:CGRectZero title:@"congratulations" titleColor:COLOR_A8ABBE titleFont:@"9" titleAligment:NSTextAlignmentLeft];
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
        
        _lefWordLabel = [UILabel labelWithTitle:CGRectZero title:@"pricipal" titleColor:COLOR_131313 titleFont:@"11" titleAligment:NSTextAlignmentCenter];
        
        _lefWordLabel.font = HK_FONT_SYSTEM_BOLD(11);
//        NSString *str = @"pricipal";
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
//        [attributedString addAttribute:NSObliquenessAttributeName value:@0.3 range:NSMakeRange(0, str.length)];// 倾斜
//        _lefWordLabel.attributedText = attributedString;
    }
    return _lefWordLabel;
}


- (UILabel*)rightWordLabel {
    if (!_rightWordLabel) {
        _rightWordLabel = [UILabel labelWithTitle:CGRectZero title:@"pricipal" titleColor:COLOR_131313 titleFont:@"11" titleAligment:NSTextAlignmentCenter];
        _rightWordLabel.font = HK_FONT_SYSTEM_BOLD(11);
        
//        NSString *str = @"Date";
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
//        [attributedString addAttribute:NSObliquenessAttributeName value:@0.3 range:NSMakeRange(0, str.length)];// 倾斜
//        _rightWordLabel.attributedText = attributedString;
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
    
    NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:@"你出色的完成了" attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    
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








@end










