//
//  HKDownloadQABottomView.m
//  Code
//
//  Created by hanchuangkeji on 2018/3/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKDownloadQABottomView.h"

@interface HKDownloadQABottomView()

@property (weak, nonatomic) IBOutlet UILabel *textLB;

@end

@implementation HKDownloadQABottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置下横线
     NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"常见下载问题点这里" attributes:attribtDic];
    self.textLB.attributedText = attrString;
        
    self.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
    self.textLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_999999 dark:COLOR_7B8196];
    
}

- (IBAction)btnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(questionBtnClick)]) {
        [self.delegate questionBtnClick];
    }
}


@end
