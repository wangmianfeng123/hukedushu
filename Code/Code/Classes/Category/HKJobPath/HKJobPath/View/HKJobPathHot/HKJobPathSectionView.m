//
//  HKJobPathSectionView.m
//  Code
//
//  Created by Ivan li on 2021/5/17.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKJobPathSectionView.h"
#import "HKSoftwareNewOnlineVC.h"

@interface HKJobPathSectionView ()
@property (nonatomic,strong)HKSoftwareTitleView *softwareTitleView;

@end

@implementation HKJobPathSectionView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self addSubview:self.softwareTitleView];
}

- (HKSoftwareTitleView*)softwareTitleView {
    
    if (!_softwareTitleView) {
        _softwareTitleView = [HKSoftwareTitleView new];
        _softwareTitleView.tag = 1000;
        WeakSelf;
        _softwareTitleView.titleClickCallBack = ^(NSInteger index, HKTagModel *tagModel) {
            //[weakSelf.onlineVC loadNewDataWithModel:tagModel];
            if (weakSelf.didTagBlock) {
                weakSelf.didTagBlock(tagModel);
            }
        };
    }
    return _softwareTitleView;
}

-(void)setTitleViewFrame:(CGRect)titleViewFrame{
    _titleViewFrame =titleViewFrame;
    self.softwareTitleView.frame = titleViewFrame;
}

- (void)setTitlesArr:(NSMutableArray<HKTagModel *> *)titlesArr {
    _titlesArr = titlesArr;
    self.softwareTitleView.titlesArr = self.titlesArr;
    if (_softwareTitleView) {
        [_softwareTitleView resetBtnNormalUI];
    }
}



@end
