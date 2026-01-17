//
//  HKTrainOrderCell.m
//  Code
//
//  Created by hanchuangkeji on 2019/1/15.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKTrainOrderCell.h"
#import "UIView+HKLayer.h"

@interface HKTrainOrderCell()

@property (weak, nonatomic) IBOutlet UILabel *orderNOLB;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLB;
@property (weak, nonatomic) IBOutlet UIImageView *orderCoverIM;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLB;
@property (weak, nonatomic) IBOutlet UIButton *getStartBtn;

@property (weak, nonatomic) IBOutlet UIView *centerBgView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *smallTextLabel;
@end

@implementation HKTrainOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 立即参加按钮
    self.getStartBtn.clipsToBounds = YES;
    self.getStartBtn.layer.cornerRadius = self.getStartBtn.height * 0.5;
    
    self.gifButton.clipsToBounds = YES;
    self.gifButton.layer.cornerRadius = self.getStartBtn.height * 0.5;
    
    
    
    // 封面
    self.orderCoverIM.clipsToBounds = YES;
    self.orderCoverIM.layer.cornerRadius = 5.0;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.centerBgView.backgroundColor = COLOR_F8F9FA_333D48;
    
    self.orderNOLB.textColor = COLOR_27323F_EFEFF6;
    
    self.orderPriceLB.textColor = COLOR_27323F_EFEFF6;
    
    self.orderNameLB.textColor = COLOR_27323F_EFEFF6;
    
    self.orderTimeLB.textColor = COLOR_7B8196_A8ABBE;
    
    self.bottomLineView.backgroundColor = COLOR_F8F9FA_333D48;
}


- (void)setModel:(HKTrainModel *)model {
    _model = model;
    
    if (model.isLive) {
        [self.getStartBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [self.getStartBtn setTitle:@"班主任" forState:UIControlStateNormal];
        [self.getStartBtn addCornerRadius:self.getStartBtn.height * 0.5 addBoderWithColor:COLOR_27323F_EFEFF6];
        [self.getStartBtn setBackgroundColor:COLOR_FFFFFF_3D4752];
        
        [self.gifButton setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [self.gifButton setTitle:@"看赠品" forState:UIControlStateNormal];
        [self.gifButton addCornerRadius:self.getStartBtn.height * 0.5 addBoderWithColor:COLOR_27323F_EFEFF6];
        [self.gifButton setBackgroundColor:COLOR_FFFFFF_3D4752];
        
        // 直播
        self.orderNOLB.text= [NSString stringWithFormat:@"订单号：%@", model.order];
        
        [self.orderCoverIM sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.live_cover]) placeholderImage:imageName(HK_Placeholder)];

        

        //self.orderTimeLB.text = [NSString stringWithFormat:@"开播时间：%@",model.start_at];
        self.orderTimeLB.text = [NSString stringWithFormat:@"讲师：%@",model.teacher_name];
        self.smallTextLabel.text = [NSString stringWithFormat:@"开播时间：%@",model.start_at];
        self.smallTextLabel.hidden = NO;
        self.orderPriceLB.text = [NSString stringWithFormat:@"实付：￥%@", model.pay_money];
        self.gifButton.hidden = [model.hasGive isEqualToString:@"0"] ? YES : NO;
        self.getStartBtn.userInteractionEnabled = YES;
        if ([model.live_status isEqualToString:@"0"]) {
            self.orderNameLB.attributedText = [self addParagraphStyle:model.live_name];
        }else{
            self.orderNameLB.text = model.live_name;
        }
    }else{
        self.getStartBtn.userInteractionEnabled = NO;
        self.gifButton.hidden = YES;
        [self.getStartBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateSelected];
        [self.getStartBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];

        if (model.series) {
            [self.getStartBtn setTitle:@"立即学习" forState:UIControlStateNormal];
            UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
            UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
            UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
            UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(78, 22) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
            [self.getStartBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
            [self.getStartBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_EFEFF6_7B8196] forState:UIControlStateSelected];
            
            // 直播
            self.orderNOLB.text= [NSString stringWithFormat:@"订单号：%@", model.order_number];
            
            [self.orderCoverIM sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.series.cover]) placeholderImage:imageName(HK_Placeholder)];

            self.orderNameLB.text = model.series.title;

            //self.orderTimeLB.text = [NSString stringWithFormat:@"开播时间：%@",model.start_at];
            self.orderTimeLB.text = [NSString stringWithFormat:@"%@节课",model.series.course_num];
            self.smallTextLabel.text = [NSString stringWithFormat:@"讲师：%@",model.series.teacher.name];
            self.smallTextLabel.hidden = NO;
            self.orderPriceLB.text = [NSString stringWithFormat:@"实付：￥%@", model.price];
        }else{

            [self.getStartBtn setTitle:@"立即参与" forState:UIControlStateNormal];
            [self.getStartBtn setTitle:@"已结束" forState:UIControlStateSelected];
            UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
            UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
            UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
            UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(78, 22) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
            [self.getStartBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
            [self.getStartBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_EFEFF6_7B8196] forState:UIControlStateSelected];

            
            self.orderNOLB.text= [NSString stringWithFormat:@"订单号：%@", model.order_number];
            [self.orderCoverIM sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img]] placeholderImage:imageName(HK_Placeholder)];
            self.orderNameLB.text = model.name;
            self.orderTimeLB.text = [NSString stringWithFormat:@"周期：%@-%@", model.start, model.end];
            
            self.orderPriceLB.text = [NSString stringWithFormat:@"实付：￥%@", model.price];
            self.smallTextLabel.hidden = YES;
            // 1 正在进行  2已结束
            self.getStartBtn.selected = (2 == model.state);
            if (NO == isEmpty(model.state_desc)) {
                [self.getStartBtn setTitle:model.state_desc forState:UIControlStateNormal];
                [self.getStartBtn setTitle:model.state_desc forState:UIControlStateSelected];
            }
        }
        
        //self.getStartBtn.selected = [model.state_desc isEqualToString:@"已结束"];
    }
}

- (NSMutableAttributedString *)addParagraphStyle:(NSString *)title{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//行间距
    //清除首尾空格
    NSString *contentString = title;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_27323F_EFEFF6 range:NSMakeRange(0, attrString.length)];
    //self.firstCommentLabel.attributedText = attrString;
    
    //3.初始化NSTextAttachment对象
    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
    attchment.bounds = CGRectMake(0, -2, 50, 15);//设置frame
    attchment.image = [UIImage hkdm_imageWithNameLight:@"tag_end_live" darkImageName:@"tag_end_live"];//[UIImage imageNamed:@""];//设置图片
    
    //4.创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
    [attrString insertAttributedString:string atIndex:0];//插入到第几个下标

    return attrString;
}

- (void)setPgcModel:(HKPgcCourseModel *)pgcModel {
    _pgcModel = pgcModel;
    
    
    self.orderNOLB.text= [NSString stringWithFormat:@"订单号：%@", pgcModel.order_number];
    
    [self.orderCoverIM sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:pgcModel.cover_url]] placeholderImage:imageName(HK_Placeholder)];
    
    self.orderNameLB.text = pgcModel.name;
    self.orderTimeLB.text = @"课程有效期：永久有效";
    
    self.orderPriceLB.text = [NSString stringWithFormat:@"实付：￥%@", pgcModel.now_price];
}

- (IBAction)teacherBtnClick {
    if ([self.delegate respondsToSelector:@selector(trainOrderCellDidTeacherBtn:)]) {
        [self.delegate trainOrderCellDidTeacherBtn:self.model];
    }
}

- (IBAction)gifBtnClick {
    if ([self.delegate respondsToSelector:@selector(trainOrderCell:didGifBtn:)]) {
        [self.delegate trainOrderCell:self didGifBtn:self.model];
    }
}
@end
