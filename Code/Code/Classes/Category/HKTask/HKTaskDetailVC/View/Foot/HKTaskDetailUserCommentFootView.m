
//
//  HKTaskDetailUserCommentFootView.m
//  Code
//
//  Created by Ivan li on 2018/7/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskDetailUserCommentFootView.h"
#import "HKTaskModel.h"
#import "SQActionSheetView.h"
#import "ACActionSheet.h"

@interface HKTaskDetailUserCommentFootView()

@property(nonatomic,strong)UIButton *commentBtn; // 回复

@property(nonatomic,strong)UIButton *moreBtn; // 举报

@property(nonatomic,strong)UILabel *bottomLineLabel; // 举报


@end


@implementation HKTaskDetailUserCommentFootView


- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.contentView.backgroundColor =  [UIColor whiteColor];
    [self.contentView addSubview:self.commentBtn];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.bottomLineLabel];
    [self makeConstraints];
}


- (void)makeConstraints {
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.bottom.equalTo(self.contentView).offset(-PADDING_15);
    }];
    
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.moreBtn);
        make.right.equalTo(self.moreBtn.mas_left).offset(-PADDING_30);
    }];
    
    [_bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(SCREEN_WIDTH - PADDING_15);
        make.bottom.equalTo(self.contentView).offset(-1);
        make.right.equalTo(self.contentView);
    }];
    
}


- (UIButton*)commentBtn {
    
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333
                                      titleFont:@"12" imageName:(@"task_comment_bubble")];
        [_commentBtn setImage:imageName(@"task_comment_bubble") forState:UIControlStateSelected];
        [_commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [_commentBtn setEnlargeEdgeWithTop:PADDING_15 right:PADDING_10 bottom:PADDING_15 left:PADDING_10];
    }
    return _commentBtn;
}


- (UIButton*)moreBtn {
    
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333
                                   titleFont:@"12" imageName:(@"point_gray")];
        [_moreBtn setImage:imageName(@"point_gray") forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(complainAction:) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setEnlargeEdgeWithTop:PADDING_15 right:PADDING_10 bottom:PADDING_15 left:PADDING_10];
    }
    return _moreBtn;
}


- (UILabel*)bottomLineLabel {
    if (!_bottomLineLabel) {
        _bottomLineLabel = [UILabel new];
        _bottomLineLabel.backgroundColor = COLOR_F8F9FA;
        //_bottomLineLabel.hidden = YES;
    }
    return _bottomLineLabel;
}



#pragma mark - 评论
- (void)commentAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(commentAction:model:)]) {
        [self.delegate commentAction:self.section model:self.model];
    }
}


- (void)complainAction:(id)sender {
    WeakSelf;
    __block NSInteger section = self.section;
    __block HKTaskModel *model = self.model;
    
    //NSArray *titleArr =  @[([model.uid isEqualToString:[CommonFunction getUserId]] ? @"删除" :@"举报"),@"取消"];
    NSArray *titleArr =  @[@"举报",@"取消"];
    
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {
        
        StrongSelf;
        if (0 == buttonIndex) {
            //举报
            if ([strongSelf.delegate respondsToSelector:@selector(complainAction:model: sender:)]) {
                
                [strongSelf.delegate complainAction:section model:model sender:nil];
//                if ([model.uid isEqualToString:[CommonFunction getUserId]]) {
//                    //删除评论
//                    [weakSelf.delegate deleteCommentAction:section model:model];
//                }else{
//                    [weakSelf.delegate complainAction:section model:model sender:nil];
//                }
            }
        }else{
            //取消
        }
    }];
    [actionSheet show];
}



- (void)setModel:(HKTaskModel *)model {
    _model = model;
}


@end











