//
//  HKUMpopViewController.m
//  Code
//
//  Created by Ivan li on 2018/2/1.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUMpopViewController.h"
#import "HKUMpopView.h"

@interface HKUMpopViewController ()<HKUMpopViewDelegate>

@property(nonatomic,strong)HKUMpopView *hkUMpopView;

@end

@implementation HKUMpopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"HKUMpopViewController");
}

- (void)loadView {
    [super loadView];
    [self setUp];
}

- (void)setUp {
    [self.view addSubview:self.hkUMpopView];
}


- (HKUMpopView*)hkUMpopView {
    
    if (!_hkUMpopView) {
        _hkUMpopView = [[HKUMpopView alloc]init];
        _hkUMpopView.delegate = self;
    }
    return _hkUMpopView;
}


- (void)removeUMpopView:(id)sender {
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
