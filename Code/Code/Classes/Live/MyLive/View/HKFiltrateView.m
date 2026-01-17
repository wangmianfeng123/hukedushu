//
//  HKFiltrateView.m
//  Code
//
//  Created by Ivan li on 2020/12/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKFiltrateView.h"
#import "HKDropMenuFilterHeader.h"
#import "HKDropMenuFilterItem.h"
#import "HKMyLiveModel.h"
#import "UIView+HKLayer.h"
#import "HKMonmentTypeModel.h"

@interface HKFiltrateView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (strong,nonatomic)UICollectionView *contentCollectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *shaiBtn;
@property (nonatomic , strong) HKClassListModel * studyModel;
@property (nonatomic , strong) NSArray * templeArray;
@end

@implementation HKFiltrateView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.menuView addSubview:self.contentCollectionView];
    //self.backgroundColor =COLOR_FFFFFF_3D4752;
    self.menuView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.studyModel = [[HKClassListModel alloc] init];
    self.studyModel.name = @"已学";
    [self.bottomView addShadowWithColor:[UIColor blackColor] alpha:0.05 radius:2 offset:CGSizeMake(0, -3)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sureBtn addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF6363"].CGColor,(id)[UIColor colorWithHexString:@"#FF961F"].CGColor]];
    });
    
    self.shaiBtn.textColor = COLOR_27323F_EFEFF6;
}

-(void)setTagArray:(NSArray *)tagArray{
    _tagArray = tagArray;
    self.templeArray = [[NSArray alloc] initWithArray:tagArray copyItems:YES];
    BOOL haveStudy = [[NSUserDefaults standardUserDefaults] integerForKey:@"haveStudy"];
    self.studyModel.tagSeleted = haveStudy ? YES : NO;
    [self.contentCollectionView reloadData];
}

- (UICollectionView*)contentCollectionView {
    if (!_contentCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10.0f;
        layout.minimumLineSpacing = 15.0f;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.frame = CGRectMake(0, STATUS_BAR_EH + 40, SCREEN_WIDTH*0.9, SCREEN_HEIGHT -STATUS_BAR_EH -40-KTabBarHeight49 - 44 );
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.contentInset = UIEdgeInsetsMake(0, 25, 0, 25);

        [_contentCollectionView registerClass:[HKDropMenuFilterItem class] forCellWithReuseIdentifier:@"HKDropMenuFilterItemID"];
        [_contentCollectionView registerClass:[HKDropMenuFilterHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKDropMenuFilterHeaderID"];
        _contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _contentCollectionView;
}


#pragma mark <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.isMonmentVC) {
        return self.templeArray.count ? 1 : 0;

    }else{
        return self.templeArray.count ? 2 : 0;

    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section ? 1 : self.templeArray.count;
    //return self.templeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKDropMenuFilterItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKDropMenuFilterItemID" forIndexPath:indexPath];
    if (indexPath.section) {
        cell.model = self.studyModel;
    }else{
        cell.model = self.templeArray[indexPath.row];
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKClassListModel * model = self.templeArray[indexPath.row];
        for (HKClassListModel * tagModel in self.templeArray) {
            if ([model isEqual:tagModel]) {
                tagModel.tagSeleted = YES;
            }else{
                tagModel.tagSeleted = NO;
            }
        }
    }else{
        self.studyModel.tagSeleted = !self.studyModel.tagSeleted;
    }
    [self.contentCollectionView reloadData];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
        return CGSizeMake(kScreenWidth * 0.8, 44);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HKDropMenuFilterHeader *header  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HKDropMenuFilterHeaderID" forIndexPath:indexPath];
    header.title.text = indexPath.section ? @"其他分类" : @"课程分类";
    
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth * 0.9 - 20 - 50) / 3.0f, 30.01f);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (touches.anyObject.view.tag == 100) return;
    [self removeView];
}

- (IBAction)sureBtnClick{
    
    if (self.isMonmentVC) {
        HKMonmentTagModel * currentTagModel = nil;
        for (HKMonmentTagModel * tagModel in self.templeArray) {
            if (tagModel.tagSeleted == YES) {
                currentTagModel = tagModel;
                for (HKMonmentTagModel * tagM in self.tagArray) {
                    if ([tagModel.ID isEqual:tagM.ID]) {
                        tagM.tagSeleted = YES;
                    }else{
                        tagM.tagSeleted = NO;
                    }
                }
            }
        }
        if (currentTagModel) {
//            if (self.sureFiltrateBlock) {
//                self.sureFiltrateBlock(currentTagModel);
//            }
            [MyNotification postNotificationName:@"selectedTagModel" object:nil userInfo:@{@"tagModel":currentTagModel}];
        }else{
            HKMonmentTagModel * tagModel = [[HKMonmentTagModel alloc] init];
            [MyNotification postNotificationName:@"selectedTagModel" object:nil userInfo:@{@"tagModel":tagModel}];
        }
        
    }else{
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        for (HKClassListModel * tagModel in self.templeArray) {
            if (tagModel.tagSeleted == YES) {
                [dic setObject:tagModel.classVal forKey:@"class"];
                for (HKClassListModel * tagM in self.tagArray) {
                    if ([tagModel.classVal isEqual:tagM.classVal]) {
                        tagM.tagSeleted = YES;
                    }else{
                        tagM.tagSeleted = NO;
                    }
                }
            }
        }
        int study = self.studyModel.tagSeleted ? 1 : 0;
        [[NSUserDefaults standardUserDefaults] setInteger:study forKey:@"haveStudy"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [dic setObject:[NSNumber numberWithInt:study] forKey:@"study"];
        [MyNotification postNotificationName:@"myLiveCourseParams" object:nil userInfo:dic];
    }
    
    [self removeView];
    
}

-(IBAction)resrtBtnClick{
    if (self.isMonmentVC) {
        for (int i = 0; i < self.templeArray.count; i++) {
            HKClassListModel * model = self.templeArray[i];
            model.tagSeleted = NO;
        }
    }else{
        for (int i = 0; i < self.templeArray.count; i++) {
            HKClassListModel * model = self.templeArray[i];
            if (i == 0) {
                model.tagSeleted = YES;
            }else{
                model.tagSeleted = NO;
            }
        }
    }
    
    self.studyModel.tagSeleted = NO;
    [self.contentCollectionView reloadData];
}

- (void)removeView{
    if (self.cancelFiltrateBlock) {
        self.cancelFiltrateBlock();
    }
    self.rightMargin.constant = SCREEN_WIDTH;
    [UIView animateWithDuration:0.15 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }];
}

#pragma mark - 保存数据的文件路径
//- (NSString *)filePath:(NSString *)fileName {
//    NSString *doc =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//
//    NSString *sqlitePath = [NSString stringWithFormat:@"%@/%@",doc,fileName];
//    return sqlitePath;
//}
@end
