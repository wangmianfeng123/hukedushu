
//
//  HKTaskTeacCommentCell.m
//  Code
//
//  Created by Ivan li on 2018/7/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskTeacCommentCell.h"
#import "HKTaskModel.h"
#import "UIButton+ImageTitleSpace.h"



@implementation HKTaskTeacCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)initCellWithTableView:(UITableView *)tableview{
    
    static  NSString  *identif = @"HKTaskTeacCommentCell";
    HKTaskTeacCommentCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HKTaskTeacCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.commentLB];
    [self.contentView addSubview:self.teacCommentIV];
    [self.contentView addSubview:self.scanImageLB];
    //[self.contentView addSubview:self.praiseBtn];
    [self.contentView addSubview:self.hkPraiseBtn];
    
    UITapGestureRecognizer *coverTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverImageClick:)];
    [self.teacCommentIV addGestureRecognizer:coverTap];
    
    
    [self.commentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(18);
        make.left.equalTo(self.contentView).offset(PADDING_30);
        make.right.equalTo(self.contentView).offset(-PADDING_30);
    }];

    [self.teacCommentIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_30);
        make.right.equalTo(self.contentView).offset(-PADDING_30);
        make.top.equalTo(self.commentLB.mas_bottom).offset(12);
    }];

    [self.scanImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teacCommentIV.mas_bottom).offset(PADDING_10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.left.right.equalTo(self.teacCommentIV);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.bottom.equalTo(self.scanImageLB.mas_bottom).offset(PADDING_20);
    }];
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_F8F9FA;
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
}

- (UILabel*)commentLB {
    if (!_commentLB) {
        _commentLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                   titleColor:COLOR_27323F
                                    titleFont:nil
                                titleAligment:NSTextAlignmentLeft];
        _commentLB.font = HK_FONT_SYSTEM(14);
        _commentLB.numberOfLines = 0;
        _commentLB.userInteractionEnabled = YES;
    }
    return _commentLB;
}


- (UIImageView*)teacCommentIV {
    if (!_teacCommentIV) {
        _teacCommentIV = [UIImageView new];
        _teacCommentIV.userInteractionEnabled = YES;
        //_teacCommentIV.layer.masksToBounds = YES;
        //_teacCommentIV.layer.cornerRadius = 5;
    }
    return _teacCommentIV;
}


- (UILabel*)scanImageLB {
    
    if (!_scanImageLB) {
        _scanImageLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                     titleColor:COLOR_A8ABBE
                                      titleFont:nil
                                  titleAligment:NSTextAlignmentCenter];
        _scanImageLB.font = HK_FONT_SYSTEM(12);
    }
    return _scanImageLB;
}


//- (UIButton*)praiseBtn {
//    if (!_praiseBtn) {
//        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_praiseBtn setImage:imageName(@"praise_normal") forState:UIControlStateNormal];
//        [_praiseBtn setImage:imageName(@"praise_selected") forState:UIControlStateSelected];
//        [_praiseBtn setTitleColor:COLOR_27323F forState:UIControlStateSelected];
//
//        _praiseBtn.backgroundColor = COLOR_EFEFF6;
//        _praiseBtn.titleLabel.font = HK_FONT_SYSTEM(12);
//        _praiseBtn.clipsToBounds = YES;
//        _praiseBtn.layer.cornerRadius = 55/2;
//
//        [_praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _praiseBtn;
//}

- (HKTaskPraiseBtn*)hkPraiseBtn {
    if (!_hkPraiseBtn) {
        _hkPraiseBtn = [[HKTaskPraiseBtn alloc]init];
        [_hkPraiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hkPraiseBtn;
}


- (void)praiseBtnClick:(UIButton*)sender {
    
    self.hkPraiseBtn.title = @"10";
}


- (void)coverImageClick:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTeacCoverImageInCell:indexPath:)]) {
        [self.delegate didClickTeacCoverImageInCell:self indexPath:self.indexPath];
    }
}




- (void)setModel:(HKTaskDetailModel *)model {
    
    _model = model;
    [self setComment:model.evaluate];
    [self.teacCommentIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.modify_picture_url]) placeholderImage:HK_PlaceholderImage
                                    options:SDWebImageAvoidAutoSetImage // 下载完成后不要自动设置image SDWebImageAvoidAutoSetImage
                                  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                      if (nil != error) {
                                          [self.teacCommentIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                                              make.left.equalTo(self.contentView).offset(PADDING_30);
                                              make.right.equalTo(self.contentView).offset(-PADDING_30);
                                              make.top.equalTo(self.commentLB.mas_bottom).offset(12);
                                              make.height.priorityHigh().mas_equalTo(0);
                                          }];
                                          self.scanImageLB.text = nil;
                                          return ;
                                      }
                                      
                                      self.scanImageLB.text = isEmpty(model.modify_picture_url) ?nil :@"点击图片查看大图";
                                      CGFloat w = image.size.width;
                                      CGFloat h = image.size.height;

                                      CGFloat H =0;
                                      if (w >(SCREEN_WIDTH-30)) {
                                          if (w>=h) {
                                              CGFloat rate = h/w ;
                                              H = rate * (SCREEN_WIDTH-30);
                                          }else{
                                              CGFloat rate = h/w ;
                                              H = rate * (SCREEN_WIDTH-30);
                                          }
                                      }else{
                                          if (w>=h) {
                                              CGFloat rate = w/h ;
                                              H = rate * h;
                                          }else{
                                              CGFloat rate = h/w ;
                                              H = rate * h;
                                          }
                                      }
                                      [self.teacCommentIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                                          make.left.equalTo(self.contentView).offset(PADDING_30);
                                          make.right.equalTo(self.contentView).offset(-PADDING_30);
                                          make.top.equalTo(self.commentLB.mas_bottom).offset(12);
                                          make.height.priorityHigh().mas_equalTo(H);
                                      }];
                                      self.teacCommentIV.image = image;
                                      if (self.model.modifyH <= 1) {
                                          if (self.delegate && [self.delegate respondsToSelector:@selector(reloadTaskTeacCommentCell:indexPath:)]) {
                                                self.model.modifyH = H;
                                                [self.delegate reloadTaskTeacCommentCell:self.model indexPath:self.indexPath];
                                          }
                                      }
                                  }
     ];
}


- (void)setComment:(NSString*)comment {
    
    if (!isEmpty(comment)) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];//行间距
        NSString *username = @"老师:";
        NSString *contentString = [NSString stringWithFormat:@"%@%@", username, comment];
        NSRange userNameRange = [contentString rangeOfString:username];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_3D8BFF range:userNameRange];
        self.commentLB.attributedText = attrString;
    }
}


@end
