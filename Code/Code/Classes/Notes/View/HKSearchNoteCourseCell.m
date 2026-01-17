//
//  HKSearchNoteCourseCell.m
//  Code
//
//  Created by Ivan li on 2020/12/30.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKSearchNoteCourseCell.h"
#import "UIView+HKLayer.h"
#import "HKNotesListModel.h"

@interface HKSearchNoteCourseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation HKSearchNoteCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.descLabel.textColor = COLOR_A8ABBE_7B8196;
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
    [self.leftImgV addCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNoteVideoModel:(HKNotesVideoModel *)noteVideoModel{
    _noteVideoModel = noteVideoModel;
    
    [self.leftImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:noteVideoModel.cover]] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
    self.titleLabel.text = noteVideoModel.title;
    self.descLabel.text = [NSString stringWithFormat:@"共%@条笔记",noteVideoModel.number];
}

@end
