//
//  HKSegmentModel.h
//  DownLoader
//
//  Created by bfec on 17/3/8.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKSegmentModel : NSObject


// JQFMDB 主键
@property (nonatomic, assign)NSInteger pkid;
//片段时长
@property (nonatomic,assign) double duration;
//片段的相对/J0_F0TkqBrJjZShMEditoYlsW9g=/lu22sSid8T-XLuIRyVEtC1kcmWmh/000000.ts?e=1639641296&token=HUwgVvJnrW6fXOzqd_myfnE3FFoFLWJnNktg7ThD:JA8-hrrrizD49yr9mhnOmCfAxeE
@property (nonatomic,copy) NSString *shortUrl;
//ts片段下载链接https://m3u8.huke88.com/J0_F0TkqBrJjZShMEditoYlsW9g=/lgiXKcOxqFGxS_bV9D8ZuHGIN-LL/000001.ts?e=1639647791&token=HUwgVvJnrW6fXOzqd_myfnE3FFoFLWJnNktg7ThD:UIbc5YKyMTtS74acKRwjI5dPb9I
@property (nonatomic,copy) NSString *url;
//ts下载的片段存储的本地路径  /download/6484_0/0.ts
@property (nonatomic,copy) NSString *localUrl;
@property (nonatomic, assign) BOOL isFinish;  //该切片是否有下载
@property (nonatomic, assign)int indexSegment;// 第几个切片
@property (nonatomic,copy) NSString *videoId; // 改切片对应的视频ID
@property (nonatomic, assign) int videoType; // 改切片对应的视频type

@property (nonatomic, assign) CGFloat segmentRate;
@end

