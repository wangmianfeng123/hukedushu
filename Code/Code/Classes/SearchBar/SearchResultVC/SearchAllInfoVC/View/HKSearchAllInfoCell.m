

//
//  HKSearchAllInfoCell.m
//  Code
//
//  Created by Ivan li on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKSearchAllInfoCell.h"
#import "HomeMyFollowVideoCell.h"
#import "UIButton+ImageTitleSpace.h"
#import "HKSearchCourseModel.h"
#import "UIView+HKLayer.h"

#define cellHeight 150


@interface HKSearchAllInfoCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic)  UICollectionView *contentCollectionView;
/** 教师目录 */
@property(nonatomic,strong)UILabel *categoryLb;
@property(nonatomic,strong)UILabel *signLabel;

/** 更多 按钮 */
@property (strong, nonatomic)  UIButton *moreBtn;
//直播中头像动画View
@property (nonatomic , strong) UIView * boderView;
@property (nonatomic , strong) UIView * pinkView;
@property (nonatomic , assign) BOOL isAnitaiton ;

@end

@implementation HKSearchAllInfoCell


- (void)createUI {
    [super createUI];
    //[self.contentView addSubview:self.contentCollectionView];
    [self.contentView addSubview:self.categoryLb];
    [self.contentView addSubview:self.moreBtn];
    self.iconImageView.layer.cornerRadius = 27.5;
    [self.contentView insertSubview:self.pinkView atIndex:0];
    [self.pinkView addCornerRadius:30];
    [self.contentView insertSubview:self.boderView atIndex:0];
    [self.boderView addCornerRadius:30 addBoderWithColor:[UIColor colorWithHexString:@"#FF4E4E"] BoderWithWidth:0.8];
    [self.contentView addSubview:self.signLabel];
}

- (void)zoomView {
    _isAnitaiton = YES;
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.boderView.transform = CGAffineTransformMakeScale(1.15, 1.15); // 边框放大
        self.boderView.alpha = 0.08; // 透明度渐变
    } completion:^(BOOL finished) {
        // 恢复默认
        self.boderView.transform = CGAffineTransformMakeScale(1, 1);
        self.boderView.alpha = 1;
        
        
        BOOL show = [self isDisplayedInScreen:self.boderView];
        if (show) {
            // 缩放动画
            [self zoomView];
        }else{
            _isAnitaiton = NO;
        }
        NSLog(@"-------%d",show);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
    if (!_isAnitaiton) {
        // 缩放动画
        [self zoomView];
    }
}

- (UIView *)boderView{
    if (_boderView == nil) {
        _boderView = [[UIView alloc] init];
        _boderView.hidden = YES;
    }
    return _boderView;
}

- (UIView *)pinkView{
    if (_pinkView == nil) {
        _pinkView = [[UIView alloc] init];
        _pinkView.backgroundColor = [UIColor colorWithHexString:@"FF4E4E"];
        _pinkView.hidden = YES;
    }
    return _pinkView;
}

- (void)makeConstraints {
    
    [self.categoryLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(PADDING_15);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryLb.mas_bottom).offset(PADDING_15);
        make.left.equalTo(self.contentView.mas_left).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    [self.pinkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.iconImageView).offset(-2.5);
        make.bottom.right.equalTo(self.iconImageView).offset(2.5);
    }];
    
    [self.boderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.iconImageView).offset(-2.5);
        make.bottom.right.equalTo(self.iconImageView).offset(2.5);
    }];
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 16));
        make.bottom.equalTo(self.iconImageView).offset(8);
        make.centerX.equalTo(self.iconImageView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_15);
        make.top.equalTo(self.iconImageView.mas_top).offset(7);
        make.right.equalTo(self.focusBtn.mas_left).offset(-PADDING_5);
    }];
    
    [self.fanCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
    }];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fanCountLabel.mas_centerY);
        make.left.equalTo(self.fanCountLabel.mas_right).offset(PADDING_10);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(1);
    }];
    
    [self.videoCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineLabel.mas_right).offset(PADDING_10);
        make.top.height.equalTo(self.fanCountLabel);
    }];
    
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING_15);
        make.size.mas_equalTo(CGSizeMake(PADDING_30*2, PADDING_25));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.centerY.equalTo(self.categoryLb);
    }];
}





- (UILabel*)categoryLb {
    if (!_categoryLb) {
        _categoryLb  = [UILabel labelWithTitle:CGRectZero title:@"讲师"
                                    titleColor:COLOR_27323F_EFEFF6
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _categoryLb.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
    }
    return _categoryLb;
}

- (UILabel*)signLabel{
    if (!_signLabel) {
        _signLabel  = [UILabel labelWithTitle:CGRectZero title:@"直播中"
                                    titleColor:[UIColor whiteColor]
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentCenter];
        _signLabel.font = [UIFont systemFontOfSize:9];
        _signLabel.backgroundColor = [UIColor colorWithHexString:@"#FF4E4E"];
        [_signLabel addCornerRadius:8 addBoderWithColor:[UIColor whiteColor] BoderWithWidth:0.5];
        _signLabel.hidden = YES;
    }
    return _signLabel;
}


- (UIButton*)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = HK_FONT_SYSTEM(13);
        
        [_moreBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        [_moreBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateHighlighted];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setHKEnlargeEdge:20];
        _moreBtn.hidden = YES;
    }
    return _moreBtn;
}


- (void)moreBtnClick:(UIButton*)btn {
    
    if (self.moreBtnClickBackCall) {
        self.moreBtnClickBackCall();
    }
}


- (void)setUserInfo:(HKUserModel *)userInfo {
    [super setUserInfo:userInfo];
}



- (void)setMatchModel:(HKFirstMatchModel *)matchModel {
    _matchModel = matchModel;
    
    if (!isEmpty(matchModel.name)) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:matchModel.avator] placeholderImage:imageName(HK_Placeholder)];
        self.titleLabel.text = [NSString stringWithFormat:@"%@",matchModel.name];
        self.fanCountLabel.text = [NSString stringWithFormat:@"粉丝: %@",matchModel.follow];
        self.videoCountLabel.text = [NSString stringWithFormat:@"教程: %@",matchModel.curriculum_num];
        //is_follow:1-已关注讲师 0-未关注
        self.focusBtn.selected = matchModel.is_follow;
        [self setFocusBtnStyle:self.focusBtn isFollow:matchModel.is_follow];
    }
    
    if (_matchModel.is_live == 1) {
        self.boderView.hidden = NO;
        self.pinkView.hidden = NO;
        self.signLabel.hidden = NO;
        // 缩放动画
        [self zoomView];
    }else{
        self.boderView.hidden = YES;
        self.pinkView.hidden = YES;
        self.signLabel.hidden = YES;
    }
}


- (void)setTeacherMatchModel:(HKTeacherMatchModel *)teacherMatchModel {
    
    _teacherMatchModel = teacherMatchModel;
    if (teacherMatchModel.match_count >1) {
        NSString *title = [NSString stringWithFormat:@"查看%ld条结果",teacherMatchModel.match_count];
        [self.moreBtn setTitle:title forState:UIControlStateNormal];
        [self.moreBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:3];
        self.moreBtn.hidden = NO;
    }
    
    
}


#pragma mark - 关注／取消关注  老师
- (void)followTeacherToServer:(UIButton*)btn{
    __block UIButton *tempBtn = btn;
    WeakSelf;
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    //type ---当前的关注状态, 1已关注，0未关注
    [mange followTeacherVideoWithToken:nil teacherId:self.matchModel.ID type:((self.matchModel.is_follow)? @"1":@"0")completion:^(FWServiceResponse *response) {
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            [MobClick event:UM_RECORD_DETAIL_CONCERN];
            tempBtn.selected = !tempBtn.selected;
            
            weakSelf.matchModel.is_follow = !weakSelf.matchModel.is_follow;
            [weakSelf setFocusBtnStyle:tempBtn isFollow:weakSelf.matchModel.is_follow];
            showTipDialog(weakSelf.matchModel.is_follow ? @"关注成功" : @"取消关注");
        }
    } failBlock:^(NSError *error) {
        
    }];
}




- (UICollectionView*)contentCollectionView {
    if (!_contentCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 5;
        //layout.itemSize = CGSizeMake(200, self.contentCollectionView.frame.size.height);
        layout.itemSize = CGSizeMake(200, cellHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        [_contentCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeMyFollowVideoCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HomeMyFollowVideoCell class])];
    }
    return _contentCollectionView;
}



#pragma mark <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
    //return self.userInfo.video_list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeMyFollowVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeMyFollowVideoCell class]) forIndexPath:indexPath];
    cell.model = self.userInfo.video_list[indexPath.row];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //return CGSizeMake(200, self.contentCollectionView.frame.size.height);
    return CGSizeMake(200, cellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !self.homeMyFollowVideoSelectedBlock? : self.homeMyFollowVideoSelectedBlock(indexPath, self.userInfo.video_list[indexPath.row]);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen:(UIView *)subV
{
    if (subV == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [subV convertRect:subV.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (subV.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (subV.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return TRUE;
    }
    return FALSE;
    
}
@end




