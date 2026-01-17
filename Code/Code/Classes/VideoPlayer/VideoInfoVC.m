//
//  VideoInfoVC.m
//  Code
//
//  Created by Ivan li on 2017/9/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "VideoInfoVC.h"

@interface VideoInfoVC ()

@end

@implementation VideoInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
