//
//  HKChanel.m
//  Code
//
//  Created by Ivan li on 2019/9/18.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HkChannelData.h"
#import "HKVersionModel.h"


@implementation HkChannelData


#pragma mark -- 获取推广渠道
+ (void)requestHkChannelData {
    
    NSString *channel = [CommonFunction getHKChannel];
    if (isEmpty(channel)) {
        /// 推广渠道
        NSString *idfa = [CommonFunction getIDFAString];
        
        if (!isEmpty(idfa)) {
            NSDictionary *dict = @{@"idfa" : idfa};
            [HKHttpTool POST:IOS_CHANNEL_GET_CHANNEL baseUrl:BaseUrl_Channl parameters:dict success:^(id responseObject) {
                if (HKReponseOK) {
                    HKInitConfigModel *configModel = [HKInitConfigModel mj_objectWithKeyValues:responseObject[@"data"]];
                    if (!isEmpty(configModel.channel)) {
                        [HKInitConfigManger sharedInstance].channel = configModel.channel;
                        [CommonFunction setHKChannelWithName:configModel.channel];
                    }
                    
                    if (!isEmpty(configModel.caid)) {
                        [HKInitConfigManger sharedInstance].caid = configModel.caid;
                        [CommonFunction setXHSCaidWithName:configModel.caid];
                    }

                    if(!isEmpty(configModel.click_id)){
                        [HKInitConfigManger sharedInstance].click_id = configModel.click_id;
                        [CommonFunction setXHSClickidWithName:configModel.click_id];
                    }
                    
                    if(!isEmpty(configModel.caid_md5)){
                        [HKInitConfigManger sharedInstance].caid_md5 = configModel.caid_md5;
                        [CommonFunction setXHScaid_md5WithName:configModel.caid_md5];
                    }
                    
//                    if(!isEmpty(configModel.paid)){
//                        [HKInitConfigManger sharedInstance].paid = configModel.paid;
//                        [CommonFunction setXHSpaidWithName:configModel.paid];
//                    }
                }
            } failure:^(NSError *error) {
                
            }];

        }
    }else{
        [HKInitConfigManger sharedInstance].channel = channel;
    }
}



#pragma mark - 删除渠道
+ (void)deleteHkChannelData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"hk_channel"];
    
    NSString *key = [NSString stringWithFormat:@"HKDevice-%@",[DateChange getCurrentTime_day]];
    [defaults removeObjectForKey:key];
    
    
    if (isLogin()) {
        NSString *key = [NSString stringWithFormat:@"%@-%@",[HKAccountTool shareAccount].ID, [DateChange getCurrentTime_day]];
        [defaults removeObjectForKey:key];
    }
    [defaults synchronize];
}


@end
