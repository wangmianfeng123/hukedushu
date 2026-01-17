//
//  HKPlayViewNoteCell.m
//  Code
//
//  Created by Ivan li on 2021/1/6.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPlayViewNoteCell.h"
#import "HKNotesListModel.h"
#import "UIButton+HKExtension.h"
#import "UIView+HKLayer.h"
#import "NSAttributedString+YYText.h"
//#import "YYImage.h"
#import <YYImage/YYImage.h>

@interface HKPlayViewNoteCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *unFoldBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unFlodBtnHeight;

@end

@implementation HKPlayViewNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];

    [self.timeBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    [self.timeBtn setTitleColor:COLOR_FFFFFF_333D48 forState:UIControlStateNormal];
    [self.avatorImgV addCornerRadius:15];
    self.lineView.backgroundColor = COLOR_7B8196_A8ABBE;
    self.contentLabel.textColor = COLOR_FFFFFF_333D48;
    [self.unFoldBtn setTitleColor:COLOR_A8ABBE_27323F forState:UIControlStateNormal];
    [self.zanBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];

}

-(void)setNoteModel:(HKNotesModel *)noteModel{    
    _noteModel = noteModel;
    [self.timeBtn setTitle:noteModel.point_of_time forState:UIControlStateNormal];
    self.contentLabel.text = noteModel.notes;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    
    [self.zanBtn setImage:[noteModel.liked intValue]?[UIImage imageNamed:@"praise_red"] : [UIImage imageNamed:@"ic_good_notes_video_2_30"] forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:[noteModel.liked intValue] ? [UIColor colorWithHexString:@"FFB205"] : [UIColor colorWithHexString:@"#A8ABBE"] forState:UIControlStateNormal];
    if ([noteModel.likes_count isEqualToString:@"0"]) {
        [self.zanBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.zanBtn setTitle:noteModel.likes_count forState:UIControlStateNormal];
    }

    self.nameLabel.text = noteModel.username;
    [self.avatorImgV sd_setImageWithURL:[NSURL URLWithString:noteModel.avatar] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
    
    if (noteModel.contentHeight >63) {
        self.unFlodBtnHeight.constant = 25;
        self.unFoldBtn.hidden = NO;
        self.contentLabel.numberOfLines = noteModel.unfold ? 0 : 3;
        if (noteModel.unfold) { //展开
            self.contentLabel.numberOfLines = 0;
            [self.unFoldBtn setTitle:@"收起" forState:UIControlStateNormal];
            [self.unFoldBtn setImage:[UIImage imageNamed:@"up_2.30"] forState:UIControlStateNormal];
            noteModel.cellHeight = 55 + noteModel.contentHeight + 25 + 40;
        }else{
            self.contentLabel.numberOfLines = 3;
            [self.unFoldBtn setTitle:@"展开" forState:UIControlStateNormal];
            [self.unFoldBtn setImage:[UIImage imageNamed:@"down_2.30"] forState:UIControlStateNormal];
            noteModel.cellHeight = 55 + 62 + 25 + 40;
        }
    }else{
        self.contentLabel.numberOfLines = 3;
        self.unFlodBtnHeight.constant = 0;
        self.unFoldBtn.hidden = YES;
        noteModel.cellHeight = 55 + noteModel.contentHeight + 40;
    }
    [self.unFoldBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:6];

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
            self.noteModel.liked = [NSNumber numberWithInt:1];
            [self.zanBtn setImage:[UIImage imageNamed:@"praise_red"] forState:UIControlStateNormal];
            [self.zanBtn setTitleColor:[UIColor colorWithHexString:@"FFB205"] forState:UIControlStateNormal];
            [self.zanBtn setTitle:self.noteModel.likes_count forState:UIControlStateNormal];
        }];
        if ([self.delegate respondsToSelector:@selector(notesListCellDidZanBtn:)]) {
            [self.delegate notesListCellDidZanBtn:self.noteModel];
        }
    }
}

- (IBAction)unFoldBtnClick {
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


-(void)layoutSubviews{
    [super layoutSubviews];

    // iOS 13 之后横竖屏切换的时候 self.contentView 会变化，有一个体验不好的效果
    self.contentView.frame = CGRectMake(0, 0, self.width, self.height);
    //[self updateConstraints];
    //[self layoutIfNeeded];
}
 
@end
