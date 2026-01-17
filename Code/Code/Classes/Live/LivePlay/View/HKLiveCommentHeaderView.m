//
//  HKLiveCommentHeaderView.m
//  Code
//
//  Created by Ivan li on 2020/12/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKLiveCommentHeaderView.h"
#import "HKLiveCommentModel.h"

@interface HKLiveCommentHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@end

@implementation HKLiveCommentHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self setAllStar:0];
}

-(void)setCountZh:(NSString *)countZh{
    _countZh = countZh;
    self.commentCountLabel.text = [NSString stringWithFormat:@"共%@条评价",_countZh];
}

-(void)setAllStar:(int)allStar{
    _allStar = allStar;
    
    [self.starView removeAllSubviews];
    for (int i = 0; i < 5; i++) {
        CGFloat W = 18;
        UIImageView * imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake( i * (W + 8), 0, W, W);
        if (i+1<=allStar) {
            imageV.image = [UIImage imageNamed:@"ic_live_comment_2_30"];
        }else{
            imageV.image = [UIImage imageNamed:@"ic_live_no comment_2_30"];
        }
        
        [self.starView addSubview:imageV];
    }
}

-(void)setAllScore:(CGFloat)allScore{
    _allScore = allScore;
    self.scoreLabel.text = [NSString stringWithFormat:@"%0.1f",allScore];
}

@end
