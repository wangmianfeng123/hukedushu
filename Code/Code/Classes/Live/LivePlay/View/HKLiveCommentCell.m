//
//  HKLiveCommentCell.m
//  Code
//
//  Created by Ivan li on 2020/12/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKLiveCommentCell.h"
#import "HKLiveCommentModel.h"
#import "UIView+HKLayer.h"
#import "UIButton+HKExtension.h"
#import "UILabel+Helper.h"
#import "ACActionSheet.h"
#import "HKPhotoBrowserTool.h"

@interface HKLiveCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *imgBgV;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImgV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBgVTopMagin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBgVH;
@property (nonatomic , strong) NSMutableArray * urlArray;
@end

@implementation HKLiveCommentCell

-(NSMutableArray *)urlArray{
    if (_urlArray == nil) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.nameLabel.textColor = COLOR_27323F_EFEFF6;
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
    self.contentLabel.textColor = COLOR_27323F_A8ABBE;
    self.lineView.backgroundColor =COLOR_EFEFF6_7B8196;
    
    [self.headerImgV addCornerRadius:20.0];
    
    [UILabel changeLineSpaceForLabel:self.contentLabel WithSpace:3];
    //[UILabel changeWordSpaceForLabel:self.contentLabel WithSpace:2];
    
    self.headerImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.headerImgV addGestureRecognizer:tap];
}

- (void)tapClick{
    if ([self.delegate respondsToSelector:@selector(liveCommentCellDidHeaderImg:)]) {
        [self.delegate liveCommentCellDidHeaderImg:self.commentModel];
    }
}


-(void)setCommentModel:(HKLiveCommentModel *)commentModel{
    _commentModel = commentModel;
    //设置约束
    if (_commentModel.commentImages.count) {
        self.imgBgVTopMagin.constant = 10;
        self.imgBgVH.constant = 110;
        self.imgBgV.hidden = NO;
    }else{
        self.imgBgVTopMagin.constant = 0;
        self.imgBgVH.constant = 0;
        self.imgBgV.hidden = YES;
    }
    
    [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:commentModel.avator] placeholderImage:imageName(HK_Placeholder)];
    self.nameLabel.text = commentModel.username;
    self.timeLabel.text = commentModel.createdAt;
    self.contentLabel.text = commentModel.content;
    
    [self.imgBgV removeAllSubviews];
    [self.urlArray removeAllObjects];
    for (int i = 0;  i < _commentModel.commentImages.count; i ++ ) {
        HKCommentImageModel * imgM = _commentModel.commentImages[i];
        [self.urlArray addObject:imgM.image_address];
        if (i<2) {
            CGFloat W = 142;
            CGFloat H = 110 ;
            
            UIImageView * imageV = [[UIImageView alloc] init];
            imageV.backgroundColor = [UIColor brownColor];
            imageV.frame = CGRectMake( i * (W + 10), 0, W, H);
            imageV.tag = i + 1;
            [imageV addCornerRadius:3];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.userInteractionEnabled = YES;
            [imageV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:imgM.image_address]] placeholderImage:imageName(HK_Placeholder)];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTapClick:)];
            [imageV addGestureRecognizer:tap];
            [self.imgBgV addSubview:imageV];
            if (i == 1 && _commentModel.commentImages.count>2) {
                UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(CGRectGetMaxX(imageV.frame)-70, CGRectGetMaxY(imageV.frame)-32, 60, 22);
                [btn setTitle:[NSString stringWithFormat:@"%lu张图片",(unsigned long)_commentModel.commentImages.count] forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(moreImgClick) forControlEvents:UIControlEventTouchUpInside];
                [btn addCornerRadius:11];
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                [self.imgBgV addSubview:btn];
            }
        }        
    }
    
    [self.starView removeAllSubviews];
    for (int i = 0; i < 5; i++) {
        CGFloat W = 15;
        
        UIImageView * imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake( i * (W + 2.5), 0, W, W);
        int score = [commentModel.score intValue];
        if (i + 1 <= score) {
            imageV.image = [UIImage imageNamed:@"ic_live_comment_2_30"];
        }else{
            imageV.image = [UIImage imageNamed:@"ic_live_no comment_2_30"];
        }
        
        [self.starView addSubview:imageV];
    }
    
    //显示删除按钮
    self.deleteBtnLeftMargin.constant = [commentModel.canDelete intValue] ? 25 : 0.0;
    self.deleteBtnW.constant = [commentModel.canDelete intValue] ? 25 : 0.0 ;
    
    [self.zanBtn setImage:[commentModel.commentPraise intValue]?[UIImage imageNamed:@"ic_live_click_2_30"] : [UIImage imageNamed:@"ic_live_no Click_2_30"] forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:[commentModel.commentPraise intValue] ? [UIColor colorWithHexString:@"FFB205"] : [UIColor colorWithHexString:@"#A8ABBE"] forState:UIControlStateNormal];
    if ([_commentModel.praiseCount isEqualToString:@"0"]) {
        [self.zanBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.zanBtn setTitle:_commentModel.praiseCount forState:UIControlStateNormal];
    }
    self.vipImgV.image = [HKvipImage comment_vipImageWithType:[NSString stringWithFormat:@"%@",_commentModel.vipType]];
}

- (void)moreImgClick{
    
    [HKPhotoBrowserTool initPhotoBrowserWithUrlArray:self.urlArray withIndex:1 delegate:self];
}

- (void)imgTapClick:(UITapGestureRecognizer *)tap{
    [HKPhotoBrowserTool initPhotoBrowserWithUrlArray:self.urlArray withIndex:tap.view.tag-1 delegate:self];
}

- (IBAction)zanBtnClick {
    if ([_commentModel.commentPraise intValue] == 0) {
        [self.zanBtn buttonCommitAnimationWithAnimateDuration:0.05 Completion:^{
            _commentModel.praiseCount = [NSString stringWithFormat:@"%d",[_commentModel.praiseCount intValue] + 1];
            [self.zanBtn setImage:[UIImage imageNamed:@"ic_live_click_2_30"] forState:UIControlStateNormal];
            [self.zanBtn setTitleColor:[UIColor colorWithHexString:@"FFB205"] forState:UIControlStateNormal];
            [self.zanBtn setTitle:_commentModel.praiseCount forState:UIControlStateNormal];
        }];
        if ([self.delegate respondsToSelector:@selector(liveCommentCellDidZanBtn:)]) {
            [self.delegate liveCommentCellDidZanBtn:self.commentModel];
        }
    }
}

- (IBAction)deleteBtnClick {    
    NSArray *titleArr =  @[@"删除",@"取消"];
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {

       if (0 == buttonIndex) {
           
           if ([self.delegate respondsToSelector:@selector(liveCommentCellDidDeleteBtn:)]) {
               [self.delegate liveCommentCellDidDeleteBtn:self.commentModel];
           }
       }
    }];
    [actionSheet show];
}
@end
