//
//  HKPostMonmentToolView.m
//  Code
//
//  Created by Ivan li on 2021/1/29.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPostMonmentToolView.h"

@interface HKPostMonmentToolView ()
@property (weak, nonatomic) IBOutlet UIButton *chooseImgBtn;

@end

@implementation HKPostMonmentToolView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = COLOR_F8F9FA_333D48;
    [self.chooseImgBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_img_upload_2_31" darkImageName:@"ic_img_upload_dark_2_31"] forState:UIControlStateNormal];
}

- (IBAction)chooseImgBtnClick {
    if (self.didChooseImgBlock) {
        self.didChooseImgBlock();
    }
}

@end
