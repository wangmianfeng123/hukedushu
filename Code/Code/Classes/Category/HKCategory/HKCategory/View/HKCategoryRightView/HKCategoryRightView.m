//
//  HKCategoryRightView.m
//  Code
//
//  Created by Ivan li on 2018/4/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCategoryRightView.h"
#import "HKCategoryTreeModel.h"
#import "UIView+SNFoundation.h"
#import "HKCategorySoftwareCell.h"
#import "HKCategoryPGCTeacherCell.h"
#import "HKCategorydevelopCell.h"
#import "HKCategoryDesignCell.h"
#import "HKCategoryBookCell.h"
#import "HKCategoryBookNewCell.h"
#import "HkCategoryStudentCell.h"


#pragma mark--HKCategoryRightCell

@interface HKCategoryRightCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, strong) UILabel *goodNameLabel;

@end

@implementation HKCategoryRightCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.backgroundColor = [UIColor whiteColor];
    self.goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width-25, self.width-25)];
    self.goodImageView.centerX = self.width/2;
    [self.contentView addSubview:self.goodImageView];
    
    self.goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.goodImageView.bottom, self.width, 20)];
    self.goodNameLabel.textColor = RGB(120, 120, 120, 1.0);
    self.goodNameLabel.font = HK_FONT_SYSTEM(12);
    self.goodNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.goodNameLabel];
}

@end






@implementation HKCategoryRightFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.moreCourseBtn];
        
        [self.moreCourseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(180/2, 56/2));
        }];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.moreCourseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, _moreCourseBtn.imageView.width-7, 0, _moreCourseBtn.imageView.width)];
    [self.moreCourseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _moreCourseBtn.titleLabel.bounds.size.width+7, 0, -_moreCourseBtn.titleLabel.bounds.size.width)];
}



- (UIButton*)moreCourseBtn {
    
    if (!_moreCourseBtn) {
        _moreCourseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreCourseBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        [_moreCourseBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateHighlighted];
        [_moreCourseBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreCourseBtn setTitleColor:COLOR_A8ABBE forState:UIControlStateNormal];
        [_moreCourseBtn setTitleColor:[COLOR_A8ABBE colorWithAlphaComponent:0.9] forState:UIControlStateSelected];
        [_moreCourseBtn.titleLabel setFont:HK_FONT_SYSTEM(13)];
        [_moreCourseBtn addTarget:self action:@selector(moreCourseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _moreCourseBtn.clipsToBounds = YES;
        _moreCourseBtn.layer.cornerRadius = 28/2;
        _moreCourseBtn.backgroundColor = COLOR_F2F2F8;
    }
    return _moreCourseBtn;
}



- (void)moreCourseBtnClick:(id)sender {
    self.categoryRightFooterViewBlock ? self.categoryRightFooterViewBlock(@"ddd") :nil;
}

@end





#pragma mark--
#pragma mark--HKCategoryRightHeaderView


@implementation HKCategoryRightHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}


- (void)creatUI{
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.categoryLabel];
    [self addSubview:self.arrowBtn];
    [self addSubview:self.headermageView];
    [self addSubview:self.bottomLineLabel];
    [self setHeaderImageViewGesture];
    [self hkDarkModel];
}

- (void)hkDarkModel {
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.categoryLabel.textColor = COLOR_27323F_A8ABBE;
    self.bottomLineLabel.backgroundColor = COLOR_F8F9FA_333D48;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.headermageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.lessThanOrEqualTo(self.mas_top).offset(12);
        make.right.equalTo(self.mas_right).offset(-PADDING_15);
        make.height.mas_lessThanOrEqualTo(80*Ratio);
        //make.bottom.lessThanOrEqualTo(self.headermageView.mas_bottom).offset(-16);
    }];
    
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.bottom.equalTo(self.mas_bottom).offset(-PADDING_5);
    }];
    
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.categoryLabel);
        make.right.equalTo(self.mas_right).offset(-PADDING_15);
        //make.size.mas_equalTo(CGSizeMake(65, 18));
    }];
    
    [self.bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.categoryLabel);
        make.bottom.equalTo(self.categoryLabel.mas_top).offset(-14);
        make.right.equalTo(self);
        make.height.equalTo(@1);
    }];
}



- (UILabel*)categoryLabel {
    if (!_categoryLabel) {
        _categoryLabel = [UILabel new];
        _categoryLabel.font = HK_FONT_SYSTEM_WEIGHT(16,UIFontWeightSemibold);
        _categoryLabel.textColor = COLOR_27323F;
    }
    return _categoryLabel;
}



- (UIImageView*)headermageView {
    if (!_headermageView) {
        _headermageView = [UIImageView new];
        //_headermageView.contentMode = UIViewContentModeScaleAspectFit;
        _headermageView.hidden = YES;
        _headermageView.userInteractionEnabled = YES;
        _headermageView.clipsToBounds = YES;
        _headermageView.layer.cornerRadius = PADDING_5;
    }
    return _headermageView;
}


/** 添加 手势 */
- (void)setHeaderImageViewGesture{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headermageViewClick)];
    [self.headermageView addGestureRecognizer:tap];
}


- (void)headermageViewClick {
    
    self.categoryRightHeaderViewBlock ?self.categoryRightHeaderViewBlock(self.listModel,self.categoryModel) :nil;
    //[self arrowBtnClickAction];
}



- (UIButton*)arrowBtn {
    
    if (!_arrowBtn) {
        _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        [_arrowBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateHighlighted];
        [_arrowBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_arrowBtn setTitleColor:COLOR_A8ABBE forState:UIControlStateNormal];
        [_arrowBtn setTitleColor:[COLOR_A8ABBE colorWithAlphaComponent:0.9] forState:UIControlStateSelected];
        [_arrowBtn.titleLabel setFont:HK_FONT_SYSTEM(12)];
        _arrowBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_arrowBtn addTarget:self action:@selector(arrowBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [_arrowBtn sizeToFit];
        [_arrowBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:4];
        [_arrowBtn setEnlargeEdgeWithTop:10 right:0 bottom:5 left:SCREEN_WIDTH/2];
        _arrowBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
        _arrowBtn.hidden = YES;
    }
    return _arrowBtn;
}


- (UILabel*)bottomLineLabel {
    if (!_bottomLineLabel) {
        _bottomLineLabel = [UILabel new];
        _bottomLineLabel.backgroundColor = COLOR_F8F9FA;
        _bottomLineLabel.hidden = YES;
    }
    return _bottomLineLabel;
}


- (void)hiddenArrowBtn {
    self.arrowBtn.hidden = YES;
}



- (void)hiddenBottomLine:(BOOL)hidden {
    _bottomLineLabel.hidden = hidden;
}


- (void)arrowBtnClickAction {
    
    self.categoryRightHeaderBtnClickBlock ?self.categoryRightHeaderBtnClickBlock(self.listModel,self.mapModel) :nil;
    
    
    if (self.internetSchoolRightHeaderBtnClickBlock) {
        self.internetSchoolRightHeaderBtnClickBlock(self.schoolListModel.redirect_package , self.schoolListModel);
    }
}


- (void)setCategoryModel:(HKcategoryModel *)categoryModel {
    _categoryModel = categoryModel;
    
    NSURL *URL = nil;
    if (isEmpty(categoryModel.bannerInfo.img_url)) {
        URL = HKURL([HKLoadingImageTool transitionImageUrlString:categoryModel.banner_url]);
    }else{
        URL = HKURL([HKLoadingImageTool transitionImageUrlString:categoryModel.bannerInfo.img_url]);
    }
    [_headermageView sd_setImageWithURL:URL placeholderImage:imageName(HK_Placeholder)];
}


- (void)setListModel:(HKcategoryListModel *)listModel {
    _listModel = listModel;
    _categoryLabel.text = listModel.title;
}


- (void)setSchoolListModel:(HKcategoryOnlineSchoolListModel *)schoolListModel {
    _schoolListModel = schoolListModel;
    _categoryLabel.text = schoolListModel.title;
}


- (void)setMapModel:(HKMapModel *)mapModel {
    _mapModel = mapModel;
    [_headermageView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:mapModel.img_url]) placeholderImage:imageName(HK_Placeholder)];
}


- (void)setcategoryLabelText:(NSString *)text {
    _categoryLabel.text = text;
}

- (void)setarrowBtnText:(NSString *)text{
    [self.arrowBtn setTitle:text forState:UIControlStateNormal];
    [self.arrowBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:4];

}


@end










#pragma mark--
#pragma mark--HKCategoryRightView

@interface HKCategoryRightView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) TypeHeader typeHeader;

@end


@implementation HKCategoryRightView

//- (instancetype)initWithFrame:(CGRect)frame
//         collectionViewLayout:(UICollectionViewLayout *)layout
//                   typeHeader:(TypeHeader)typeHeader
//                     headerId:(NSString*)headerId
//                     footerId:(NSString*)footerId {
//    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
//
//        self.delegate = self;
//        self.dataSource = self;
//        self.showsVerticalScrollIndicator = NO;
//        self.backgroundColor = [UIColor whiteColor];
//        self.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49, 0);
//        self.alwaysBounceVertical = YES;
//        //Cell
//        [self registerClass:[HKCategoryRightCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCategoryRightCell class])];
//        [self registerClass:[HKCategorySoftwareCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCategorySoftwareCell class])];
//        [self registerClass:[HKCategoryPGCTeacherCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCategoryPGCTeacherCell class])];
//        [self registerClass:[HKCategorydevelopCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCategorydevelopCell class])];
//
//        [self registerClass:[HKCategoryDesignCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCategoryDesignCell class])];
//        [self registerClass:[HKCategoryBookNewCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCategoryBookNewCell class])];
//        [self registerClass:[HkCategoryStudentCell class] forCellWithReuseIdentifier:NSStringFromClass([HkCategoryStudentCell class])];
//
//        //head
//        [self registerClass:[HKCategoryRightHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKCategoryRightHeaderView"];
//        [self registerClass:[HKCategoryRightFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HKCategoryRightFooterView"];
//
//        self.backgroundColor = COLOR_FFFFFF_3D4752;
//    }
//    return self;
//}
//
//
//
//
//- (void)setCategorymodel:(HKcategoryModel *)categorymodel {
//    _categorymodel = categorymodel;
//    [self setContentOffset:CGPointMake(0, 0)];// rightTableView 置顶
//    [self reloadData];
//}
//
//
//- (void)setCategoryType:(HKCategoryType)categoryType {
//    if (HKCategoryType_readBooks == categoryType) {
//        self.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49 + 30, 0);
//    }
//    _categoryType = categoryType;
//}
//
//#pragma mark -
//#pragma mark -UICollectionViewDataSource
//

//- (NSInteger)numberOfSection {
//
//    NSInteger count = 0;
//    count += self.categorymodel.class_a.count;
//    count += self.categorymodel.class_b.count;
//    count += self.categorymodel.class_c.count;
//    count += self.categorymodel.class_d.count;
//    return count;
//}


//- (NSInteger)itemsInSection:(NSInteger)section {
//
//    HKCategoryType type = self.categoryType;
//
//    if (HKCategoryType_software == type || HKCategoryType_designCourse == type ) {
//        return  self.categorymodel.class_a[section].list.count;
//
//    } else if (HKCategoryType_develop == type ) {
//        return  self.categorymodel.class_b[section].list.count;
//
//    } else if (HKCategoryType_readBooks == type ) {
//        return  self.categorymodel.class_d[section].bookList.count;
//
//    } else if (HKCategoryType_student == type ) {
//        HKcategoryListModel *listModel = self.categorymodel.class_c[section];
//        NSInteger count = listModel.list.count;
//        if(NO == IS_IPAD) {
//            if (count > 6) {
//                // 手机 超过6个 显示更多
//              count = listModel.isExpan ?count :6;
//            }
//        }
//        return count;
//    }
//    return 0;
//}


//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//
//    return [self numberOfSection];
//}

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//
//    return  [self itemsInSection:section];
//}


//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return [self setCellWithType:self.categoryType collectionView:collectionView cellForItemAtIndexPath:indexPath];
//}




/** cell 创建 */
//- (UICollectionViewCell *)setCellWithType:(HKCategoryType)type  collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    HKcategoryModel *categmodel = self.categorymodel;
//
//    if (HKCategoryType_software == type){
//        HKcategoryChilderenModel *model = categmodel.class_a[section].list[row];
//        HKCategorySoftwareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCategorySoftwareCell class]) forIndexPath:indexPath];
//        cell.childerenModel = model;
//        [cell showBottomLine:row];
//        return cell;
//
//    }else if (HKCategoryType_designCourse == type ) {
//        HKcategoryChilderenModel *model = categmodel.class_a[section].list[row];
//        HKCategoryDesignCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCategoryDesignCell class]) forIndexPath:indexPath];
//        cell.childerenModel = model;
//        [cell showBottomLine:row];
//        return cell;
//
//    }else if (HKCategoryType_develop == type ) {
//        HKcategoryChilderenModel *model = categmodel.class_b[section].list[row];
//        HKCategorydevelopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCategorydevelopCell class]) forIndexPath:indexPath];
//        cell.childerenModel = model;
//        return cell;
//
//    }else if (HKCategoryType_readBooks == type ) {
//        HKCategoryBookNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCategoryBookNewCell class]) forIndexPath:indexPath];
//        cell.model = categmodel.class_d[section].bookList[indexPath.row];
//        return cell;
//
//    }else if (HKCategoryType_student == type ) {
//        HKcategoryListModel *listModel = categmodel.class_c[section];
//        HKcategoryChilderenModel *model = listModel.list[row];
//        HkCategoryStudentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HkCategoryStudentCell class])forIndexPath:indexPath];
//        // 展开后 不显示更多（ 否则显示更多）
//        if (row == 5) {
//            model.is_more = !listModel.isExpan;
//        }
//        cell.childerenModel = model;
//        [cell showBottomLine:row];
//        return cell;
//    }
//    else {
//        return [UICollectionViewCell new];
//    }
//}



//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
//    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
//
//        HKCategoryRightHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKCategoryRightHeaderView" forIndexPath:indexPath];
//        NSInteger section = indexPath.section;
//        WeakSelf;
//        headerView.categoryRightHeaderViewBlock = ^(HKcategoryListModel *model, HKcategoryModel *categoryModel) {
//            StrongSelf;
//            strongSelf.hkcategoryRightViewCliclBlock ? strongSelf.hkcategoryRightViewCliclBlock(model, strongSelf.categoryType,categoryModel) :nil;
//        };
//
//        headerView.categoryRightHeaderBtnClickBlock = ^(HKcategoryListModel *model, HKMapModel *mapModel) {
//            StrongSelf;
//            strongSelf.hKCategoryRightViewMoreBtnClickBlock ? strongSelf.hKCategoryRightViewMoreBtnClickBlock(model, self.categoryType) :nil;
//        };
//
//        HKcategoryModel *model = self.categorymodel;
//        HKCategoryType type = self.categoryType;
//
//        if (HKCategoryType_software == type ) {
//            headerView.arrowBtn.hidden = YES;
//            headerView.categoryModel = model;
//            headerView.listModel = model.class_a[section];
//            if (0 == section) {
//                [headerView hiddenBottomLine:YES];
//            }else{
//                [headerView hiddenBottomLine:NO];
//            }
//
//        }else if (HKCategoryType_designCourse == type ) {
//            headerView.arrowBtn.hidden = YES;
//            headerView.categoryModel = model;
//            headerView.listModel = model.class_a[section];
//            [headerView hiddenBottomLine:YES];
//
//        }else if (HKCategoryType_develop == type ) {
//            headerView.arrowBtn.hidden = YES;
//            headerView.categoryModel = model;
//            headerView.listModel = model.class_b[section];
//            if (0 == section) {
//                [headerView hiddenBottomLine:YES];
//            }else{
//                [headerView hiddenBottomLine:NO];
//            }
//
//        }else if (HKCategoryType_readBooks == type ) {
//            if (0 == section) {
//                headerView.categoryModel = model;
//                headerView.listModel = model.class_c[section];
//                headerView.arrowBtn.hidden = YES;
//                [headerView hiddenBottomLine:YES];
//            }else{
//                headerView.arrowBtn.hidden = NO;
//                headerView.listModel = model.class_b[section-1];
//                [headerView hiddenBottomLine:NO];
//            }
//        }else if (HKCategoryType_student == type ) {
//            headerView.categoryModel = model;
//            headerView.listModel = model.class_c[section];
//            headerView.arrowBtn.hidden = YES;
//            if (0 == section) {
//                [headerView hiddenBottomLine:YES];
//            }else{
//                [headerView hiddenBottomLine:NO];
//            }
//        }
//
//        if (0 == section) {
//            headerView.headermageView.hidden = !self.categorymodel.bannerInfo.is_show;
//            //headerView.headermageView.hidden = NO;
//        }else{
//            headerView.headermageView.hidden = YES;
//        }
//        return headerView;
//
//    } else {
//
//        HKCategoryRightFooterView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HKCategoryRightFooterView" forIndexPath:indexPath];
//        WeakSelf;
//        footView.categoryRightFooterViewBlock = ^(id model) {
//            StrongSelf;
//            strongSelf.hkCategoryRightViewFooterViewBlock ? strongSelf.hkCategoryRightViewFooterViewBlock(model, strongSelf.categoryType,strongSelf.categorymodel) :nil;
//            //strongSelf.hkcategoryRightViewCliclBlock ? strongSelf.hkcategoryRightViewCliclBlock(@"sss", self.categoryType) :nil;
//        };
//        return footView;
//    }
//}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    HKCategoryType type = self.categoryType;
//    if (HKCategoryType_software == type){
//        if (IS_IPAD) {
//            return CGSizeMake(100, 85);
//        }else{
//            return  CGSizeMake(self.width/3, 85);
//        }
//
//    }else if (HKCategoryType_designCourse == type ) {
//        if (IS_IPHONE5S) {
//            return  CGSizeMake((self.width - 30), 125/2);
//        }
//        return  CGSizeMake((self.width - 30 -7.5)/2, 125/2);
//
//    }else if (HKCategoryType_readBooks == type ) {
//        return  CGSizeMake(self.width, 129);
//    }else if (HKCategoryType_develop == type){
//
//        CGFloat W = (self.width - 30 -20)/3.0;
//        CGFloat width = floor(W);
//        return CGSizeMake(IS_IPAD ?100 :width, 50);
//
//    }else if (HKCategoryType_student == type){
//        CGFloat W = (self.width - 30 -20)/3.0;
//        CGFloat width = floor(W);
//        return CGSizeMake(IS_IPAD ?100 :width, 50);
//    }
//    else {
//        return  CGSizeZero;
//    }
//}


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//
//    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
//    switch (self.categoryType) {
//        case HKCategoryType_designCourse:
//            edgeInsets = UIEdgeInsetsMake(PADDING_5, 15, PADDING_5, 15);
//            break;
//        case HKCategoryType_software:
//            edgeInsets = UIEdgeInsetsMake(15, 0, 0, 0);
//            break;
//        case HKCategoryType_student:
//            edgeInsets = UIEdgeInsetsMake(15, PADDING_15, 15, PADDING_15);
//            break;
//        case HKCategoryType_develop:
//            edgeInsets = UIEdgeInsetsMake(15, PADDING_15, 15, PADDING_15);
//            break;
//        default:
//            break;
//    }
//    return edgeInsets;
//}


#pragma mark - X间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    if (HKCategoryType_designCourse == self.categoryType) {
//        return 7.5;
//    }
//
//    if (HKCategoryType_student == self.categoryType || HKCategoryType_develop == self.categoryType) {
//        return 10;
//    }
//    return 0;
//}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    if (HKCategoryType_designCourse == self.categoryType) {
//        return 10 ;
//    }
//
//    if (HKCategoryType_student == self.categoryType || HKCategoryType_develop == self.categoryType) {
//        return 8;
//    }
//    return 0;
//}


/** head */
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//
//    HKCategoryType type = self.categoryType;
//
//    if (type == HKCategoryType_readBooks) {
//
//        if (self.categorymodel.bannerInfo.is_show) {
//            return  CGSizeMake(self.width, 55 +80*Ratio - 20.0);
//        }else{
//            return  CGSizeMake(self.width, 55 - 20.0);
//        }
//    }
//
//    if (0 == section) {
//        if (self.categorymodel.bannerInfo.is_show) {
//            return  CGSizeMake(self.width, 55+80*Ratio);
//        }else{
//            return  CGSizeMake(self.width, 55);
//        }
//    }
//
//    if (HKCategoryType_develop == type  ){
//        return  CGSizeMake(self.width, 52);
//    }
//    return  CGSizeMake(self.width, 44);
//}

/** foot */
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//
////    if (1 == section && HKCategoryType_software == self.categoryType) {
////        return  CGSizeMake(self.width, 50);
////    }
//    return  CGSizeZero;
//}


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    
//    HKcategoryListModel *listModel = nil;
//    
//    HKcategoryModel *categmodel = self.categorymodel;
//    HKCategoryType type = self.categoryType;
//    HKcategoryChilderenModel *model = [HKcategoryChilderenModel new];
//    
//    HKBookModel *bookModel = [HKBookModel new];
//    
//    if (HKCategoryType_software == type || HKCategoryType_designCourse == type ) {
//        listModel = categmodel.class_a[section];
//        model = categmodel.class_a[section].list[row];
//    }else if (HKCategoryType_develop == type ) {
//        listModel = categmodel.class_b[section];
//        model = categmodel.class_b[section].list[row];
//    }else if (HKCategoryType_readBooks == type ) {
//        //虎课读书
//        bookModel = categmodel.class_d[section].bookList[row];
//    }else if (HKCategoryType_student == type ) {
//        model = categmodel.class_c[section].list[row];
//        
//        if(NO == IS_IPAD) {
//            listModel = categmodel.class_c[section];
//            NSInteger count = listModel.list.count;
//            if (count > 6) {
//                if (5 == row && !listModel.isExpan) {
//                    // 手机 超过6个 显示更多
//                    listModel.isExpan = YES;
//                    [collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
//                    [collectionView performBatchUpdates:^{
//                        
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                    //更多 统计
//                    [self umStudentClickWithIndexPath:indexPath childerenModel:model isMore:YES];
//                    return;
//                }
//            }
//        }
//        [self umStudentClickWithIndexPath:indexPath childerenModel:model isMore:NO];
//    }
//    
//    [self umCellClick:type indexPath:indexPath childerenModel:model];
//    BLOCK_EXEC(self.itemClickBlock,self.categorymodel,self.categoryType,model,bookModel,listModel);
//}



@end








@implementation HKCategoryRightView (CategoryVC)

/// 友盟点击 统计
- (void)umCellClick:(HKCategoryType)categoryType indexPath:(NSIndexPath *)indexPath  childerenModel:(HKcategoryChilderenModel *)childerenModel {
        
    switch (categoryType) {
        case HKCategoryType_software:
            [self umSoftwareClickWithIndexPath:indexPath childerenModel:childerenModel];
            break;
        
        case HKCategoryType_designCourse:
            break;
        
        case HKCategoryType_develop:
            [self umDevelopClickWithIndexPath:indexPath childerenModel:childerenModel];
            break;
        
        case HKCategoryType_readBooks:
            break;
        
        case HKCategoryType_student:

            break;
            
        default:
            break;
    }
}




/// 软件入门 统计
- (void)umSoftwareClickWithIndexPath:(NSIndexPath *)indexPath  childerenModel:(HKcategoryChilderenModel *)childerenModel {
    
    switch (indexPath.section) {
        case 0:
            [MobClick event: childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianyi :um_fenleiye_ruanjian_biaoqianyi];
            break;
            
        case 1:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianer :um_fenleiye_ruanjian_biaoqianer];
            break;
        
        case 2:
            [MobClick event:childerenModel.is_more ? um_fenleiye_ruanjian_morebiaoqiansan :um_fenleiye_ruanjian_biaoqiansan];
            break;
        
        case 3:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqiansi :um_fenleiye_ruanjian_biaoqiansi];
            break;
        
        case 4:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianwu :um_fenleiye_ruanjian_biaoqianwu];
            break;
            
        case 5:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianliu :um_fenleiye_ruanjian_biaoqianliu];
            break;
        
        case 6:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianqi :um_fenleiye_ruanjian_biaoqianqi];
            break;
        
        case 7:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianba :um_fenleiye_ruanjian_biaoqianba];
            break;
        
        case 8:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianjiu :um_fenleiye_ruanjian_biaoqianjiu];
            break;
            
        default:
            break;
    }
}



/// 职业办公 统计
- (void)umDevelopClickWithIndexPath:(NSIndexPath *)indexPath  childerenModel:(HKcategoryChilderenModel *)childerenModel {
    // 23 办公  11 职业发展
    NSInteger classId = [childerenModel.class_id intValue];
    switch (classId) {
        case 11:
            [MobClick event: childerenModel.is_more ?um_fenleiye_zhiye_morezhiye :um_fenleiye_zhiye_zhiye];
            break;
            
        case 23:
            [MobClick event: childerenModel.is_more ?um_fenleiye_zhiye_morebangong :um_fenleiye_zhiye_bangong];
            break;
            
        default:
            break;
    }
}



/// 学生专区 统计
- (void)umStudentClickWithIndexPath:(NSIndexPath *)indexPath  childerenModel:(HKcategoryChilderenModel *)childerenModel isMore:(BOOL)isMore {
    switch (indexPath.section) {
        case 0:
            [MobClick event: isMore ?um_fenleiye_xuesheng_morebiaoqianyi :um_fenleiye_xuesheng_biaoqianyi];
            break;
            
        case 1:
            [MobClick event:isMore ?um_fenleiye_xuesheng_morebiaoqianer :um_fenleiye_xuesheng_biaoqianer];
            break;
        
        case 2:
            [MobClick event:isMore ? um_fenleiye_xuesheng_morebiaoqiansan :um_fenleiye_xuesheng_biaoqiansan];
            break;
        
        case 3:
            [MobClick event:isMore ?um_fenleiye_xuesheng_morebiaoqiansi :um_fenleiye_xuesheng_biaoqiansi];
            break;
        
        case 4:
            [MobClick event:isMore ?um_fenleiye_xuesheng_morebiaoqianwu :um_fenleiye_xuesheng_biaoqianwu];
            break;
            
        case 5:
            [MobClick event:isMore ?um_fenleiye_xuesheng_morebiaoqianliu :um_fenleiye_xuesheng_biaoqianliu];
            break;
            
        default:
            break;
    }
}




@end
