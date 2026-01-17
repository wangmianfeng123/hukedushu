//
//  HKHomeArticleGuideView.m
//  Code
//
//  Created by Ivan li on 2018/8/9.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKHomeArticleGuideView.h"
#import "AppDelegate.h"
#import "UIImage+Helper.h"
  
#import "CommonFunction.h"
#import "DesignTableVC.h"
#import "UIImage+Helper.h"


@interface HKHomeArticleGuideView()

/** 背景 */
@property(nonatomic,strong)UIImageView  *bgIV;

@property(nonatomic,strong)UIImageView  *arrowIV;

@property(nonatomic,strong)UILabel *titleLB;
/** 关闭按钮 */
@property(nonatomic,strong)UIButton *closeBtn;
/** 下滑线按钮 */
@property(nonatomic,strong)UIButton *lineBtn;

@property(nonatomic,assign)NSInteger row;

@property(nonatomic,strong)NSIndexPath *indexPath;

@end


@implementation HKHomeArticleGuideView


- (instancetype)initWithRect:(CGRect)frame row:(NSInteger)row  indexPath:(NSIndexPath *)indexPath{
    
    if (self = [super init]) {
        self.rect = frame;
        self.row = row;
        self.indexPath = indexPath;
        [self createUI];
    }
    return self;
}





- (void)createUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeViewClick)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.arrowIV];
    [self addSubview:self.bgIV];
    [self.bgIV addSubview:self.titleLB];
    
    [self.bgIV addSubview:self.lineBtn];
    [self.bgIV addSubview:self.closeBtn];
    [self makeConstraints];
}




- (void)makeConstraints {
    
    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.row) {
            make.bottom.equalTo(self.mas_bottom);
        }else{
            make.top.equalTo(self);
        }
        
        switch (self.indexPath.row) {
            case 0:case 1:case 5:
                make.left.equalTo(self).offset(self.rect.size.width/2 - PADDING_5);
                break;
            case 4:
                if (IS_IPAD) {
                    make.right.equalTo(self).offset(-self.rect.size.width/2+PADDING_15);
                }else{
                    make.left.equalTo(self).offset(self.rect.size.width/2 - PADDING_5);
                }
                break;
            case 6:
                if (IS_IPAD) {
                    make.left.equalTo(self).offset(self.rect.size.width/2 - PADDING_5);
                }else{
                    make.right.equalTo(self).offset(-self.rect.size.width/2+PADDING_15);
                }
                break;
            default:
                make.right.equalTo(self).offset(-self.rect.size.width/2+PADDING_15);
                break;
        }
    }];
    
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        if (self.row) {
            make.bottom.equalTo(self.arrowIV.mas_top);
        }else{
            make.top.equalTo(self.arrowIV.mas_bottom);
        }
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgIV).offset(PADDING_20);
        make.top.equalTo(self.bgIV).offset(8);
        make.right.equalTo(self.closeBtn.mas_left);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgIV).offset(-PADDING_10);
        make.top.equalTo(self.bgIV).offset(8);
    }];
    
    [self.lineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(PADDING_5);
    }];
}



- (UIImageView*)arrowIV {
    if (!_arrowIV) {
        _arrowIV = [UIImageView new];
        _arrowIV.image = imageName(self.row ?@"ic_down_arrow" :@"ic_up_arrow");
        //[imageName(@"ic_redcolor_bg") rotateCW180];
        _arrowIV.contentMode = UIViewContentModeScaleAspectFit;
        _arrowIV.userInteractionEnabled = YES;
    }
    return _arrowIV;
}



- (UIImageView*)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
        _bgIV.image = imageName(@"ic_redcolor_bg");
        //[imageName(@"ic_redcolor_bg") rotateCW180];
        _bgIV.contentMode = UIViewContentModeScaleAspectFit;
        _bgIV.userInteractionEnabled = YES;
    }
    return _bgIV;
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        
        NSString *title = @"设计文章\n随时随地免费学习";
        _titleLB = [UILabel labelWithTitle:CGRectZero title:title titleColor:[UIColor whiteColor] titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        
        _titleLB.numberOfLines = 0;
        UIFont *font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
        NSMutableAttributedString *attributed = [NSMutableAttributedString changeFontAndColor:font Color:[UIColor whiteColor]
                                                                                  TotalString:title
                                                                               SubStringArray:@[@"设计文章"]];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3;
        style.alignment = NSTextAlignmentLeft;
        [attributed addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, title.length)];
        
        _titleLB.attributedText = attributed;
    }
    return _titleLB;
}





- (UIButton*)lineBtn {
    if (!_lineBtn) {
        _lineBtn = [UIButton new];
        [_lineBtn.titleLabel setFont:HK_FONT_SYSTEM(12)];
        _lineBtn.enabled = NO;
        
        NSString *content= @"我知道了";
        NSMutableAttributedString *string = [NSMutableAttributedString bottomLineAttributedString:content];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, content.length)];
        
        [_lineBtn setAttributedTitle:string forState:UIControlStateNormal];
        
        [_lineBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_20 bottom:PADDING_20 left:PADDING_20];
        [_lineBtn addTarget:self action:@selector(lineBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lineBtn;
}



- (void)lineBtnClick {

    UIViewController *topVC = [CommonFunction topViewController];
    
    DesignTableVC *VC = [DesignTableVC new];
    VC.hidesBottomBarWhenPushed = YES;
    [topVC.navigationController pushViewController:VC animated:YES];
    
    [self closeViewClick];
}


- (UIButton*)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:imageName(@"delete_white") forState:UIControlStateNormal];
        [_closeBtn setImage:imageName(@"delete_white") forState:UIControlStateHighlighted];
        
        [_closeBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_10 bottom:PADDING_30 left:PADDING_20];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}


- (void)closeBtnClick {
    [self closeViewClick];
}



- (void)closeViewClick {
    [HKNSUserDefaults setValue:@"2" forKey:Home_Article_GuideView];
    [HKNSUserDefaults synchronize];
    [self removeGuidePage];
    //[self performSelector:@selector(removeGuidePage) withObject:nil afterDelay:0];
}



- (void)removeGuidePage {
    //移除手势
    for (UIGestureRecognizer *ges in self.gestureRecognizers) {
        [self removeGestureRecognizer:ges];
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}




- (void)dealloc {
    
}




@end










