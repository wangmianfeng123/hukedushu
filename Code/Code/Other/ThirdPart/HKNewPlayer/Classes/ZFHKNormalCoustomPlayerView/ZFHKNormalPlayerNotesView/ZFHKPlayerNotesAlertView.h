//
//  ZFHKPlayerNotesAlertView.h
//  Code
//
//  Created by Ivan li on 2020/12/29.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFHKPlayerNotesAlertView : UIView
@property (nonatomic , strong) void(^didCloseBlock)(void);
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (nonatomic , strong) void(^didScreenNoteBtnBlock)(void);
@property (nonatomic , strong) void(^didTxtNoteBtnBlock)(void);
@property (nonatomic , strong) void(^didShareBtnBlock)(void);
@end

NS_ASSUME_NONNULL_END
