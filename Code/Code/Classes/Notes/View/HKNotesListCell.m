//
//  HKNotesListCell.m
//  Code
//
//  Created by Ivan li on 2021/1/4.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKNotesListCell.h"
#import "HKNotesListModel.h"
#import "UIView+HKLayer.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import "UIButton+HKExtension.h"


@interface HKNotesListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yyLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVHeight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewTopMargin;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unFlodBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelTopMargin;
@property (weak, nonatomic) IBOutlet UIButton *unFoldBtn;

@end

@implementation HKNotesListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.imgV addCornerRadius:5];
    
    //self.contentLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.75];
    //[self.contentView addCornerRadius:10];
    self.contentView.backgroundColor = COLOR_FFFFFF_333D48;
    self.shadowView.backgroundColor = COLOR_FFFFFF_333D48;
    [self.shadowView addShadowCornerRadius:10 shadowOffset:CGSizeZero shadowRadius:3];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick)];
    [self.imgV addGestureRecognizer:tap];
    
    [self.timeBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    [self.timeBtn setBackgroundColor:COLOR_F8F9FA_333D48];
    [self.timeBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    [self.timeBtn addCornerRadius:10];
    [self.timeBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
    
    self.contentLabel.textColor = COLOR_27323F_EFEFF6;
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
    [self.unFoldBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
}

-(void)setNoteModel:(HKNotesModel *)noteModel{
    _noteModel = noteModel;
    self.imgV.hidden = _noteModel.screenshot.length ? NO : YES;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:noteModel.screenshot]] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
    [self.timeBtn setTitle:noteModel.point_of_time forState:UIControlStateNormal];
    
    self.contentLabel.text = noteModel.notes;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    
    
    
    [self.zanBtn setImage:[noteModel.liked intValue]?[UIImage imageNamed:@"praise_red"] : [UIImage imageNamed:@"ic_good_nor_notes_2_30"] forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:[noteModel.liked intValue] ? [UIColor colorWithHexString:@"FFB205"] : COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    if ([noteModel.likes_count isEqualToString:@"0"]) {
        [self.zanBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.zanBtn setTitle:noteModel.likes_count forState:UIControlStateNormal];
    }
    
    self.imgVHeight.constant = noteModel.imgH == 0 ? 0.1 : noteModel.imgH;
    self.contentLabelTopMargin.constant = noteModel.screenshot.length ? 10 : 0;
    if (self.noteModel.contentHeight > 60) {
        self.unFlodBtnHeight.constant = 25;
        self.unFoldBtn.hidden = NO;
        self.contentLabel.numberOfLines = noteModel.unfold ? 0 : 3;
        
        if (noteModel.unfold) { //展开
            self.contentLabel.numberOfLines = 0;
            [self.unFoldBtn setTitle:@"收起" forState:UIControlStateNormal];
            [self.unFoldBtn setImage:[UIImage imageNamed:@"up_2.30"] forState:UIControlStateNormal];
        }else{
            self.contentLabel.numberOfLines = 3;
            [self.unFoldBtn setTitle:@"展开" forState:UIControlStateNormal];
            [self.unFoldBtn setImage:[UIImage imageNamed:@"down_2.30"] forState:UIControlStateNormal];
        }
    }else{
        self.contentLabel.numberOfLines = 3;
        self.unFlodBtnHeight.constant = 0;
        self.unFoldBtn.hidden = YES;
    }
    [self.unFoldBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:6];
    //NSString * time =   [DateChange DateFromNetWorkString:noteModel.created_at];
    //NSLog(@"----");
    self.timeLabel.text = noteModel.created_at;
}

- (IBAction)unFoldBtnClick:(UIButton *)sender {
    self.noteModel.unfold = !self.noteModel.unfold;
    if (self.noteModel.unfold) { //展开
        self.contentLabel.numberOfLines = 0;
        [self.unFoldBtn setTitle:@"收起" forState:UIControlStateNormal];
        [self.unFoldBtn setImage:[UIImage imageNamed:@"up_2.30"] forState:UIControlStateNormal];
    }else{
        self.contentLabel.numberOfLines = 0;
        [self.unFoldBtn setTitle:@"展开" forState:UIControlStateNormal];
        [self.unFoldBtn setImage:[UIImage imageNamed:@"down_2.30"] forState:UIControlStateNormal];
    }
    if (self.didOpenBlock) {
        self.didOpenBlock();
    }
}

- (IBAction)timeBtnClick {
    if ([self.delegate respondsToSelector:@selector(notesListCellDidTimeBtn:)]) {
        [self.delegate notesListCellDidTimeBtn:self.noteModel];
    }
}

- (IBAction)zanBtnClick {
    if ([self.noteModel.liked intValue] == 0) {
        [self.zanBtn buttonCommitAnimationWithAnimateDuration:0.05 Completion:^{
            self.noteModel.likes_count = [NSString stringWithFormat:@"%d",[self.noteModel.likes_count intValue] + 1];
            [self.zanBtn setImage:[UIImage imageNamed:@"praise_red"] forState:UIControlStateNormal];
            [self.zanBtn setTitleColor:[UIColor colorWithHexString:@"FFB205"] forState:UIControlStateNormal];
            [self.zanBtn setTitle:self.noteModel.likes_count forState:UIControlStateNormal];
        }];
        if ([self.delegate respondsToSelector:@selector(notesListCellDidZanBtn:)]) {
            [self.delegate notesListCellDidZanBtn:self.noteModel];
        }
    }
}

- (IBAction)moreBtnClick {
    if ([self.delegate respondsToSelector:@selector(notesListCellDidMoreBtn:)]) {
        [self.delegate notesListCellDidMoreBtn:self.noteModel];
    }
}

- (void)imgTapClick{
    if ([self.delegate respondsToSelector:@selector(notesListCellDidImgV:)]) {
        [self.delegate notesListCellDidImgV:self.noteModel];
    }
}

@end
