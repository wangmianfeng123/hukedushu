//
//  HKBookRateVC.h
//  Code
//
//  Created by Ivan li on 2019/12/24.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKBookRateVC : HKBaseVC

@property(nonatomic,copy) void(^bookRateVCCellClick)(HKBookModel *bookModel,float currentRate, NSInteger index);

@end



@interface HKBookRateCell : UITableViewCell

@property (nonatomic,strong)HKBookModel   *bookModel;

@property (strong, nonatomic)  UILabel *titleLB;

@property (strong, nonatomic)  UIImageView *selectIV;

@end

NS_ASSUME_NONNULL_END
