//
//  HKCategoryRightView.h
//  Code
//
//  Created by Ivan li on 2018/4/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKCategoryTreeModel,HKcategoryChilderenModel,HKcategoryModel,HKBookModel,HKcategoryListModel,HKcategoryOnlineSchoolListModel;


typedef void(^ScrollChangeBlock)(BOOL isAdd);

typedef void(^HKCategoryRightViewCliclBlock)(id model,HKCategoryType categoryType,HKcategoryModel *categoryModel);

typedef void(^HKCategoryRightViewMoreBtnClickBlock)(id model,HKCategoryType categoryType);

typedef void(^ItemClickBlock)(HKcategoryModel *model,HKCategoryType categoryType,HKcategoryChilderenModel *childrenModel,HKBookModel *bookModel,HKcategoryListModel *listModel);

typedef void(^ItemTeacherClickBlock)(HKCategoryType categoryType,HKcategoryChilderenModel *childrenModel);

typedef NS_ENUM(NSInteger, TypeHeader) {
    TypeHeaderHave = 0, //默认有header
    TypeHeaderNone      //无
};

@interface HKCategoryRightView : UICollectionView


//- (instancetype)initWithFrame:(CGRect)frame
//         collectionViewLayout:(UICollectionViewLayout *)layout
//                   typeHeader:(TypeHeader)typeHeader
//                     headerId:(NSString*)headerId
//                     footerId:(NSString*)footerId;
//
//@property (nonatomic, copy  ) ItemClickBlock    itemClickBlock;
//
//@property (nonatomic, copy  ) ItemTeacherClickBlock    itemTeacherClickBlock;
//
//@property (nonatomic, copy  ) ScrollChangeBlock scrollChangeBlock;
//
//@property (nonatomic, copy  ) HKCategoryRightViewCliclBlock hkcategoryRightViewCliclBlock;
///** 查看更多 */
//@property (nonatomic, copy  ) HKCategoryRightViewMoreBtnClickBlock hKCategoryRightViewMoreBtnClickBlock;
//
////@property (nonatomic, strong) NSMutableArray    *rightDataArray;
///** 类别 */
//@property (nonatomic, assign)HKCategoryType  categoryType;
//
//@property (nonatomic, strong)HKcategoryModel *categorymodel;
///// footview 点击
//@property (nonatomic, copy) void(^hkCategoryRightViewFooterViewBlock)(id model,HKCategoryType categoryType,HKcategoryModel *categoryModel);

@end





@interface HKCategoryRightView (CategoryVC)

/// 友盟点击 统计
- (void)umCellClick:(HKCategoryType)categoryType indexPath:(NSIndexPath *)indexPath  childerenModel:(HKcategoryChilderenModel *)childerenModel;

/// 学生专区 统计
- (void)umStudentClickWithIndexPath:(NSIndexPath *)indexPath  childerenModel:(HKcategoryChilderenModel *)childerenModel isMore:(BOOL)isMore;

@end



@interface HKCategoryRightHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *categoryLabel;

@property (nonatomic, strong)UIImageView  *headermageView;
/** 查看更多 */
@property (nonatomic, strong)UIButton  *arrowBtn;

@property (nonatomic, strong)HKcategoryModel  *categoryModel;

@property (nonatomic, strong)HKcategoryListModel  *listModel;
/// 虎课网校
@property (nonatomic, strong)HKcategoryOnlineSchoolListModel  *schoolListModel;
/// 虎课网校 banner 和跳转
@property (nonatomic, strong)HKMapModel *mapModel;

/** headview   回调  */
@property (nonatomic, copy) void(^categoryRightHeaderViewBlock)(HKcategoryListModel *model, HKcategoryModel  *categoryModel);
/** 查看更多 按钮 回调  */
@property (nonatomic, copy) void(^categoryRightHeaderBtnClickBlock)(HKcategoryListModel *model, HKMapModel *mapModel);

/** 虎课网校 查看更多 按钮 回调  */
@property (nonatomic, copy) void(^internetSchoolRightHeaderBtnClickBlock)(HKMapModel *mapModel,HKcategoryOnlineSchoolListModel  *schoolListModel);

@property(nonatomic,strong)UILabel *bottomLineLabel;

- (void)hiddenBottomLine:(BOOL)hidden;

- (void)setcategoryLabelText:(NSString *)text;
- (void)setarrowBtnText:(NSString *)text;

@end



@interface HKCategoryRightFooterView : UICollectionReusableView

/** 查看更多 */
@property (nonatomic, strong)UIButton  *moreCourseBtn;
/** 查看更多  回调  */
@property (nonatomic, copy) void(^categoryRightFooterViewBlock)(id model);

@end
