//
//  HKAlbumTagView.h
//  Code
//
//  Created by Ivan li on 2017/12/4.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKAlbumTagView : UIView

- (void)setImageWithName:(NSString*)imageName  text:(NSString*)text  type:(NSString*)type;

- (void)setImageWithName:(NSString*)imageName  text:(NSString*)text  type:(NSString*)type textColor:(UIColor*)textColor;

@end
