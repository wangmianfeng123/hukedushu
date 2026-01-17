//
//  CommentFootView.m
//  Code
//
//  Created by Ivan li on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "CommentFootView.h"
#import "NewCommentModel.h"
#import "SQActionSheetView.h"
#import "ACActionSheet.h"
#import "HKCommentModel.h"

@interface CommentFootView()

@property(nonatomic,strong)UIButton *praiseBtn;// 点赞

@property(nonatomic,strong)UIButton *commentBtn; // 回复

@property(nonatomic,strong)UIButton *moreBtn; // 举报

@property(nonatomic,strong)UILabel *bottomLineLabel; // 举报

@end


@implementation CommentFootView


- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.contentView addSubview:self.praiseBtn];
    [self.contentView addSubview:self.commentBtn];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.bottomLineLabel];
}

-(void)setIsHiddenMore:(BOOL)isHiddenMore{
    _isHiddenMore = isHiddenMore;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self makeConstraints];
}
- (void)makeConstraints {
    WeakSelf;
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        if (self.isHiddenMore) {
            make.width.mas_equalTo(0.0);
            weakSelf.moreBtn.hidden = YES;
        }else{
            make.width.mas_equalTo(PADDING_35);
            weakSelf.moreBtn.hidden = NO;
        }
        make.height.mas_equalTo(PADDING_30);
    }];
    
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf.moreBtn);
        make.right.equalTo(weakSelf.moreBtn.mas_left).offset(-15);
    }];
    
    [_praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf.moreBtn);
        make.right.equalTo(weakSelf.commentBtn.mas_left).offset(-PADDING_25);
    }];
    
    [_bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH - PADDING_20);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-0.5);
        make.right.equalTo(weakSelf.contentView.mas_right);
    }];
    [_praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-8, 0, 0)];
    //[_commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-8, 0, 0)];
    //[_praiseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-_praiseBtn.imageView.frame.size.width+PADDING_10, 0, -PADDING_10)];
    //[_commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-_praiseBtn.imageView.frame.size.width+PADDING_10, 0, -PADDING_10)];
}

- (UIButton*)praiseBtn {
    
    if (!_praiseBtn) {
        
        _praiseBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_FFB205
                                     titleFont:@"12" imageName:(@"praise_gray")];
        
        [_praiseBtn setTitleColor:COLOR_FFB205 forState:UIControlStateSelected];
        [_praiseBtn setTitleColor:COLOR_7B8196 forState:UIControlStateNormal];
        [_praiseBtn setImage:imageName(@"praise_red") forState:UIControlStateSelected];
        [_praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_praiseBtn setEnlargeEdgeWithTop:PADDING_20 right:5 bottom:PADDING_20 left:5];
    }
    return _praiseBtn;
}


- (UIButton*)commentBtn {
    
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333
                                     titleFont:@"12" imageName:(@"comment_bubble_gray")];
        [_commentBtn setImage:imageName(@"comment_bubble_gray") forState:UIControlStateSelected];
        [_commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [_commentBtn setEnlargeEdgeWithTop:PADDING_20 right:5 bottom:PADDING_20 left:5];
    }
    return _commentBtn;
}


- (UIButton*)moreBtn {
    
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333
                                     titleFont:@"12" imageName:(@"point_gray")];
        [_moreBtn setImage:imageName(@"point_gray") forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(complainAction:) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setEnlargeEdgeWithTop:PADDING_20 right:5 bottom:PADDING_20 left:5];
    }
    return _moreBtn;
}


- (UILabel*)bottomLineLabel {
    if (!_bottomLineLabel) {
        _bottomLineLabel = [UILabel new];
        _bottomLineLabel.backgroundColor = COLOR_F8F9FA_333D48;
        _bottomLineLabel.hidden = YES;
    }
    return _bottomLineLabel;
}



#pragma mark - 点赞 1-已赞   0-未赞
- (void)praiseAction:(id)sender {
    [MobClick event: UM_RECORD_VIDEO_DETAIL_LIKE];
    if ([self.delegate respondsToSelector:@selector(praiseAction:model:)]) {
        [self.delegate praiseAction:self.section model:self.model];
        if ([_model.is_like isEqualToString:@"0"]) {
            [UIView animateWithDuration:.6 animations:^{
                _praiseBtn.transform = CGAffineTransformMakeScale(1.5, 1.5);//放大
            } completion:^(BOOL finished) {
                _praiseBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);//还原
            }];
        }
    }
}

#pragma mark - 评论
- (void)commentAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(commentAction:model:)]) {
        [self.delegate commentAction:_section model:_model];
    }
}


- (void)complainAction:(id)sender {
    WeakSelf;
    __block NSInteger section = self.section;
    __block NewCommentModel *model = self.model;
    
    NSArray *titleArr =  @[([model.uid isEqualToString:[CommonFunction getUserId]] ? @"删除" :@"举报"),@"取消"];
    
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {

               if (0 == buttonIndex) {
                   //举报
                   if ([weakSelf.delegate respondsToSelector:@selector(complainAction:model: sender:)]) {
                       if ([model.uid isEqualToString:[CommonFunction getUserId]]) {
                           //删除评论
                           [weakSelf.delegate deleteCommentAction:section model:model];
                       }else{
                           [weakSelf.delegate complainAction:section model:model sender:nil];
                       }
                   }
               }else{
                   //取消
               }
    }];
    [actionSheet show];
}



- (void)setModel:(NewCommentModel *)model {
    _model = model;
    if ([model.is_like isEqualToString:@"1"]) {
        // is_like  - 1 已点赞   0未点赞
        _praiseBtn.selected = YES;
    }else{
        _praiseBtn.selected = NO;
    }
    if ([model.thumbs intValue] >0) {
        [_praiseBtn setTitle:model.thumbs forState:UIControlStateNormal];
    }else{
        [_praiseBtn setTitle:@"" forState:UIControlStateNormal];
    }
    _bottomLineLabel.hidden = self.isHiddenLine;
}

-(void)setMainCommentModel:(HKCommentModel *)mainCommentModel{
    _mainCommentModel = mainCommentModel;
    if (mainCommentModel.isLiked == 1) {
        // is_like  - 1 已点赞   0未点赞
        _praiseBtn.selected = YES;
    }else{
        _praiseBtn.selected = NO;
    }
    if ([mainCommentModel.likes_count intValue] >0) {
        [_praiseBtn setTitle:[NSString stringWithFormat:@"%@",mainCommentModel.likes_count] forState:UIControlStateNormal];
    }else{
        [_praiseBtn setTitle:@"" forState:UIControlStateNormal];
    }
    _bottomLineLabel.hidden = self.isHiddenLine;
}


@end











