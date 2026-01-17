//
//  LevelView.h
//  Code
//
//  Created by Ivan li on 2017/9/21.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKEnumerate.h"


typedef enum {
    LevelTypeDefault = 0,       //默认
    LevelTypeVeryEasy = 0, //太简单
    LevelTypeVeryEasySelected =1,  //选中
    
    LevelTypeEasy=2,    //简单
    LevelTypeEasySelected = 3,
    
    LevelTypeMiddle=4,       //适中
    LevelTypeMiddleSelected=5,
    
    LevelTypeHard=6,  //
    LevelTypeHardSelected=7,
    
    LevelTypeVeryHard=8,
    LevelTypeVeryHardSlected =9
}LevelType;








@interface LevelView : UIView

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIButton *firstBtn;

@property(nonatomic,strong)UIButton *secondBtn;

@property(nonatomic,strong)UIButton *thirdBtn;

@property(nonatomic,strong)UIButton *fourthBtn;

@property(nonatomic,strong)UIButton *fifthBtn;

@property(nonatomic,assign)NSInteger selectIndex;

@property(nonatomic,assign,readonly)LevelType levelType;

@property(nonatomic,assign)HKCommentType commentType;

@end
