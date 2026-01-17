//
//  testViewController.m
//  Code
//
//  Created by pg on 16/3/18.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "testViewController.h"
#import "Masonry.h"


@interface testViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UISwipeGestureRecognizer *swipeRight;
@end

@implementation testViewController



- (UISwipeGestureRecognizer *)swipeRight
{
    if (!_swipeRight) {
        _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backForePage)];
        [_swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        _swipeRight.delegate = self;
//        [self.view addGestureRecognizer:self.swipeRight];
//        self.swipeRight.enabled=YES;
    }
    return _swipeRight;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}



-(void)backForePage
{
    [self selectLeftAction:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
    
    [self.view addGestureRecognizer:self.swipeRight];
    self.swipeRight.enabled=YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
