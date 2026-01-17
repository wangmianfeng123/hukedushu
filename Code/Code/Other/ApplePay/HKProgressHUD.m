

// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小
#define TEXT_SIZE    (IS_IPHONE6PLUS ? 15:14)


#define delaySecond 2.0f

#import "HKProgressHUD.h"

@implementation HKProgressHUD

+ (instancetype)sharedHUD {
    
    static HKProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hud = [[HKProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        hud.bezelView.color = [UIColor blackColor];
        hud.bezelView.alpha = 0.5f;
        hud.label.numberOfLines = 0;
        hud.contentColor = [UIColor whiteColor];
    });
    return hud;
}


+ (void)showEnabledHUDStatus:(LMBProgressHUDStatus)status text:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setView:status text:text enabled:NO];
    });
}


+ (void)showStatus:(LMBProgressHUDStatus)status text:(NSString *)text {
        
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setView:status text:text enabled:YES];
    });
    
}




+ (void)setView:(LMBProgressHUDStatus)status text:(NSString *)text enabled:(BOOL)enabled {
    
    HKProgressHUD *hud = [HKProgressHUD sharedHUD];
    hud.userInteractionEnabled = enabled;
    [hud showAnimated:YES];
    hud.detailsLabel.text = text;
    [hud setRemoveFromSuperViewOnHide:YES];
    
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    [hud setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    switch (status) {
            
        case LMBProgressHUDStatusSuccess: {
            
            UIImage *sucImage = [UIImage imageNamed:@"hud_success"];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            hud.customView = sucView;
            [hud hideAnimated:YES afterDelay:delaySecond];
            
        }
            break;
            
        case LMBProgressHUDStatusError: {
            
            UIImage *errImage = [UIImage imageNamed:@"hud_error"];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            hud.customView = errView;
            [hud hideAnimated:YES afterDelay:delaySecond];
        }
            break;
            
        case LMBProgressHUDStatusWaitting: {
            
            hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
        case LMBProgressHUDStatusInfo: {
            
            UIImage *infoImage = [UIImage imageNamed:@"hud_info"];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            hud.customView = infoView;
            [hud hideAnimated:YES afterDelay:delaySecond];
        }
            break;
            
        default:
            break;
    }
}





#pragma mark - 延迟2s 消失提示框
+ (void)showMessage:(NSString *)text {

    HKProgressHUD *hud = [HKProgressHUD sharedHUD];
    [hud showAnimated:YES];
    hud.detailsLabel.text = text;
    [hud setMinSize:CGSizeZero];

    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    //[hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    //[[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud hideAnimated:YES afterDelay:delaySecond];
}



#pragma mark - 自定义延迟时间 消失提示框
+ (void)showMessage:(NSString *)text  afterDelay:(NSTimeInterval)afterDelay {
    
    HKProgressHUD *hud = [HKProgressHUD sharedHUD];
    [hud showAnimated:YES];
    hud.detailsLabel.text = text;
    [hud setMinSize:CGSizeZero];
    
    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    //[[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud hideAnimated:YES afterDelay:afterDelay];
}



+ (void)showInfoMsg:(NSString *)text {
    
    [self showStatus:LMBProgressHUDStatusInfo text:text];
}

+ (void)showFailure:(NSString *)text {
    
    [self showStatus:LMBProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString *)text {
    
    [self showStatus:LMBProgressHUDStatusSuccess text:text];
}

+ (void)showLoading:(NSString *)text {
    
    [self showStatus:LMBProgressHUDStatusWaitting text:text];
}

+ (void)hide {
    [[HKProgressHUD sharedHUD] hideAnimated:YES];
}

+ (void)hideAfterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}


#pragma mark - 延迟2s 消失提示框
+ (void)showCustomViewMessage:(NSString *)text {
    
    
    //[self setView:LMBProgressHUDStatusSuccess text:nil enabled:YES];
    
//    HKProgressHUD *hud = [HKProgressHUD sharedHUD];
//    [hud showAnimated:YES];
//    [hud setMode:MBProgressHUDModeCustomView];
//
//    UIView *infoView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
//    infoView.backgroundColor = [UIColor grayColor];
//    hud.customView = infoView;
//
//    [[UIApplication sharedApplication].keyWindow addSubview:hud];
//    [hud hideAnimated:YES afterDelay:10];
//
}

@end
