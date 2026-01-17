//
//  HKDropMenuModel.m
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKDropMenuModel.h"
#import "NSArray+Bounds.h"
#import "TagModel.h"
#import "HKCategoryAlbumModel.h"
#import "NSString+Size.h"



@implementation HKDropMenuModel

MJCodingImplementation


+ (NSMutableArray *)normalMenuArray:(nullable NSMutableArray <TagModel*> *)tagArr videoCount:(NSInteger)videoCount {
    
    /** 第二列数据 */
    NSArray *line2 = @[@"最新",@"最热",@"最简单",@"最难"];
    NSMutableArray *dataArray2 = [NSMutableArray array];
    for (NSInteger index = 0 ; index < line2.count; index++) {
        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
        if (index == 1) {
            dropMenuModel.cellSeleted = YES;
        }
        dropMenuModel.cellRow = index;
        dropMenuModel.title = [line2 by_ObjectAtIndex:index];
        [dataArray2 addObject:dropMenuModel];
    }
            
    NSMutableArray *titlesArray = [NSMutableArray array];
    HKDropMenuModel *menuModel0 = [[HKDropMenuModel alloc]init];
    menuModel0.title = @"精选课程";
    menuModel0.dropMenuType = HKDropMenuTypeEnableTitle;
    menuModel0.hiddenArrow = YES;
    menuModel0.titleFont = HK_FONT_SYSTEM(13);
    menuModel0.menuIndex = 0;

    [titlesArray addObject:menuModel0];


    HKDropMenuModel *menuModel1 = [[HKDropMenuModel alloc]init];
    NSString *temp = (videoCount >0) ? [NSString stringWithFormat:@"%ld个教程",(long)videoCount] : @"教程";
    menuModel1.title = temp;
    menuModel1.dropMenuType = HKDropMenuTypeEnableTitle;
    menuModel1.hiddenArrow = YES;
    menuModel1.titleFont = HK_FONT_SYSTEM(13);
    menuModel1.menuIndex = 1;
    [titlesArray addObject:menuModel1];



    HKDropMenuModel *menuModel2 = [[HKDropMenuModel alloc]init];
    menuModel2.title = @"最热";
    menuModel2.dropMenuType = HKDropMenuTypeTitle;
    menuModel2.dataArray = dataArray2;
    menuModel2.titleFont = HK_FONT_SYSTEM(13);
    menuModel2.menuImageName = @"arrow_down_gray";
    menuModel2.menuHighlightedImageName =  @"arrow_up_orange";
    menuModel2.menuIndex = 2;
    [titlesArray addObject:menuModel2];

    for (TagModel * tagModel in tagArr) {
        if ([tagModel.keyWord isEqualToString:@"tag_id"]) {
            HKDropMenuModel *menuModel3 = [[HKDropMenuModel alloc]init];
            menuModel3.title = @"内容";
            menuModel3.key = tagModel.keyWord;
            menuModel3.dropMenuType = HKDropMenuTypeTitle;
            menuModel3.titleFont = HK_FONT_SYSTEM(13);
            menuModel3.menuImageName = @"arrow_down_gray";
            menuModel3.menuHighlightedImageName =  @"arrow_up_orange";
            menuModel3.sectionHeaderTitle = tagModel.name;
            menuModel3.filterCellType = HKDropMenuFilterCellTypeTag;
            menuModel3.filterClickType = HKDropMenuFilterCellClickTypeQuit;

            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSInteger index = 0 ; index < tagModel.children.count; index++) {
                HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];

                dropMenuModel.tagSeleted = tagModel.children[index].isSelect;
                dropMenuModel.tagId = [tagModel.children[index].ID integerValue];
                dropMenuModel.tagName = tagModel.children[index].name;
                dropMenuModel.key = @"tag_id";
                [tempArr addObject:dropMenuModel];
            }
            menuModel3.dataArray = tempArr;
            menuModel3.menuIndex = 3;
            [titlesArray addObject:menuModel3];
        }else if ([tagModel.keyWord isEqualToString:@"software_tag_id"]) {
            HKDropMenuModel *menuModel4 = [[HKDropMenuModel alloc]init];
            menuModel4.title = @"软件";
            menuModel4.key = tagModel.keyWord;
            menuModel4.dropMenuType = HKDropMenuTypeTitle;
            menuModel4.titleFont = HK_FONT_SYSTEM(13);
            menuModel4.menuImageName = @"arrow_down_gray";
            menuModel4.menuHighlightedImageName =  @"arrow_up_orange";
            menuModel4.sectionHeaderTitle = tagModel.name;
            menuModel4.filterCellType = HKDropMenuFilterCellTypeTag;
            menuModel4.filterClickType = HKDropMenuFilterCellClickTypeQuit;

            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSInteger index = 0 ; index < tagModel.children.count; index++) {
                HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];

                dropMenuModel.tagSeleted = tagModel.children[index].isSelect;
                dropMenuModel.tagId = [tagModel.children[index].ID integerValue];
                dropMenuModel.tagName = tagModel.children[index].name;
                dropMenuModel.key = @"software_tag_id";
                [tempArr addObject:dropMenuModel];
            }
            menuModel4.dataArray = tempArr;
            menuModel4.menuIndex = 4;
            [titlesArray addObject:menuModel4];
        }
    }

    HKDropMenuModel *menuModel5 = [[HKDropMenuModel alloc]init];
    menuModel5.title = @"筛选";
    menuModel5.dropMenuType = HKDropMenuTypeFilter;
    menuModel5.titleFont = HK_FONT_SYSTEM(13);
    menuModel5.menuImageName =  @"funnel_gray";
    menuModel5.menuHighlightedImageName = @"funnel_orange";
    menuModel5.menuIndex = 5;
    [titlesArray addObject:menuModel5];

    
    
//    NSMutableArray *titlesArray = [NSMutableArray array];
//    NSArray *types = @[@(HKDropMenuTypeEnableTitle),@(HKDropMenuTypeEnableTitle),@(HKDropMenuTypeTitle),@(HKDropMenuTypeFilterBtn),@(HKDropMenuTypeFilterBtn),@(HKDropMenuTypeFilterBtn), @(HKDropMenuTypeFilter)];
//
//    /** 菜单标题 */
//
//    NSString *temp = (videoCount >0) ? [NSString stringWithFormat:@"%ld个教程",(long)videoCount] : @"教程";
//    NSArray *titles = @[@"精选课程",temp,@"最新",@"进阶",@"系列课",@"图文教程",@"筛选"];
//
//
//    for (NSInteger index = 0 ; index < titles.count; index++) {
//
//        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
//        dropMenuModel.title = titles[index];
//        NSNumber *typeNum = types[index];
//        dropMenuModel.dropMenuType = typeNum.integerValue;
//
//        if (index == 0 || index == 1 ||index == 3 ||index == 4 ||index == 5) {
//            dropMenuModel.hiddenArrow = YES;
//            dropMenuModel.titleFont = HK_FONT_SYSTEM(13);
//            //dropMenuModel.titleFont = HK_FONT_SYSTEM_BOLD(13);
//
//        } else if (index == 2) {
//            dropMenuModel.dataArray = dataArray2;
//
//            dropMenuModel.titleFont = HK_FONT_SYSTEM(13);
//            dropMenuModel.menuImageName = @"arrow_down_gray";
//            dropMenuModel.menuHighlightedImageName =  @"arrow_up_orange";
//        } else if (index == 6) {
//            //dropMenuModel.sections = sections;
//            dropMenuModel.titleFont = HK_FONT_SYSTEM(13);
//            dropMenuModel.menuImageName =  @"funnel_gray";
//            dropMenuModel.menuHighlightedImageName = @"funnel_orange";
//        }
//
//        dropMenuModel.titleColor = COLOR_7B8196;
//        dropMenuModel.titleSelectColor = COLOR_ff7c00;
//
//        dropMenuModel.menuIndex = index;
//        [titlesArray addObject:dropMenuModel];
//    }
    return titlesArray;
}

-(NSString *)title{
    return _title.length ? _title : _tagName;
}



/**
 搜索筛选

 @param tagArr tag
 @param sortArray 排序tag 数组
 @return
 */
+ (NSMutableArray *)searchMenuArray:(nullable NSMutableArray <TagModel*> *)tagArr
                          sortArray:(nullable NSMutableArray <TagModel*> *)sortArray {
    
    /** 第一列数据 */
//    //NSMutableArray *line2 = sortArray;
//    NSMutableArray *dataArray2 = [NSMutableArray array];
//    for (NSInteger index = 0 ; index < sortArray.count; index++) {
//        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
//        if (index == 0) {
//            dropMenuModel.cellSeleted = YES;
//        }
//        dropMenuModel.cellRow = index;
//
//        TagModel tagModel *[sortArray by_ObjectAtIndex:index];
//
//        dropMenuModel.title = [sortArray by_ObjectAtIndex:index];
//        [dataArray2 addObject:dropMenuModel];
//    }

    NSMutableArray *dataArray2 = [NSMutableArray array];
    for (NSInteger index = 0 ; index < sortArray.count; index++) {
        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
        if (index == 0) {
            dropMenuModel.cellSeleted = YES;
            dropMenuModel.titleSeleted = YES;
        }
        
        TagModel *tagModel = [sortArray by_ObjectAtIndex:index];
        dropMenuModel.title = tagModel.value;
        
        dropMenuModel.cellRow = tagModel.key;
        [dataArray2 addObject:dropMenuModel];
    }
    
    
    /** 设置构造右侧弹出筛选菜单每行的标题 */
    NSMutableArray *sections = [NSMutableArray array];
    
    for (NSInteger index = 0; index < tagArr.count; index++) {
        TagModel *tagM = tagArr[index];
        
        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
        dropMenuModel.sectionHeaderTitle = tagM.name;
        dropMenuModel.filterCellType = HKDropMenuFilterCellTypeTag;
        
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSInteger index = 0 ; index < tagM.children.count; index++) {
            
            HKDropMenuModel *children = [[HKDropMenuModel alloc]init];
            children.tagSeleted = tagM.children[index].isSelect;
            
            
//            if (0 == index) {
//                children.tagSeleted = YES;
//            }
            
            children.tagId = [tagM.children[index].class_id integerValue];
            children.tagName = tagM.children[index].name;
            [tempArr addObject:children];
        }
        dropMenuModel.dataArray = tempArr;
        [sections addObject:dropMenuModel];
    }
    
    NSMutableArray *titlesArray = [NSMutableArray array];
    NSArray *types = @[@(HKDropMenuTypeTitle), @(HKDropMenuTypeFilter)];
    
    /** 菜单标题 */
    NSArray *titles = @[@"排序",@"筛选"];
    
    for (NSInteger index = 0 ; index < titles.count; index++) {
        
        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
        dropMenuModel.title = titles[index];
        NSNumber *typeNum = types[index];
        dropMenuModel.titleCenter = YES;
        
        
        dropMenuModel.dropMenuType = typeNum.integerValue;
        if (index == 0) {
            dropMenuModel.dataArray = dataArray2;
            dropMenuModel.menuImageName = @"arrow_down_gray";
            dropMenuModel.menuHighlightedImageName =  @"arrow_up_orange";
        } else if (index == 1) {
            dropMenuModel.sections = sections;
            dropMenuModel.menuImageName = @"funnel_gray";
            dropMenuModel.menuHighlightedImageName =  @"funnel_orange";
        }
        
        dropMenuModel.titleFont = HK_FONT_SYSTEM(13);
        dropMenuModel.titleColor = COLOR_7B8196;
        dropMenuModel.titleSelectColor = COLOR_ff7c00;
        
        dropMenuModel.menuIndex = index;
        [titlesArray addObject:dropMenuModel];
    }
    return titlesArray;
}





/**
 专辑筛选

 @param tagArr 标签
 @param videoCount 视频数量
 @return
 */
+ (NSMutableArray *)albumMenuArray:(nullable NSMutableArray <AlbumSortTagListModel*> *)tagArr videoCount:(NSInteger)videoCount {
    
    /** 第二列数据 */
    NSArray *line2 = @[@"默认排序",@"收藏人数",@"教程数量",@"创建时间"];
    NSMutableArray *dataArray2 = [NSMutableArray array];
    for (NSInteger index = 0 ; index < line2.count; index++) {
        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
        if (index == 0) {
            dropMenuModel.cellSeleted = YES;
        }
        dropMenuModel.cellRow = index;
        dropMenuModel.title = [line2 by_ObjectAtIndex:index];
        [dataArray2 addObject:dropMenuModel];
    }
    
    
    /** 设置构造右侧弹出筛选菜单每行的标题 */
    NSMutableArray *sections = [NSMutableArray array];
    
    for (NSInteger index = 0; index < tagArr.count; index++) {
        AlbumSortTagListModel *tagM = tagArr[index];
        
        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
        dropMenuModel.sectionHeaderTitle = tagM.name;
        dropMenuModel.filterCellType = HKDropMenuFilterCellTypeTag;
        
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSInteger index = 0 ; index < tagM.children.count; index++) {
            HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
            dropMenuModel.tagSeleted = tagM.children[index].isSelect;
//            if (0 == index) {
//                dropMenuModel.tagSeleted = YES;
//            }
            dropMenuModel.tagId = [tagM.children[index].class_id integerValue];
            dropMenuModel.tagName = tagM.children[index].name;
            
            
            [tempArr addObject:dropMenuModel];
        }
        dropMenuModel.dataArray = tempArr;
        [sections addObject:dropMenuModel];
    }
    
    NSMutableArray *titlesArray = [NSMutableArray array];
    NSArray *types = @[@(HKDropMenuTypeEnableTitle), @(HKDropMenuTypeTitle), @(HKDropMenuTypeFilter)];
    
    /** 菜单标题 */
    
    NSString *temp = (videoCount >0) ? [NSString stringWithFormat:@"%ld个专辑",videoCount] : @"专辑";
    NSArray *titles = @[temp,@"排序",@"筛选"];
    
    for (NSInteger index = 0 ; index < titles.count; index++) {
        
        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
        dropMenuModel.title = titles[index];
        NSNumber *typeNum = types[index];
        dropMenuModel.dropMenuType = typeNum.integerValue;
        dropMenuModel.filterClickType = HKDropMenuFilterCellClickTypeQuit;
        
        if (index == 0) {
            dropMenuModel.hiddenArrow = YES;
        } else if (index == 1) {
            
            dropMenuModel.dataArray = dataArray2;
            dropMenuModel.menuImageName = @"arrow_down_gray";
            dropMenuModel.menuHighlightedImageName =  @"arrow_up_orange";
        } else if (index == 2) {
            dropMenuModel.sections = sections;
            dropMenuModel.menuImageName =  @"funnel_gray";
            dropMenuModel.menuHighlightedImageName = @"funnel_orange";
        }
        
        dropMenuModel.titleFont = HK_FONT_SYSTEM(13);
        dropMenuModel.titleColor = COLOR_7B8196;
        dropMenuModel.titleSelectColor = COLOR_ff7c00;
        
        dropMenuModel.menuIndex = index;
        [titlesArray addObject:dropMenuModel];
    }
    return titlesArray;
}

-(CGFloat)menuWidth{
    if (_menuWidth == 0) {
        _menuWidth = [NSString sizeWithText:self.title font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width +  20;
    }
    return _menuWidth;
}

@end

@implementation HKFiltrateModel

@end


