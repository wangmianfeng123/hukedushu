//
//  HKArticleDetailCommentCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/8/7.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleDetailCommentCell.h"
#import "ACActionSheet.h"

@interface HKArticleDetailCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatorIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIImageView *vipTypeIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UIView *sepLineView;
@end

@implementation HKArticleDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 圆角
    self.avatorIV.clipsToBounds = YES;
    self.avatorIV.layer.cornerRadius = 20.0;
    self.vipTypeIV.clipsToBounds = YES;
    self.vipTypeIV.layer.cornerRadius = 9.0;
    [self hkDarkModel];
}

- (void)hkDarkModel {
    self.nameLB.textColor = COLOR_27323F_EFEFF6;
    self.timeLB.textColor = COLOR_A8ABBE_7B8196;
    self.contentLB.textColor = COLOR_27323F_EFEFF6;
    self.sepLineView.backgroundColor = COLOR_F8F9FA_333D48;
    
}

- (void)setModel:(HKArticleCommentModel *)model {
    _model = model;
    
    [self.avatorIV sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    self.nameLB.text = model.name;
    self.vipTypeIV.image = [HKvipImage comment_vipImageWithType:model.vipType];
    self.timeLB.text = model.timeString;
    self.contentLB.text = model.content;
    
}

- (IBAction)moreBtnClick:(id)sender {
    
    WeakSelf;
    __block HKArticleCommentModel *model = self.model;
    
    NSArray *titleArr =  @[([model.uid isEqualToString:[CommonFunction getUserId]] ? @"删除" :@"举报"),@"取消"];
    
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {
        
        if (0 == buttonIndex) {
            //举报
            if ([weakSelf.delegate respondsToSelector:@selector(complainAction:model: sender:)]) {
                if ([model.uid isEqualToString:[CommonFunction getUserId]]) {
                    //删除评论
                    [weakSelf.delegate deleteCommentAction:0 model:model];
                }else{
                    [weakSelf.delegate complainAction:0 model:model sender:nil];
                }
            }
        }else{
            //取消
        }
    }];
    [actionSheet show];
    
}

@end
