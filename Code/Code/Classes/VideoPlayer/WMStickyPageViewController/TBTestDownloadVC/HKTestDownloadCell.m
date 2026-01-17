//
//  HKTestDownloadCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/12/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKTestDownloadCell.h"


@interface HKTestDownloadCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UILabel *progressLB;

@property (nonatomic, strong)HKDownloadModel *downloadModel;

@property (nonatomic, strong)NSIndexPath *indexPath;

@end

@implementation HKTestDownloadCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDownloadModel:(HKDownloadModel *)downloadModel index:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    _downloadModel = downloadModel;
    self.titleLB.text = downloadModel.name;
    self.progressLB.text = [NSString stringWithFormat:@"%.2f", downloadModel.downloadPercent * 100];
}

- (void)setProgress:(NSString *)string {
    self.progressLB.text = string;
}


- (IBAction)deleteBtn:(id)sender {
    !self.deleteBlock? : self.deleteBlock(self.indexPath);
}
- (IBAction)startBtn:(id)sender {
    !self.startBlock? : self.startBlock(self.indexPath);
}
- (IBAction)pauseBtn:(id)sender {
    !self.pauseBlock? : self.pauseBlock(self.indexPath);
}

@end
