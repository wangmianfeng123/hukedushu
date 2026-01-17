//
//  HKLuckPriceVC.m
//  抽奖
//
//  Created by hanchuangkeji on 2017/11/9.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import "HKLuckPriceVC.h"
#import "HKVerticalPriceButton.h"
#import "HKLuckyResultView.h"
#import "HKPresentHeaderModel.h"

@interface HKLuckPriceVC () {
    
    NSTimer *startTimer;
    int currentTime;
    int stopTime;
}

@property (assign, nonatomic) CGFloat time;
@property (assign,nonatomic)UIButton *lastSelectedBtn; // 循环的上个按钮
@property (assign, nonatomic) int stopCount;// 停在第几个
@property (nonatomic, assign)int circleNum;// 循环的次数
@property (nonatomic, strong)NSArray *btnArray;
@property (nonatomic, strong)NSArray *sortBtnArray;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewConstrain;

@property (nonatomic, strong)HKLuckPriceModel *is_win_model;// 当前中奖

@property (weak, nonatomic) IBOutlet UIView *containerView;


//@property (nonatomic, strong)NSArray<HKLuckPriceModel *> *modelArray;

@end

@implementation HKLuckPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    
    self.circleNum = 3;
    
    [self setupView];
    
    self.btnArray = @[self.btn0, self.btn1, self.btn2, self.btn5, self.btn4, self.btn3];
    self.sortBtnArray = @[self.btn0, self.btn1, self.btn2, self.btn3, self.btn4, self.btn5];
    
    if (self.modelArray.count == 0) {
        [self getData];
    }else {
        [self processData:self.modelArray];
    }
}


- (void)setupView {
    
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.cornerRadius = 6.0;
    
    self.startBtn.clipsToBounds = YES;
    self.startBtn.layer.cornerRadius = 3.0;
    self.containerView.centerX = self.view.width * 0.5;
    self.containerViewConstrain.constant =  -(SCREEN_HEIGHT - 290 * 0.5);
    if (IS_IPAD || IS_IPHONE6PLUS || IS_IPHONE_X) {
        self.containerViewConstrain.constant += 20;
    }
    self.closeBtn.hidden = NO;
//    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        self.closeBtn.hidden = NO;
//    }];

}


- (IBAction)closeBtnClick:(id)sender {
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.closeBtn.hidden = YES;
        self.containerView.y = SCREEN_HEIGHT;
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)startBtnClick:(id)sender {
    
    //点击开始抽奖
    // 设置随机数
    currentTime = 0;
    
//    _stopCount = 1;//5,0,1,4,3,2 顺时针第一个开始为5
    
    self.time = 0.1;
    stopTime = 7+8*self.circleNum + self.stopCount;
    [self.startBtn setEnabled:NO];
    startTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(start:) userInfo:nil repeats:YES];
    
}


- (void)start:(NSTimer *)timer {
    if (self.lastSelectedBtn ) {
        self.lastSelectedBtn.selected = NO;
    }
    UIButton *oldBtn = [self.btnArray objectAtIndex:currentTime % self.btnArray.count];
//    oldBtn.backgroundColor = [UIColor orangeColor];
    oldBtn.selected = YES;
    self.lastSelectedBtn = oldBtn;
    currentTime++;
    // 停止循环
    if (currentTime > stopTime) {
        [timer invalidate];
//        [self.startBtn setEnabled:YES];
        [self stopWithCount:self.lastSelectedBtn.tag];
        return;
    }
    
    // 一直循环
    if (currentTime > stopTime - 6) {
        self.time += 0.1;
        [timer invalidate];
        startTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(start:) userInfo:nil repeats:YES];
    }
}


/**
 抽奖完成

 @param count 1-7
 */
- (void)stopWithCount:(NSInteger)count {
    // 签到服务器
    [self finishPresent];
}

#pragma mark <Server>

- (void)finishPresent {
    
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange userFinishLuckyNotificationWithToken:[CommonFunction getUserToken] gold:self.is_win_model.gold completion:^(FWServiceResponse *response) {
        
        if (![response.code isEqualToString:SERVICE_RESPONSE_OK] || YES){
            // 显示提示
//            HKLuckyResultView *resultView = [HKLuckyResultView viewFromXib];
//            resultView.clipsToBounds = YES;
//            resultView.layer.cornerRadius = 3.0;
//            resultView.titleLabel.text = @"签到成功";
//            resultView.detailLabel.text = [NSString stringWithFormat:@"恭喜你获得%@，明天再接再厉哦~", self.is_win_model.name_str];
//            [self.view.window addSubview:resultView];
//            resultView.frame = CGRectMake(0, 0, 580*0.5, 162*0.5);
//            resultView.centerX = SCREEN_WIDTH * 0.5;
//            resultView.centerY = SCREEN_HEIGHT * 0.5;
//
//            // 2.0秒移除
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 2.0)), dispatch_get_main_queue(), ^{
//                [resultView removeFromSuperview];
//                [self closeBtnClick:nil];
//            });
            
            if (self.luckCompleteBlock) {
                HKPresentHeaderModel *modelTemp = [HKPresentHeaderModel mj_objectWithKeyValues:self.model2.mj_JSONData];
                self.luckCompleteBlock(modelTemp);
            }

            
            // 发出通知刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:HKPresentVCRefreshNotification object:nil];
            
            [self closeBtnClick:nil];
        };
        

    } failBlock:^(NSError *error) {
        [self closeBtnClick:nil];
    }];
    
}

- (void)getData {
    

        
        HKLuckPriceModel *model1 = [[HKLuckPriceModel alloc] init];
        model1.gold = @"1";
        model1.name_str = @"1虎课币";
//        model1.is_winning = YES;
    
        HKLuckPriceModel *model2 = [[HKLuckPriceModel alloc] init];
        model2.gold = @"2";
        model2.name_str = @"2虎课币";
//        model2.is_winning = YES;
    
        
        HKLuckPriceModel *model3 = [[HKLuckPriceModel alloc] init];
        model3.gold = @"3";
        model3.name_str = @"3虎课币";
//        model3.is_winning = YES;
    
        HKLuckPriceModel *model4 = [[HKLuckPriceModel alloc] init];
        model4.gold = @"14";
        model4.name_str = @"14虎课币";
//        model4.is_winning = YES;
    
        HKLuckPriceModel *model5 = [[HKLuckPriceModel alloc] init];
        model5.gold = @"0";
        model5.name_str = @"全站VIP(3天)";
//        model5.is_winning = YES;
    
        
        HKLuckPriceModel *model6 = [[HKLuckPriceModel alloc] init];
        model6.gold = @"6";
        model6.name_str = @"16虎课币";
        model6.is_winning = YES;
        
        
        self.modelArray = @[model1, model2, model3, model4, model5, model6];
        
    [self processData:self.modelArray];
}



- (void)processData:(NSArray<HKLuckPriceModel *> *)modelArray {
    for (int i = 0; i < modelArray.count; i++) {
        HKLuckPriceModel *model = modelArray[i];
        HKVerticalPriceButton *button = self.sortBtnArray[i];
        [button setTitle:model.name_str forState:UIControlStateNormal];
        // 根据gold设置图片
        [button setMiddleCountLBText:model.gold];
        if (model.gold.intValue <= 0) {
            [button setMiddleCountLBText:@""];
            
            // 13.0，加粗
            button.titleLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightBold];
            [button setImage:imageName(@"ic_draw_vip_v2_1") forState:UIControlStateNormal];
        }else if (model.gold.intValue < 10) {
            [button setImage:imageName(@"ic_drawmoney_v2_1") forState:UIControlStateNormal];
        }else{
            [button setImage:imageName(@"ic_drawmoney_v2_1") forState:UIControlStateNormal];
        }
        
        // 获取中奖model  第几个中奖
        if (model.is_winning) {
            switch (i) {
                case 0:
                    self.stopCount = 5;
                    break;
                case 1:
                    self.stopCount = 0;
                    break;
                case 2:
                    self.stopCount = 1;
                    break;
                case 3:
                    self.stopCount = 4;
                    break;
                case 4:
                    self.stopCount = 3;
                    break;
                case 5:
                    self.stopCount = 2;
                    break;
                default:
                    break;
            }
            self.is_win_model = model;
        }
    }
}

@end



@implementation HKLuckPriceModel

@end
