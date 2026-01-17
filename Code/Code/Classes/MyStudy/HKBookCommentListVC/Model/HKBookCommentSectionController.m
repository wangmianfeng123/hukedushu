//
//  HKBookCommentSectionController.m
//  Code
//
//  Created by Ivan li on 2019/8/27.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookCommentSectionController.h"
#import "HKBookCommentTopCell.h"
#import "HKBookCommentChildrenCell.h"
#import "HKBookCommentMoreCell.h"
#import "HKBookCommentModel.h"
#import "HKBookCommentActionCell.h"
#import "HKBookCommentChildrenTopBgCell.h"
#import "HKBookCommentChildrenbottomBgCell.h"



@interface HKBookCommentSectionController()<HKBookCommentTopCellDelegate,BookCommentActionCellDelegate,BookCommentChildrenCellDelegate,IGListBindingSectionControllerDataSource,IGListBindingSectionControllerSelectionDelegate>

@property(nonatomic,strong) HKBookCommentModel *dataObject;

@property(nonatomic,strong) NSMutableArray *dataViewModels;

@property (nonatomic) BOOL expanded;


@end

@implementation HKBookCommentSectionController


- (instancetype)init{
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.selectionDelegate = self;
    }
    return self;
}


//- (NSInteger)numberOfItems{
//    return self.dataViewModels.count;
//}



- (CGSize)sectionController:(nonnull IGListBindingSectionController *)sectionController sizeForViewModel:(nonnull id)viewModel atIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width;
    if ([self.dataViewModels[index] isKindOfClass:[HKBookTopModel class]]) {
        HKBookTopModel *topModel = self.dataViewModels[index];
        return CGSizeMake(width, topModel.model.cellInfoHeight);
    }
    
    if ([self.dataViewModels[index] isKindOfClass:[HKBookMidCommentModel class]]) {
        HKBookMidCommentModel *midModel = self.dataViewModels[index];
        CGFloat height = midModel.model.cellHeight;
        return CGSizeMake(width,(height));
    }
    
    if ([self.dataViewModels[index] isKindOfClass:[HKBookBottomModel class]]) {
        return CGSizeMake(width,20);
    }
    
    if ([self.dataViewModels[index] isKindOfClass:[HKBookMidCommentTopModel class]]) {
        return CGSizeMake(width,10);
    }
    
    if ([self.dataViewModels[index] isKindOfClass:[HKBookMidCommentBottomModel class]]) {
        return CGSizeMake(width,10);
    }
    
    if ([self.dataViewModels[index] isKindOfClass:[HKBookActionModel class]]) {
        return CGSizeMake(width,40);
    }
    
    return CGSizeMake(width, 0);

}



- (nonnull UICollectionViewCell<IGListBindable> *)sectionController:(nonnull IGListBindingSectionController *)sectionController cellForViewModel:(nonnull id)viewModel atIndex:(NSInteger)index {
    
    if ([self.dataViewModels[index] isKindOfClass:[HKBookTopModel class]]) {
        // 主评论
        HKBookCommentTopCell *cell = [self.collectionContext dequeueReusableCellOfClass:[HKBookCommentTopCell class] forSectionController:self atIndex:index];
        cell.delegate = self;
        return cell;
    }
    
    
    if ([self.dataViewModels[index] isKindOfClass:[HKBookMidCommentModel class]]) {
        // 子评论
        HKBookCommentChildrenCell *cell = [self.collectionContext dequeueReusableCellOfClass:[HKBookCommentChildrenCell class] forSectionController:self atIndex:index];
        cell.delegate = self;
        return cell;
    }
    
    
    if ([self.dataViewModels[index] isKindOfClass:[HKBookBottomModel class]]) {
        // 查看更多 cell
        HKBookCommentMoreCell *cell = [self.collectionContext dequeueReusableCellOfClass:[HKBookCommentMoreCell class] forSectionController:self atIndex:index];
        return cell;
    }
    
    
    if ([self.dataViewModels[index] isKindOfClass:[HKBookActionModel class]]) {
        // 评论 更多 按钮 cell
        HKBookCommentActionCell *cell = [self.collectionContext dequeueReusableCellOfClass:[HKBookCommentActionCell class] forSectionController:self atIndex:index];
        cell.delegate = self;
        return cell;
    }
    
    
    if ([self.dataViewModels[index] isKindOfClass:[HKBookMidCommentTopModel class]]) {
        // 子评论 顶部背景 cell
        HKBookCommentChildrenTopBgCell *cell = [self.collectionContext dequeueReusableCellOfClass:[HKBookCommentChildrenTopBgCell class] forSectionController:self atIndex:index];
        return cell;
    }
    
    if ([self.dataViewModels[index] isKindOfClass:[HKBookMidCommentBottomModel class]]) {
        // 子评论底部背景 cell
        HKBookCommentChildrenbottomBgCell *cell = [self.collectionContext dequeueReusableCellOfClass:[HKBookCommentChildrenbottomBgCell class] forSectionController:self atIndex:index];
        return cell;
    }
    
    UICollectionViewCell<IGListBindable> *cell = [self.collectionContext dequeueReusableCellOfClass:[UICollectionViewCell class] forSectionController:self atIndex:index];
    return cell;
}





- (nonnull NSArray<id<IGListDiffable>> *)sectionController:(nonnull IGListBindingSectionController *)sectionController viewModelsForObject:(HKBookCommentModel * )object {

    _dataObject = object;
    HKBookTopModel *topModel = [HKBookTopModel new];
    topModel.model = object;
    [self.dataViewModels addObject:topModel]; // 第1 cell
    
    NSUInteger childrenCount = _dataObject.children.count;
    if (childrenCount) {
        // 子评论 上面灰色背景cell
        HKBookMidCommentTopModel *commentTopModel = [HKBookMidCommentTopModel new];
        [self.dataViewModels addObject:commentTopModel];// 第2 cell
    }
    //第3 cell
    [_dataObject.children enumerateObjectsUsingBlock:^(HKBookCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HKBookMidCommentModel *midModel = [HKBookMidCommentModel new];
        midModel.model = obj;
        if (NO == _dataObject.expanded) {
            if (idx < 3) {
                [self.dataViewModels addObject:midModel];
            }
        }else{
            [self.dataViewModels addObject:midModel];
        }
    }];
    
    
    if (childrenCount) {
        if (childrenCount > 3) {
            //第4 cell
            HKBookBottomModel *bottomModel = [HKBookBottomModel new];
            bottomModel.model = _dataObject;
            bottomModel.model.expanded = _dataObject.expanded;
            [self.dataViewModels addObject:bottomModel];
        }
        // 子评论底部灰色背景cell  第5 cell
        HKBookMidCommentBottomModel *commentBottomModel = [HKBookMidCommentBottomModel new];
        [self.dataViewModels addObject:commentBottomModel];
    }
    
    //第6 cell
    HKBookActionModel *actionModel = [HKBookActionModel new];
    actionModel.model = _dataObject;
    [self.dataViewModels addObject:actionModel];
    return self.dataViewModels;
}





- (void)sectionController:(IGListBindingSectionController *)sectionController didSelectItemAtIndex:(NSInteger)index viewModel:(id)viewModel {
    
    if ([viewModel isKindOfClass:[HKBookBottomModel class]]) {
        // 点击查看更多点击
        self.expanded = !self.expanded;
        _dataObject.expanded = !_dataObject.expanded;
        if ([self.delegate respondsToSelector:@selector(bookCommentSectionController:updateCell:)]) {
            [self.delegate bookCommentSectionController:self updateCell:_dataObject];
        }
        /**
        [self.collectionContext performBatchAnimated:YES updates:^(id<IGListBatchContext>  _Nonnull batchContext) {
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.dataViewModels.count)];
            [batchContext reloadInSectionController:self atIndexes:set];
        } completion:^(BOOL finished) {
            
        }];**/
    }
}





- (NSMutableArray *)dataViewModels {
    if (!_dataViewModels) {
        _dataViewModels = [NSMutableArray array];
    }
    return _dataViewModels;
}



-(HKBookCommentModel *)dataObject{
    return self.object;
}




#pragma mark -- delegate
#pragma mark - HKBookCommentTopCell
//评论
- (void)bookCommentTopCell:(HKBookCommentTopCell*)cell headViewCommentAction:(NSInteger)section model:(HKBookCommentModel*)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookCommentSectionController:bookCommentTopCell:headViewCommentAction:model:)]) {
        [self.delegate bookCommentSectionController:self bookCommentTopCell:cell headViewCommentAction:section model:model];
    }
}

//头像
- (void)bookCommentTopCell:(HKBookCommentTopCell*)cell headViewuserImageViewClick:(NSInteger)section model:(HKBookCommentModel*)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookCommentSectionController:bookCommentTopCell:headViewuserImageViewClick:model:)]) {
        [self.delegate bookCommentSectionController:self bookCommentTopCell:cell headViewuserImageViewClick:section model:model];
    }
}

//评论图片
- (void)bookCommentTopCell:(HKBookCommentTopCell*)cell headViewCommentImageViewClick:(NSInteger)section model:(HKBookCommentModel*)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookCommentSectionController:bookCommentTopCell:headViewCommentImageViewClick:model:)]) {
        [self.delegate bookCommentSectionController:self bookCommentTopCell:cell headViewCommentImageViewClick:section model:model];
    }
}


#pragma mark - HKBookCommentActionCell
///  评价
- (void)hkBookCommentActionCell:(HKBookCommentActionCell*)cell  commentBtn:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookCommentSectionController:hkBookCommentActionCell:commentBtn:)]) {
        [self.delegate bookCommentSectionController:self hkBookCommentActionCell:cell commentBtn:btn];
    }
}
///  举报
- (void)hkBookCommentActionCell:(HKBookCommentActionCell*)cell  complainAction:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookCommentSectionController:hkBookCommentActionCell:complainAction:)]) {
        [self.delegate bookCommentSectionController:self hkBookCommentActionCell:cell complainAction:btn];
    }
}
///  删除
- (void)hkBookCommentActionCell:(HKBookCommentActionCell*)cell  deleteAction:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookCommentSectionController:hkBookCommentActionCell:deleteAction:)]) {
        
        if ([_dataObject.comment_id isEqualToString:cell.model.comment_id]) {
            [self.delegate bookCommentSectionController:self hkBookCommentActionCell:cell deleteAction:btn];
        }
    }
}


#pragma mark --- HKBookCommentChildrenCell
- (void)bookCommentChildrenCell:(HKBookCommentChildrenCell*)cell model:(HKBookCommentModel*)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookCommentSectionController:bookCommentChildrenCell:model:mainCommentModel:)]) {
        [self.delegate bookCommentSectionController:self bookCommentChildrenCell:cell model:model mainCommentModel:_dataObject];
    }
}

@end
