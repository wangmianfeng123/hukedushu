//
//  HKStudyCurvView.m
//  03-基本图形绘制
//
//  Created by hanchuangkeji on 2018/1/29.
//  Copyright © 2018年 xiaomage. All rights reserved.
//

#import "HKStudyCurvView.h"

#define padding 32.0


@interface HKStudyCurvView()

@property (nonatomic, strong)NSMutableArray *points;

- (HKMyLearningCenterModel *)getModel;

@end

@implementation HKStudyCurvView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    
}

-(NSMutableArray *)points {
    if (_points == nil) {
        _points = [NSMutableArray array];
    }
    return _points;
}

- (void)setModel:(HKMyLearningCenterModel *)model {
    _model = model;
    [self setNeedsDisplay];
}

- (void)addColor:(CGSize)size {
    
    CGSize newSize = CGSizeMake(self.bounds.size.width, size.height);
    
    
    UIGraphicsBeginImageContext(newSize);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    NSArray *countArray = [self getCountArray];
    CGFloat eachWidth = (newSize.width - 2 * padding) * 1.0 / (countArray.count - 1);
    NSInteger max = [self getMaxInt:countArray];
    CGFloat eachHeight =  max == 0? 0 : newSize.height * 1.0 / max;
    
    
    CGPathMoveToPoint(path, NULL, padding, newSize.height);
    
    for (int i = 0; i < countArray.count; i++) {
        NSInteger count = [countArray[i] integerValue];
        CGPathAddLineToPoint(path, NULL, eachWidth * i + padding, newSize.height - (count * eachHeight) + 1);
    }
    
    CGPathAddLineToPoint(path, NULL, newSize.width - padding, newSize.height);
    
    CGPathCloseSubpath(path);
    
    //绘制渐变
    UIColor *startColor = [UIColor colorWithRed:255 / 255.0 green:244 / 255.0 blue:188 / 255.0 alpha:1.0];
    [self drawLinearGradient:gc path:path startColor:startColor.CGColor endColor:[UIColor whiteColor].CGColor];
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self addSubview:imgView];
}

- (HKMyLearningCenterModel *)getModel {
    if (_model == nil) {
        HKMyLearningCenterModel *modelTemp = [[HKMyLearningCenterModel alloc] init];
        modelTemp.study_total = 0;
        NSMutableArray *array = [NSMutableArray array];
        modelTemp.list = array;
        for (int i = 0; i < 7; i++) {
            HKMyLearningCenterDayModel *model = [[HKMyLearningCenterDayModel alloc] init];
            model.date = @"00.00";
            model.count = @"0";
            [array addObject:model];
        }
        return modelTemp;
    }
    return _model;
}

- (NSArray *)getDataArray {
    HKMyLearningCenterModel *model = [self getModel];
    NSMutableArray *array = [NSMutableArray array];
    for (HKMyLearningCenterDayModel *dayModel in model.list) {
        [array addObject:dayModel.date];
    }
    return array;
}

- (NSArray *)getCountArray {
    HKMyLearningCenterModel *model = [self getModel];
    NSMutableArray *array = [NSMutableArray array];
    for (HKMyLearningCenterDayModel *dayModel in model.list) {
        [array addObject:dayModel.count];
    }
    return array;
}

//- (NSMutableDictionary *)dic {
//    if (_dic == nil) {
//        _dic = [NSMutableDictionary dictionary];
//
//        NSArray *dataArray = @[@"01.01", @"01.02", @"01.03", @"01.04", @"01.05", @"01.06", @"01.07"];
//
//        NSArray *countArray = @[@"9", @"0", @"0", @"2", @"0", @"0", @"6"];
//        _dic[@"dataArray"] = dataArray;
//        _dic[@"countArray"] = countArray;
//    }
//    return _dic;
//}

- (NSInteger)getMaxInt:(NSArray *)array {
    NSInteger max = 0;
    
    for (int i = 0 ; i < array.count; i++) {
        NSInteger tempInt = [array[i] integerValue];
        if (max < tempInt) {
            max = tempInt;
        }
    }
    return max;
}

- (void)drawRect:(CGRect)rect {
    
//    CGFloat paddingHeight = 200;
//    CGFloat paddingWidth = [UIScreen mainScreen].bounds.size.width - 2 * padding;
//    CGRect paddingRect = CGRectMake(rect.origin.x, rect.origin.y, paddingWidth, paddingHeight);
    
    // 先移除所有子控件
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGSize size = CGSizeMake(rect.size.width - 2 * padding, 100);
    
    [self addColor:size];
    
    [self addLine:size];

    [self addPoint:size];
    
}



- (void)addLine:(CGSize)size {
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    path2.lineWidth = 2;
    
    //绘制Path
    NSArray *countArray = [self getCountArray];
    CGFloat eachWidth = size.width * 1.0 / (countArray.count - 1);
    NSInteger max = [self getMaxInt:countArray];
    CGFloat eachHeight = max == 0? 0 : size.height * 1.0 / max;
    
    
    [[UIColor colorWithRed:255 /255.0 green:189/255.0 blue:0/255.0 alpha:1.0] set];
    
    
    
    for (int i = 0; i < countArray.count; i++) {
        NSInteger count = [countArray[i] integerValue];
        if (i == 0) {
            [path2 moveToPoint:CGPointMake(eachWidth * i + padding, size.height - (count * eachHeight))];
            continue;
        }
        [path2 addLineToPoint:CGPointMake(eachWidth * i + padding, size.height - (count * eachHeight))];
    }
    
//    [path2 addLineToPoint:CGPointMake(padding + size.width, size.height)];
    
    [path2 stroke];
    
}

- (void)addPoint:(CGSize)size {
    [self.points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView *point = obj;
        [point removeFromSuperview];
        
    }];
    
    [self.points removeAllObjects];
    
    
    NSArray *dataArray = [self getDataArray];
    NSArray *countArray = [self getCountArray];
    CGFloat eachWidth = size.width * 1.0 / (countArray.count - 1);
    NSInteger max = [self getMaxInt:countArray];
    CGFloat eachHeight = max == 0? 0 : size.height * 1.0 / max;
    
    
    for (int i = 0; i < countArray.count; i++) {
        NSInteger count = [countArray[i] integerValue];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * eachWidth, size.height - (count * eachHeight), 22, 22)];
        imageView.image = [UIImage imageNamed:@"ic_round_s"];
        imageView.center = CGPointMake(i * eachWidth + padding, size.height - (count * eachHeight));
        [self addSubview:imageView];
        [self.points addObject:imageView];
        
        // 最后一张的图标不一样
        if (countArray.count - 1 == i) {
            imageView.image = [UIImage imageNamed:@"ic_round_m"];
        }
    }
    
    for (int i = 0; i < countArray.count; i++) {
        NSInteger count = [countArray[i] integerValue];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:11.0];
        //label.textColor = HKColorFromHex(0x27323F, 1.0);
        label.textColor = COLOR_27323F_EFEFF6;
        label.text = countArray[i];
        
        // 最后一个加粗
        if (i == countArray.count - 1) {
            label.font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightBold];
        }
        
        [label sizeToFit];
        label.center = CGPointMake(i * eachWidth + padding, size.height - (count * eachHeight) - 15);
        
        [self addSubview:label];
        [self.points addObject:label];
    }
    
    
    for (int i = 0; i < countArray.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:11.0];
        //label.textColor = HKColorFromHex(0xA8ABBE, 1.0);
        label.textColor = COLOR_A8ABBE_7B8196;
        label.text = dataArray[i];
        [label sizeToFit];
        label.center = CGPointMake(i * eachWidth + padding, size.height + 20);
        [self addSubview:label];
        [self.points addObject:label];
    }
    
}


- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
