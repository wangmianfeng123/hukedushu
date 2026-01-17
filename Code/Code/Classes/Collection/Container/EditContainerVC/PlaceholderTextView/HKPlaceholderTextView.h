
//
//  PlaceholderTextView.h
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HKPlaceholderTextView : UITextView

@property(copy,nonatomic)NSString *placeholder;

@property(strong,nonatomic)NSIndexPath *indexPath;
/**更新高度*/
@property(assign,nonatomic)float updateHeight;
/** 是否显示输入字符数量 */
@property(assign,nonatomic)BOOL isShowLimitCount;



/**
 初始化 TextView 默认最大字符限制 200
 
 @param textLenght
 @param isShowLimitCount    是否显示输入字符数量
 @return
 */
- (instancetype)initWithMaxTextLenght:(NSInteger)textLenght isShowLimitCount:(BOOL)isShowLimitCount;

/**
 *  增加text 长度限制
 *
 *  @param maxLength
 *  @param limit
 */
-(void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void(^)(HKPlaceholderTextView*text))limit;
/**
 *  开始编辑 的 回调
 *
 *  param begin
 */
-(void)addTextViewBeginEvent:(void(^)(HKPlaceholderTextView*text))begin;

/**
 *  结束编辑 的 回调
 *
 *  param begin
 */
-(void)addTextViewEndEvent:(void(^)(HKPlaceholderTextView*text))End;

/**
 *  设置Placeholder 颜色
 *
 *  @param color
 */
-(void)setPlaceholderColor:(UIColor*)color;

/**
 *  设置Placeholder 字体
 *
 *  @param font
 */
-(void)setPlaceholderFont:(UIFont*)font;

/**
 *  设置透明度
 *
 *  @param opacity
 */
-(void)setPlaceholderOpacity:(float)opacity;

@end
