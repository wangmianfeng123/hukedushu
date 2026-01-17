//
//  HKCommentContentView.m
//  Code
//
//  Created by Ivan li on 2020/12/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCommentContentView.h"
#import "HKFeedbackView.h"
#import "UIView+HKLayer.h"
#import "HKCommentImgCell.h"
#import "HKImgModel.h"

@interface HKCommentContentView ()<UICollectionViewDelegate,UICollectionViewDataSource,HKFeedbackViewDelegate>
@property (nonatomic , strong) UIView * bgView;
@property (nonatomic , strong) UICollectionView * collectionView;
@property (nonatomic , strong) UILabel * countLabel;
@end

@implementation HKCommentContentView

- (HKFeedbackView*)feedBackView {
    if (!_feedBackView) {
        _feedBackView = [[HKFeedbackView alloc]init];
        _feedBackView.deletate = self;
        _feedBackView.commentType = HKCommentType_BookComment;
    }
    return _feedBackView;
}

-(UILabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel = [UILabel labelWithTitle:CGRectZero title:@"0/200" titleColor:[UIColor colorWithHexString:@"#BABDCE"] titleFont:@"12" titleAligment:NSTextAlignmentCenter];
    }
    return _countLabel;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGFloat w = (SCREEN_WIDTH -15 * 2 - 10 *2)/3.0;
        layout.itemSize = CGSizeMake(w, w);
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.collectionViewLayout = layout;
        _collectionView.showsVerticalScrollIndicator =  NO;
        _collectionView.showsHorizontalScrollIndicator =  NO;
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCommentImgCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKCommentImgCell class])];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)createView{
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.bgView addCornerRadius:5 addBoderWithColor:[UIColor colorWithHexString:@"#EFEFF6"] BoderWithWidth:1.0];
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.feedBackView];
    [self.bgView addSubview:self.countLabel];
    [self.bgView addSubview:self.collectionView];
    self.feedBackView.feedbackView.layer.borderColor = [UIColor clearColor].CGColor;
    self.feedBackView.pointLabel.text = @"写几句评价吧...(至少5个字哦）";
    
    
    [self makeConstraints];
}

- (void)makeConstraints{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.bottom.equalTo(self);
    }];
    
    [self.feedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.bgView).offset(-10);
        make.right.equalTo(self.bgView).offset(10);
//        make.left.right.equalTo(self.bgView);
        //make.height.mas_equalTo(IS_IPHONE6PLUS ?210:180);
        make.height.mas_equalTo(200);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedBackView.mas_bottom);
        make.right.equalTo(self.bgView).offset(-15);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countLabel.mas_bottom);
        make.left.equalTo(self.bgView).offset(10);
        make.right.equalTo(self.bgView).offset(-10);
        make.bottom.equalTo(self).offset(-10);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArray.count == 5) {
        return 5;
    }else{
        return self.dataArray.count + 1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    HKCommentImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCommentImgCell class]) forIndexPath:indexPath];
    if (self.dataArray.count == 5) {
        cell.imgV.image = self.dataArray[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }else{
        if (indexPath.row == self.dataArray.count) {
            cell.imgV.image = [UIImage imageNamed:@"ic_frame_2_30"];
            cell.deleteBtn.hidden = YES;
        }else{
            cell.imgV.image = self.dataArray[indexPath.row];
            cell.deleteBtn.hidden = NO;
        }
    }
    
    @weakify(self);
    cell.deleteBtnBlock = ^(UIImage * img) {
        @strongify(self);
        [self.dataArray removeObject:img];
        [self.collectionView reloadData];
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count) {
        //选图
        if ([self.delegate respondsToSelector:@selector(commentContentViewChooseImg)]) {
            [self.delegate commentContentViewChooseImg];
        }
    }else{
        //放大
        if (self.dataArray.count) {
            [HKPhotoBrowserTool initPhotoBrowserWithUrlArray:self.dataArray withIndex:indexPath.row delegate:self];
        }
    }
}

#pragma mark ==== HKFeedbackViewDelegate

-(void)textlength:(NSInteger)lenth{
    self.countLabel.text = [NSString stringWithFormat:@"%ld/200",lenth];
}
@end
