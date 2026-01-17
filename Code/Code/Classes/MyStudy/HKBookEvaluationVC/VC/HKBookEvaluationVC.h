//
//  HKBookEvaluationVC.h
//  Code
//
//  Created by Ivan li on 2019/8/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKBookCommentModel.h"

@class HKBookModel,HKBookCommentModel;


@protocol HKBookEvaluationDelegate <NSObject>

@optional
- (void)bookEvaluationSucess:(NSString*_Nonnull)comment;

@end


NS_ASSUME_NONNULL_BEGIN

@interface HKBookEvaluationVC : HKBaseVC

@property(nonatomic,copy) NSString *bookId;

@property(nonatomic,weak)id <HKBookEvaluationDelegate>delegate;

@property(nonatomic,strong) HKBookModel *model;
/// 评论
@property(nonatomic,strong) HKBookCommentModel *commentModel;

@end

NS_ASSUME_NONNULL_END

