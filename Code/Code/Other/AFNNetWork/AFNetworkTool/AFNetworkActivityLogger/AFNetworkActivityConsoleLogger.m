// AFNetworkActivityConsoleLogger.h
//
// Copyright (c) 2018 AFNetworking (http://afnetworking.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFNetworkActivityConsoleLogger.h"
//#import "HDWindowLogger.h"

@implementation AFNetworkActivityConsoleLogger

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.level = AFLoggerLevelInfo;

    return self;
}


- (void)URLSessionTaskDidStart:(NSURLSessionTask *)task {
    NSURLRequest *request = task.originalRequest;

    NSString *body = nil;
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }

    switch (self.level) {
        case AFLoggerLevelDebug:{
            NSLog(@"******************* %@ '%@': %@ \n body:%@", [request HTTPMethod], [[request URL] absoluteString], [request allHTTPHeaderFields], body);
//            NSString * logstr = [NSString stringWithFormat:@"*******************请求信息：\n URL:'%@' \n HTTPHeaderFields:%@ \n body:%@",[[request URL] absoluteString], [request allHTTPHeaderFields], body];
//            HDNormalLog(logstr);
            break;
        }
            
        case AFLoggerLevelInfo:{
            NSLog(@"******************* %@ '%@'", [request HTTPMethod], [[request URL] absoluteString]);
//            NSString * Infostr = [NSString stringWithFormat:@"*******************请求信息：\n %@ '%@'", [request HTTPMethod], [[request URL] absoluteString]];
//            HDNormalLog(Infostr);
            break;

        }
        default:
            break;
    }
}

- (void)URLSessionTaskDidFinish:(NSURLSessionTask *)task withResponseObject:(id)responseObject inElapsedTime:(NSTimeInterval )elapsedTime withError:(NSError *)error {
    NSUInteger responseStatusCode = 0;
    NSDictionary *responseHeaderFields = nil;
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger)[(NSHTTPURLResponse *)task.response statusCode];
        responseHeaderFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
    }

    if (error) {
        switch (self.level) {
            case AFLoggerLevelDebug:
            case AFLoggerLevelInfo:
            case AFLoggerLevelError:{
                NSLog(@"******************* [Error] %@ '%@' (%ld) [%.04f s]: %@", [task.originalRequest HTTPMethod], [[task.response URL] absoluteString], (long)responseStatusCode, elapsedTime, error);
//                NSString * str = [NSString stringWithFormat:@"*******************响应信息：\n [Error] %@ '%@' (%ld) [%.04f s]: %@", [task.originalRequest HTTPMethod], [[task.response URL] absoluteString], (long)responseStatusCode, elapsedTime, error];
//                HDNormalLog(str);
            }
                
            default:
                break;
        }
    } else {
        switch (self.level) {
            case AFLoggerLevelDebug:{
                NSLog(@"******************* %ld '%@' [%.04f s]: %@ %@", (long)responseStatusCode, [[task.response URL] absoluteString], elapsedTime, responseHeaderFields, responseObject);
//                NSString * str = [NSString stringWithFormat:@"*******************响应信息：\n  %ld '%@' [%.04f s]: %@ %@", (long)responseStatusCode, [[task.response URL] absoluteString], elapsedTime, responseHeaderFields, responseObject];
//                HDNormalLog(str);
            }
                break;
            case AFLoggerLevelInfo:{
                NSLog(@"******************* %ld '%@' [%.04f s]", (long)responseStatusCode, [[task.response URL] absoluteString], elapsedTime);
//                NSString * str = [NSString stringWithFormat:@"*******************响应信息：\n %ld '%@' [%.04f s]", (long)responseStatusCode, [[task.response URL] absoluteString], elapsedTime];
//                HDNormalLog(str);
            }
                break;
            default:
                break;
        }
    }
}

@end
