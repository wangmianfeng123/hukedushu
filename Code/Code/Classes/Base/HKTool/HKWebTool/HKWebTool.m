//
//  HKWebTool.m
//  Code
//
//  Created by Ivan li on 2018/8/28.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKWebTool.h"
#import <WebKit/WebKit.h>
#import "AES128Helper.h"

@implementation HKWebTool




/** 清空 Web 缓存 */
+ (void)clearnWebCache {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}
 

/** 设置Html 路径 请求头 */
+ (NSMutableURLRequest*)requestHeaderFieldWithUrl:(NSString*)url {
    
    if (!isEmpty(url)) {        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request setValue:APP_TYPE forHTTPHeaderField:@"app-type"];
        [request setValue:API_VERSION forHTTPHeaderField:@"api-version"];
        [request setValue:STRING_TABLET forHTTPHeaderField:@"is-tablet"];
        // 设备 uuid
        //[request setValue:[CommonFunction getUUIDFromKeychain] forHTTPHeaderField:DEVICE_NUM];
        
        NSMutableDictionary * headerDic = [NSMutableDictionary dictionary];
            
        NSString * device_id = [CommonFunction getUUIDFromKeychain];
//        if (!isEmpty(device_id)) {
            [headerDic setSafeObject:device_id forKey:DEVICE_NUM];
//        }
        
        if ([headerDic allKeys].count > 0) {
            NSError *error;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:headerDic options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
            
            NSData *data = [[NSData alloc]initWithBase64EncodedString:@"aHVrZTIwMjEwNzIyMjE0Nw==" options:NSDataBase64DecodingIgnoreUnknownCharacters];
            if(data == nil) return nil;

            NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            NSString *decrStr = [AES128Helper aesEncrypt:jsonString key:string];
            if (!isEmpty(decrStr)) {
                [request setValue:decrStr forHTTPHeaderField:@"sign-info"];                
            }            
        }
        
        
        // 设置token
        if ([CommonFunction getUserToken].length) {
            [request setValue:[NSString stringWithFormat:@"Bearer-%@",[CommonFunction getUserToken]] forHTTPHeaderField:USERR_TOKEN];
        }else {
            [request setValue:nil forHTTPHeaderField:USERR_TOKEN];
        }
        NSLog(@"USERR_TOKEN=====%@",[NSString stringWithFormat:@"Bearer-%@",[CommonFunction getUserToken]]);
        //is_night  1为夜间模式 0为非夜间模式
        if (@available(iOS 13.0, *)) {
            DMUserInterfaceStyle mode = DMTraitCollection.currentTraitCollection.userInterfaceStyle;
            BOOL isHKNight = (mode == DMUserInterfaceStyleDark) ? YES :NO;
            [request setValue:isHKNight ?@"1" :@"0" forHTTPHeaderField:@"is-night"];
        }
        return request;
    }else{
        return nil;
    }
}


@end
