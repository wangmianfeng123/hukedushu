//
//  HKDetailAlbumView.h
//  Code
//
//  Created by Ivan li on 2021/5/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKDetailAlbumView : UIView
@property(nonatomic,strong)DetailModel *detaiModel;
@property (nonatomic , strong) void(^didTapBlock)(DetailModel *detaiModel);

@end

NS_ASSUME_NONNULL_END
