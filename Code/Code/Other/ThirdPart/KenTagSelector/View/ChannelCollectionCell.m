//
//  ChannelCollectionCell.m
//  KenTagSelector
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 KANG HAN. All rights reserved.
//

#import "ChannelCollectionCell.h"
#import "KenTagSelectorUtils.h"
#import "UIView+HKLayer.h"

@implementation ChannelCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //title
        _title = [[UILabel alloc]init];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _bgImgv = [[UIImageView alloc] initWithFrame:CGRectMake(2, 4, frame.size.width - 6, frame.size.height - 4)];
        _bgImgv.image = [UIImage imageNamed:@"btn_type_nor"];
        [self.contentView addSubview:_bgImgv];
        
        [self.contentView addSubview:_title];
        _title.frame = CGRectMake(2, 4, frame.size.width - 6, frame.size.height - 4);
        _title.layer.masksToBounds = YES;
        _title.layer.cornerRadius = _title.frame.size.height / 2;
//        _title.layer.borderColor = [KenTagSelectorUtils colorNamed:@"cell_border_color"].CGColor;
//        _title.layer.borderWidth = 0.5;
        _title.font = [UIFont systemFontOfSize:13];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = [UIColor clearColor];
        _title.numberOfLines = 0;
//        _title.textColor = [KenTagSelectorUtils colorNamed:@"cell_text_color"];
        
        _btnDel = [[UIButton alloc]init];
        [self.contentView addSubview:_btnDel];
        _btnDel.frame = CGRectMake(frame.size.width - 18, 0, 18, 18);

        //UIImage *img = [UIImage imageNamed:@"channel_tag_delete" inBundle:[KenTagSelectorUtils getBundle] compatibleWithTraitCollection:nil];
        //[_btnDel setImage:img forState:UIControlStateNormal];
        [_btnDel setImage:[UIImage imageNamed:@"ic_del_edit_2_38"] forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        
        _addImgv = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 18, 0, 18, 18)];
        _addImgv.image = [UIImage imageNamed:@"ic_add_edit_2_38"];
        [self.contentView addSubview:_addImgv];

    }
    return self;
}

-(void)setModel:(Channel *)model{
    
    _model = model;
        
        if (model.tagType == SelectedChannel) {
            if (model.editable) {
            }else{
                model.editable = YES;
            }
            if (model.resident) {
                _btnDel.hidden = YES;
                _addImgv.hidden = NO;
            }else{
                _btnDel.hidden = NO;
                _addImgv.hidden = YES;
            }
            
            if (model.selected) {
                _title.textColor = [KenTagSelectorUtils colorNamed:@"focus_color"];
            }else{
                _title.textColor = [KenTagSelectorUtils colorNamed:@"cell_text_color"];
            }
//            _title.backgroundColor = [UIColor colorWithHexString:@"#FFB600"];
            _bgImgv.image = [UIImage imageNamed:@"btn_type_sel"];
            _title.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        } else if (model.tagType == OtherChannel) {
            if (model.editable) {
                model.editable = NO;
            }

            _title.textColor = [KenTagSelectorUtils colorNamed:@"cell_text_color"];
            _btnDel.hidden = YES;
            _addImgv.hidden = NO;
//            _title.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
            _bgImgv.image = [UIImage imageNamed:@"btn_type_nor"];
            _title.textColor = [UIColor colorWithHexString:@"#7B8196"];
        }
    
        _title.text = model.title;
    
    
}

- (void)delete:(UIButton *)sender{
    
    [_delegate deleteCell:sender];
}
@end
