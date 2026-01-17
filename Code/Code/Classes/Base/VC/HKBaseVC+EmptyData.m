//
//  HKBaseVC+EmptyData.m
//  Code
//
//  Created by Ivan li on 2017/12/5.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC+EmptyData.h"
#import <TBScrollViewEmpty/TBScrollViewEmpty.h>

@implementation HKBaseVC (EmptyData)



//*********************** 空数据视图设置 ***********************／/




#pragma mark - 设置详细text
- (NSAttributedString *)tb_emptyTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    
    NSString *text = nil;
    if (status == TBNetworkStatusNotReachable){
        text = NETWORK_ALREADY_LOST;
    }else{
        text = (isEmpty(self.emptyText) ?(@"暂无内容～"):self.emptyText);
    }
    UIFont *font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
    UIColor *textColor = HKColorFromHex(0xA8ABBE, 1.0);
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    if (!text) {return nil;}
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:text attributes:attributes];
    return attributedString;
    
}


#pragma mark - 设置提示图片
- (void)tb_emptyButtonClick:(UIButton *)btn network:(TBNetworkStatus)status {
    // 遍历找出mj_header
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITableView class]] || [subView isKindOfClass:[UICollectionView class]]) {
            
            if (((UITableView *)subView).mj_header) {
                [((UITableView *)subView).mj_header beginRefreshing];
                break;
            }
        }
    }
}


- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    if (status == TBNetworkStatusNotReachable){
        return imageName(NETWORK_ALREADY_LOST_IMAGE);
    }else{
        return imageName(EMPETY_DATA_IMAGE);
    }
}


- (NSAttributedString *)tb_emptyButtonTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    
    if (status == TBNetworkStatusNotReachable) {
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"重新加载" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:HK_FONT_SYSTEM(14)}];
        return str;
    }
    return nil;
}


@end
