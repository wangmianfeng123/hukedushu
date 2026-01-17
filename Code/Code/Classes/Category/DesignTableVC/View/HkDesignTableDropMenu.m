//
//  HKCategoryReusableView.m
//  Code
//
//  Created by Ivan li on 2019/7/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HkDesignTableDropMenu.h"
#import "HKDropMenu.h"
#import "HKDropMenuModel.h"
#import "HKSoftwareCourseCell.h"
#import "VideoServiceMediator.h"
#import "TagModel.h"

@interface HkDesignTableDropMenu ()<HKDropMenuDelegate>

@property (nonatomic , strong)NSMutableArray * tagArr;
@end


@implementation HkDesignTableDropMenu


- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        //[self createUI];
    }
    return self;
}

- (instancetype)init {
    
    if ([super init]) {
        //[self createUI];
    }
    return self;
}

-(NSMutableArray *)tagArr{
    if (_tagArr == nil) {
        _tagArr = [NSMutableArray array];
    }
    return _tagArr;
}

- (void)createUI {
    if (isEmpty(self.categoryId)) {
        return;
    }
    
    [[VideoServiceMediator sharedInstance] getVideoTagList:self.categoryId  completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            NSData *data = [[response.data objectForKey:@"list"] mj_JSONData];
            self.tagArr =[TagModel mj_objectArrayWithKeyValuesArray:data];
            
            [self setMenuConfigWithArr:self.tagArr defaultTag:self.defaultTag categoryId:self.categoryId];
            [self addSubview:self.dropMenu];
        }
    } failBlock:^(NSError *error) {
        
    }];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.dropMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}



- (void)setMenuConfigWithArr:(NSMutableArray <TagModel*> *)tagArr defaultTag:(NSString*)defaultTag categoryId:(NSString*)categoryId {
    
    HKDropMenuModel *configuration = [[HKDropMenuModel alloc]init];
    configuration.recordSeleted = YES;
    
    configuration.defaultSelectedTag = defaultTag;
    configuration.categoryId = categoryId;
    
    configuration.filterClickType = HKDropMenuFilterCellClickTypeQuit;
    
    
    
    
    configuration.titles = [HKDropMenuModel normalMenuArray:self.tagArr videoCount:0];
    [self setUpDropMenuWithConfig:configuration];
}



#pragma mark - 设置 menu
- (void)setUpDropMenuWithConfig:(HKDropMenuModel*)configuration {
    
    self.dropMenu = [HKDropMenu creatDropMenuWithConfiguration:configuration frame:CGRectMake(0, 0,SCREEN_WIDTH, self.frame.size.height) dropMenuTitleBlock:^(HKDropMenuModel * _Nonnull dropMenuModel) {
        
    } dropMenuTagArrayBlock:^(NSArray * _Nonnull tagArray) {
        
    }];
    
    self.dropMenu.titleViewBackGroundColor = COLOR_FFFFFF_3D4752;
    self.dropMenu.isCategory = YES;
    self.dropMenu.delegate = self;
    self.dropMenu.durationTime = 0.2;
}


- (void)resetMenuStatus {
    [self.dropMenu resetMenuStatus];
}


#pragma mark -  HKDropMenu  代理;
- (void)dropMenu:(HKDropMenu *)dropMenu dropMenuTitleModel:(HKDropMenuModel *)dropMenuTitleModel {
    
    NSInteger selectIndex = dropMenuTitleModel.cellRow;
    if ([self.delegate respondsToSelector:@selector(categoryReusableView:dropMenu:selectIndex:dropMenuTitleModel:)]) {
        [self.delegate categoryReusableView:self dropMenu:dropMenu selectIndex:selectIndex dropMenuTitleModel:dropMenuTitleModel];
    }
}

//筛选菜单确定按钮
- (void)dropMenu:(HKDropMenu *)dropMenu tagArray:(nullable NSArray<HKDropMenuModel *> *)tagArray {
    
    if ([self.delegate respondsToSelector:@selector(categoryReusableView:dropMenu:tagArray:)]) {
        [self.delegate categoryReusableView:self dropMenu:dropMenu tagArray:tagArray];
    }
}


/** 重置筛选 */
- (void)dropMenu: (HKDropMenu *)dropMenu reset:(BOOL)reset {
    
    if ([self.delegate respondsToSelector:@selector(categoryReusableView:dropMenu:reset:)]) {
        [self.delegate categoryReusableView:self dropMenu:dropMenu reset:YES];
    }
}


/** menu 点击 */
- (void)dropMenu:(HKDropMenu *)dropMenu itemIndex:(NSInteger)itemIndex {
    
    if ([self.delegate respondsToSelector:@selector(categoryReusableView:dropMenu:itemIndex:)]) {
        [self.delegate categoryReusableView:self dropMenu:dropMenu itemIndex:itemIndex];
    }
}

- (void)dropMenu:(HKDropMenu *)dropMenu withParam:(HKFiltrateModel *)dic{
    if ([self.delegate respondsToSelector:@selector(categoryReusableView:dropMenu:withParam:)]) {
        [self.delegate categoryReusableView:self dropMenu:dropMenu withParam:dic];
    }
}


- (void)setVideoCount:(NSInteger )videoCount {
    _videoCount = videoCount;
    NSString *title = [NSString stringWithFormat:@"%ld个教程",(long)videoCount];
    [self.dropMenu resetFirstMenuTitleWithTitle:title];
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *result = [super hitTest:point withEvent:event];
    if (result) {
        return result;
    }
    
    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        result = [subview hitTest:subPoint withEvent:event];
        if (result) {
            return result;
        }
    }
    return nil;
}
@end
