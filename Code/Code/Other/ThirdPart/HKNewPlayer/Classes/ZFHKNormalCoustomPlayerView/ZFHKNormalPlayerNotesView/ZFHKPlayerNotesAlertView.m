//
//  ZFHKPlayerNotesAlertView.m
//  Code
//
//  Created by Ivan li on 2020/12/29.
//  Copyright © 2020 pg. All rights reserved.
//

#import "ZFHKPlayerNotesAlertView.h"
#import "UIView+HKLayer.h"
#import "UMpopView.h"

@interface ZFHKPlayerNotesAlertView ()<UMpopViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *screenNoteBtn;
@property (weak, nonatomic) IBOutlet UIButton *txtNotesBtn;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgAspect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopMargin;

@end

@implementation ZFHKPlayerNotesAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [self.screenNoteBtn addCornerRadius:17];
    [self.txtNotesBtn addCornerRadius:17];
}

- (IBAction)screenNoteBtnClick {
    if (self.didScreenNoteBtnBlock) {
        self.didScreenNoteBtnBlock();
    }
}

- (IBAction)txtNotesBtnClick {
    if (self.didTxtNoteBtnBlock) {
        self.didTxtNoteBtnBlock();
    }
}

- (IBAction)shareBtnClick {
//    if (self.didShareBtnBlock) {
//        self.didShareBtnBlock();
//    }
    ShareModel * model = [[ShareModel alloc] init];
    model.share_image = _imgV.image;
    model.share_type = @"2";
    [self shareWithUI:model];
    [self removeFromSuperview];
}

- (IBAction)closeBtnClick {
    if (self.didCloseBlock) {
        self.didCloseBlock();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imgW.constant = SCREEN_WIDTH * (IS_IPAD ? 0.7 : 0.6);
    if (IS_IPAD) {
        self.buttonTopMargin.constant = 20;
    }else{
        self.buttonTopMargin.constant = 10.0;
    }
    
}

/** 友盟分享 */
- (void)shareWithUI:(ShareModel*)model {
    UMpopView *popView = [UMpopView sharedInstance];
    
    [popView createUIWithModel:model];
    popView.delegate = self;
    
    [MobClick event: detailpage_note_show_share];
}

#pragma mark - UMpopView 代理
- (void)uMShareWebSucess:(id)sender {
//    if ([sender isKindOfClass:[ShareModel class]]) {
//        ShareModel *model = (ShareModel*)sender;
//        [self shareSucessWithModel:model];
//    }
}


#pragma mark - 分享网页成功 回调 后台
- (void)shareSucessWithModel:(ShareModel*)model {
    
//    if (!isLogin()) {
//        showTipDialog(Share_Sucess);
//        return;
//    }
//
//    [HKCommonRequest shareDataSucess:model success:^(id responseObject) {
//
//    } failure:^(NSError *error) {
//
//    }];
}

- (void)uMShareImageSucess:(id)sender {
    
//    if ([sender isKindOfClass:[ShareModel class]]) {
//        ShareModel *model = (ShareModel*)sender;
//        [self shareSucessWithModel:model];
//    }
}

- (void)uMShareImageFail:(id)sender {
    
}

@end
