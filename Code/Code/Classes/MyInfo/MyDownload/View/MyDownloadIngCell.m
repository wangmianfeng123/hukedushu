//
//  MyDownloadIngCell.m
//  Code
//
//  Created by Ivan li on 2017/8/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "MyDownloadIngCell.h"
#import "DownloadCacher.h"
#import "UIImage+GIF.h"
//#import "FLAnimatedImage.h"

@implementation MyDownloadIngCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


- (void)createUI {

    [self.contentView addSubview:self.fLAnimatedImageView];
    [self.contentView addSubview:self.countLabel];
    [self createDownloadObserver];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [_fLAnimatedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(PADDING_10);
        make.bottom.equalTo(self.contentView).offset(-PADDING_10);
        make.width.mas_equalTo(90);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fLAnimatedImageView.mas_right).offset(13);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}


- (UIImageView*)fLAnimatedImageView {
    
    if (!_fLAnimatedImageView) {
        _fLAnimatedImageView = [[UIImageView alloc]init];
        _fLAnimatedImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fLAnimatedImageView.image = imageName(@"download_blue");
    }
    return _fLAnimatedImageView;
}



- (UILabel*)countLabel {
    if (!_countLabel) {
        _countLabel  = [[UILabel alloc] init];
        [_countLabel setTextColor:COLOR_27323F_EFEFF6];
        _countLabel.textAlignment = NSTextAlignmentLeft;
        _countLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 16:15];
    }
    return _countLabel;
}




- (void)setCount:(NSInteger)count {
    
    if (count>0) {
        _countLabel.text = [NSString stringWithFormat:@"剩余%lu课件",(long)count];
    }
}



- (void)setGifImage {
    
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"loading" ofType:@"gif"];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    _fLAnimatedImageView.contentMode = UIViewContentModeScaleAspectFit;
    _fLAnimatedImageView.image = [UIImage sd_imageWithGIFData:imageData];

//    _fLAnimatedImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
}


#pragma mark - 首次计算 未下载视频数量
- (void)downloadIngCount {
    
    NSMutableArray *downladed =  [[DownloadCacher shareInstance]selectNoDownloadModels];
    NSInteger count = downladed.count;
    [self setCount:count];
}


#pragma mark - 通知-下载完成
- (void)createDownloadObserver {
    [MyNotification addObserver:self
                       selector:@selector(receiveNotification:)
                           name:KdownloadingChangeNotification
                         object:nil];
}


#pragma mark - 解析通知中 未下载的视频数量
- (void)receiveNotification:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSInteger count  = [[dict objectForKey:KdownloadCount]integerValue];
    [self setCount:count];
}






@end

