//
//  TagSelectorVC.m
//  KenTagSelector
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 KANG HAN. All rights reserved.
//

#import "TagSelectorVC.h"
#import "SelectedHeaderView.h"
#import "UnselectedHeaderView.h"
#import "KenTagSelectorUtils.h"
#import "TagModel.h"
#import "UIView+HKLayer.h"

#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define HEAD_SELECTED   @"head_selected"
#define HEAD_OTHER      @"head_other"

@interface TagSelectorVC () <UICollectionViewDelegate,UICollectionViewDataSource,ChannelCellDelegate>
{
    NSMutableArray *_selectedTags;
    NSMutableArray *_otherTags;
    
//    UIButton        *_btnExit;
//    UILabel         *_labelTitle;

    BOOL _isEditMode;       //是否处于编辑状态
}
@property (nonatomic , copy) NSString * selectedTagString;


@end

@implementation TagSelectorVC

-(instancetype)initWithSelectedTags:(NSArray *)selectedTags andOtherTags:(NSArray *)otherTags {
    
    self = [super init];
    if (self) {
//        _selectedTagStringArray = selectedTags.mutableCopy;
//        _otherTagStringArray = otherTags.mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isEditMode = YES;
    [self loadInterestSignData];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self createLeftBarButton];
    
    UIButton * sureBtn = [UIButton buttonWithTitle:@"好了，返回首页" titleColor:[UIColor colorWithHexString:@"#FFFFFF"] titleFont:@"17" imageName:nil];
    sureBtn.frame = CGRectMake((SCREEN_WIDTH-245)*0.5, SCREEN_HEIGHT - 50 - TAR_BAR_XH - 10, 245, 50);
    [sureBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF8A00"].CGColor,(id)[UIColor colorWithHexString:@"#FFB600"].CGColor]];
    [sureBtn addCornerRadius:25];
    [self.view addSubview: sureBtn];
    
    UILabel * tipLabel = [UILabel labelWithTitle:CGRectMake(0, CGRectGetMinY(sureBtn.frame) - 50, SCREEN_WIDTH, 50) title:@"长按可拖动排序哦" titleColor:[UIColor colorWithHexString:@"#7B8196"] titleFont:@"13" titleAligment:NSTextAlignmentCenter];
    [self.view addSubview:tipLabel];
    
}

-(void)backAction{
    //[self.navigationController popViewControllerAnimated:YES];
    [self saveStudyTagToServer:_selectedTags];
}

- (void)initTags {
    _selectedTags = @[].mutableCopy;
    _otherTags = @[].mutableCopy;
    //for (NSString *title in _selectedTagStringArray) {
    for (TagModel * tagModel in _selectedTagStringArray) {
        
        Channel *mod = [[Channel alloc]init];
        mod.title = tagModel.name;
        mod.class_id = tagModel.class_id;
        mod.resident = NO;
        for (NSString * resident in _residentTagStringArray) {
            if ([resident isEqualToString:tagModel.name]) {
                mod.resident = YES;     //在residentTagStringArray中存在，说明是不允许取消选择的Tag
            }
        }

        mod.editable = YES;
        
        mod.selected = [self.focusTitle isEqualToString:mod.title];
        
        mod.tagType = SelectedChannel;

        [_selectedTags addObject:mod];
    }
    //for (NSString *title in _otherTagStringArray) {
    for (TagModel *tagModel in _otherTagStringArray) {
        Channel *mod = [[Channel alloc]init];
        mod.title = tagModel.name;
        mod.editable = NO;
        mod.selected = NO;
        mod.class_id = tagModel.class_id;
        mod.tagType = OtherChannel;
        [_otherTags addObject:mod];
    }
}

- (void)setupViews{
    self.title = @"定制首页分类栏";
        
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _collectionMain = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KNavBarHeight64, self.view.frame.size.width, SCREEN_HEIGHT - KNavBarHeight64 - 150) collectionViewLayout:layout];
    [self.view addSubview:_collectionMain];
    _collectionMain.backgroundColor = [UIColor clearColor];
    [_collectionMain registerClass:[ChannelCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionMain registerClass:[SelectedHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEAD_SELECTED];
    [_collectionMain registerClass:[UnselectedHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEAD_OTHER];
    _collectionMain.delegate = self;
    _collectionMain.dataSource = self;
    _collectionMain.contentInset = UIEdgeInsetsMake(10, 15, 10, 15);
    
    //添加长按手势
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [_collectionMain addGestureRecognizer:longPress];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _collectionMain.frame = CGRectMake(0, KNavBarHeight64, self.view.frame.size.width, SCREEN_HEIGHT - KNavBarHeight64 - 100);
}

- (void)longPress:(UIGestureRecognizer *)longPress {
    
    if (_selectedTags.count <= 1) {
        return;
    }
    //获取点击坐标
    CGPoint point=[longPress locationInView:_collectionMain];
    
    NSIndexPath *indexPath=[_collectionMain indexPathForItemAtPoint:point];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [_collectionMain beginInteractiveMovementForItemAtIndexPath:indexPath];

    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        [_collectionMain updateInteractiveMovementTargetPosition:point];

    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        [_collectionMain endInteractiveMovement];

    } else {
        [_collectionMain cancelInteractiveMovement];
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _selectedTags.count;
    }else{
        return _otherTags.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellIdentifier";
    ChannelCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section == 0) {
        if (_selectedTags.count>indexPath.item) {
            cell.model = _selectedTags[indexPath.item];
            cell.btnDel.tag = indexPath.item;
            cell.delegate = self;
//            if (_isEditMode) {
                if (cell.model.resident) {
                    cell.btnDel.hidden = YES;
                    cell.addImgv.hidden = NO;
                }else{
                    if (!cell.model.editable) {
                        cell.btnDel.hidden = YES;
                        cell.addImgv.hidden = NO;
                    }else{
                        cell.btnDel.hidden = NO;
                        cell.addImgv.hidden = YES;
                    }
                }
//            }else{
//                cell.btnDel.hidden = YES;
//            }
        }
    }else if (indexPath.section == 1){
        if (_otherTags.count>indexPath.item) {
            cell.model = _otherTags[indexPath.item];
            cell.delegate = self;
//            if (_onEdit) {
//                cell.delBtn.hidden = NO;
//            }else{
                cell.btnDel.hidden = YES;
                cell.addImgv.hidden = NO;
//            }
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int count  = IS_IPAD ? 6.0 : 3.0 ;
    CGFloat w = (SCREEN_WIDTH - 30) / count - (count - 1) * 10 ;
    return CGSizeMake(w, w * 30 / 86.0 + 4);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 4, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return section ? CGSizeMake(collectionView.bounds.size.width, 20) : CGSizeZero;
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *reusableview = nil;
//    if (indexPath.section == 0) {
//        if (kind == UICollectionElementKindSectionHeader) {
//            NSString *CellIdentifier = HEAD_SELECTED;
//            SelectedHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//            [header.btnEdit addTarget:self action:@selector(editTags:) forControlEvents:UIControlEventTouchUpInside];
//
//            reusableview = header;
//        }
//    }else if (indexPath.section == 1){
//        if (kind == UICollectionElementKindSectionHeader){
//            NSString *CellIdentifier = HEAD_OTHER;
//            UnselectedHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//            reusableview = header;
//        }
//    }
//    return reusableview;
//}

/** 进入编辑状态 */
//- (void)editTags:(UIButton *)sender{
//
////    if (!_isEditMode) {
//        for (ChannelCollectionCell *items in _collectionMain.visibleCells) {
//            if (items.model.tagType == SelectedChannel) {
//                if (items.model.resident) {
//                    items.btnDel.hidden = YES;
//                }else{
//                    items.btnDel.hidden = NO;
//                }
//            }
//        }
//        [sender setTitle:@"完成" forState:UIControlStateNormal];
////    }else{
////        for (ChannelCollectionCell *items in _collectionMain.visibleCells) {
////            if (items.model.tagType == SelectedChannel) {
////                items.btnDel.hidden = YES;
////            }
////        }
////        [sender setTitle:@"编辑" forState:UIControlStateNormal];
////    }
////    [_collectionMain reloadData];
////    _isEditMode = !_isEditMode;
//
//}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    ChannelCollectionCell *cell = (ChannelCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (cell.model.resident) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Channel *object= _selectedTags[sourceIndexPath.item];
    [_selectedTags removeObjectAtIndex:sourceIndexPath.item];
    if (destinationIndexPath.section == 0) {
        [_selectedTags insertObject:object atIndex:destinationIndexPath.item];
    }else if (destinationIndexPath.section == 1) {
        object.tagType = OtherChannel;
        object.editable = NO;
        object.selected = NO;
        [_otherTags insertObject:object atIndex:destinationIndexPath.item];
        [collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];
    }
    
    [self refreshDelBtnsTag];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
//        NSInteger item = 0;
//        for (Channel *mod in _selectedTags) {
//            if (mod.selected) {
//                mod.selected = NO;
//                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:item inSection:0]]];
//            }
//            item++;
//        }
//        Channel *object = _selectedTags[indexPath.item];
//        object.selected = YES;
//        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
//        typeof(self) __weak weakSelf = self;
//        [self dismissViewControllerAnimated:YES completion:^{
//            //单选某个tag
//            if (weakSelf.activeTag) {
//                weakSelf.activeTag(self->_selectedTags,self->_otherTags, object, indexPath.item);
//            }
//        }];
    }else if (indexPath.section == 1) {
        ChannelCollectionCell *cell = (ChannelCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.model.editable = YES;
        cell.model.tagType = SelectedChannel;
        cell.title.text = cell.model.title;

        //[_collectionMain reloadItemsAtIndexPaths:@[indexPath]];
        [_otherTags removeObjectAtIndex:indexPath.item];
        [_selectedTags addObject:cell.model];
        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:_selectedTags.count-1 inSection:0];
        cell.btnDel.tag = targetIndexPage.item;
        cell.btnDel.hidden = !_isEditMode;
        
        cell.addImgv.hidden = _isEditMode;
        //cell.title.backgroundColor = [UIColor colorWithHexString:@"#FFB600"];
        cell.bgImgv.image = [UIImage imageNamed:@"btn_type_sel"];
        cell.title.textColor = [UIColor colorWithHexString:@"#FFFFFF"];

        [_collectionMain moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    }
    
    [self refreshDelBtnsTag];
}

-(void)deleteCell:(UIButton *)sender{
    
    if (_selectedTags.count <= 1) {
        showTipDialog(@"请至少选择一个标签");
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    ChannelCollectionCell *cell = (ChannelCollectionCell *)[_collectionMain cellForItemAtIndexPath:indexPath];
    cell.model.editable = NO;
    cell.model.tagType = OtherChannel;
    cell.model.selected = NO;
    cell.btnDel.hidden = YES;
    cell.addImgv.hidden = NO;
    [_collectionMain reloadItemsAtIndexPaths:@[indexPath]];
    
    id object = _selectedTags[indexPath.item];
    [_selectedTags removeObjectAtIndex:indexPath.item];
    [_otherTags insertObject:object atIndex:0];
    NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
    [_collectionMain moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    [self refreshDelBtnsTag];
}

/** 刷新删除按钮的tag */
- (void)refreshDelBtnsTag{
    
    for (ChannelCollectionCell *cell in _collectionMain.visibleCells) {
        NSIndexPath *indexpath = [_collectionMain indexPathForCell:cell];
        cell.btnDel.tag = indexpath.item;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


//标签列表
- (void)loadInterestSignData{
    WeakSelf
    [HKHttpTool POST:@"/home/interest" parameters:nil success:^(id responseObject) {
        if (HKReponseOK) {
            _selectedTagStringArray = [TagModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"class_list"][@"selected_class"]];
            _otherTagStringArray = [TagModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"class_list"][@"not_selected_class"]];
            
            __block NSMutableString *tag = [NSMutableString new];
            __block NSInteger count = _selectedTagStringArray.count;
            [_selectedTagStringArray enumerateObjectsUsingBlock:^(TagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!isEmpty(obj.class_id)) {
                    NSString *temp = [NSString stringWithFormat:@"%@,",obj.class_id];
                    if (count-1 == idx) {
                        //最后一个不带隔开 标点符号 （,）
                        temp = obj.class_id;
                    }
                    [tag appendString:temp];
                }
            }];
            
            weakSelf.selectedTagString = tag;
            
            
            //将StringArray转为ChannelArray
            [weakSelf initTags];
            //初始化界面
            [weakSelf setupViews];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 将学习兴趣保存后台
- (void)saveStudyTagToServer:(NSArray<TagModel*>*)arr {
    
    __block NSMutableString *tag = [NSMutableString new];
    __block NSInteger count = arr.count;
    [arr enumerateObjectsUsingBlock:^(TagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!isEmpty(obj.class_id)) {
            NSString *temp = [NSString stringWithFormat:@"%@,",obj.class_id];
            if (count-1 == idx) {
                //最后一个不带隔开 标点符号 （,）
                temp = obj.class_id;
            }
            [tag appendString:temp];
        }
    }];
    
    //class *用户选择的分类，多个分类用英文, 隔开
    // v2.11 之前版本
    //NSDictionary *dict = @{@"class":tag};
    
    // v2.11
    
    if ([tag isEqualToString:self.selectedTagString] || tag.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSDictionary *dict = @{@"intentions":tag};
    [HKHttpTool POST:HOME_ADD_INTEREST baseUrl:BaseUrl parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            NSLog(@"%@",responseObject);
            int business_code = [responseObject[@"data"][@"business_code"] intValue];
            if (business_code == 200) {
                // 成功登录
                HK_NOTIFICATION_POST_DICT(@"chooseSignTags", nil, nil);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
