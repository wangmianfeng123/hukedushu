//
//  HKLiveCalculateData.m
//  Code
//
//  Created by hanchuangkeji on 2019/3/19.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKLiveCalculateData.h"
#import "NSTimer+FOF.h"
#import "HKLiveDetailModel.h"

#define filePath @"/Users/hanchuangkeji/Desktop/1111111111111111/LiveData/a.txt"


static HKLiveCalculateData *_instance;

@interface HKLiveCalculateData()

@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, strong)NSDateFormatter *formatter;

@property (nonatomic, strong)NSMutableDictionary *dataDic;

@end

@implementation HKLiveCalculateData

+ (instancetype)shareInstance
{
    // 保证只有一条线程获取实例对象
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HKLiveCalculateData alloc] init];
    });
    return _instance;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _formatter = formatter;
    }
    return _formatter;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if (!_dataDic) {
            _dataDic = [NSMutableDictionary dictionary];
        }
    }
    return _dataDic;
}

// 统计某课程直播数据，一小时执行一次
- (void)eachHourLiveData {
    [self saveDataToLocal];
    self.timer = [NSTimer tb_scheduledTimerWithTimeInterval:60 * 10 block:^{
        [self saveDataToLocal];
    } repeats:YES];
}

- (void)saveDataToLocal {
    
    NSDictionary *param = @{@"id" : @"256"};
    
    [HKHttpTool POST:@"live/detail" parameters:param success:^(id responseObject) {
        
        if (HKReponseOK) {
            HKLiveDetailModel *model = [HKLiveDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            NSString *count = model.course.enrolment_people.length? model.course.enrolment_people : @"0";
            
            // 保存数据
            NSString *dateTime = [self.formatter stringFromDate:[NSDate date]];
            self.dataDic[dateTime] = count;
            [self.dataDic writeToFile:filePath atomically:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}



@end
