//
//  HKBookCommentActionCell.m
//  Code
//
//  Created by Ivan li on 2019/8/28.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookCommentActionCell.h"
#import "HKBookCommentModel.h"
#import "ACActionSheet.h"


@interface HKBookCommentActionCell()

@property (nonatomic, strong)UIButton *commentBtn;

@property (nonatomic, strong)UIButton *moreBtn;

@property (nonatomic, strong)UIView *lineView;

@end

@implementation HKBookCommentActionCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    [self.contentView addSubview:self.commentBtn];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.lineView];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);//.offset(15);
        make.right.equalTo(self.moreBtn.mas_left).offset(-30);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentBtn);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-1);
        make.height.mas_equalTo(1);
    }];
}



- (UIView*)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.hidden = YES;
        _lineView.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _lineView;
}


- (UIButton*)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:imageName(@"comment_bubble_gray") forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_commentBtn setEnlargeEdgeWithTop:15 right:10 bottom:10 left:30];
    }
    return _commentBtn;
}



- (UIButton*)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:imageName(@"point_gray") forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setEnlargeEdgeWithTop:15 right:25 bottom:10 left:20];
    }
    return _moreBtn;
}


- (void)commentBtnClick:(UIButton*)btn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hkBookCommentActionCell:commentBtn:)]) {
        [self.delegate hkBookCommentActionCell:self commentBtn:btn];
    }
}


- (void)moreBtnClick:(UIButton*)btn {
    
    @weakify(self);
    NSArray *titleArr =  @[([self.model.uid isEqualToString:[CommonFunction getUserId]] ? @"删除" :@"举报"),@"取消"];
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {
        @strongify(self);
        if (0 == buttonIndex) {
            
                if ([self.model.uid isEqualToString:[CommonFunction getUserId]]) {
                    //删除评论
                    if (self.delegate && [self.delegate respondsToSelector:@selector(hkBookCommentActionCell:deleteAction:)]) {
                        [self.delegate hkBookCommentActionCell:self deleteAction:btn];
                    }
                }else{
                    //举报
                    if (self.delegate && [self.delegate respondsToSelector:@selector(hkBookCommentActionCell:complainAction:)]) {
                        [self.delegate hkBookCommentActionCell:self complainAction:btn];
                    }
                }
        }
    }];
    [actionSheet show];
}


- (void)setModel:(HKBookCommentModel *)model {
    _model = model;
    self.lineView.hidden = model.isHiddenBottomLine;
}


-(void)bindViewModel:(HKBookActionModel *)viewModel {
    self.model = viewModel.model;
}

@end
