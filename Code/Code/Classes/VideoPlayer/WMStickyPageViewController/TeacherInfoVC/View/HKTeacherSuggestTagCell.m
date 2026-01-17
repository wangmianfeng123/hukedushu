//
//  HKTeacherSuggestTagCell.m
//  Code
//
//  Created by Ivan li on 2021/5/20.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKTeacherSuggestTagCell.h"
#import "YXYTagsView.h"
#import "HKCategoryTreeModel.h"

@interface HKTeacherSuggestTagCell ()

@property (weak, nonatomic) IBOutlet YXYTagsView *tagsView;
@end


@implementation HKTeacherSuggestTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [self initTags];
    self.tagsView.backgroundColor = COLOR_FFFFFF_3D4752;
}


-(void)setOpen:(BOOL)open{
    _open = open;
    [self initTags];
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.tagsView removeAllSubviews];
}

- (void) initTags {
    
    NSMutableArray *tags = [NSMutableArray array];
    for (int i = 0; i < _dataArray.count; i ++) {
        YXYTagModel *tag = [[YXYTagModel alloc] init];
        HKcategoryChilderenModel * model = self.dataArray[i];
        tag.title = model.name;
        tag.model = model;
        tag.normalTitleColor = COLOR_FF7820;
        tag.selectedTitleColor = COLOR_FF7820;
        [tags addObject:tag];
    }
    self.tagsView.didSelected = ^(YXYTagButton *sender) {
        NSLog(@"%@", [NSString stringWithFormat:@"select %@",sender.data.title]);
        if (self.didTagBlock) {
            self.didTagBlock(sender.data.model);
        }
    };
    
    self.tagsView.needChangToFrame = ^(CGRect frame, BOOL isUnfolded) {
        if (self.callBackData) {
            self.callBackData(frame.size.height, isUnfolded);
        }
    };
    [self.tagsView refreshWithTags:tags unflodStatus:_open];
}
@end
