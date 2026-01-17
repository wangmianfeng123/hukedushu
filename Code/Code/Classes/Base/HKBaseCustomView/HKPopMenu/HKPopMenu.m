//
//  HKPopMenu.m
//  HKPopMenu
//
//  Created by chengxianghe on 16/4/7.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "HKPopMenu.h"


static const CGFloat kXHDefaultAnimateDuration = 0.15;

@implementation HKPopMenuConfiguration

+ (HKPopMenuConfiguration *)defaultConfiguration {
    
    HKPopMenuConfiguration *config = [[self alloc] init];
    config.style = HKPopMenuAnimationStyleWeiXin;
    config.arrowSize = 10;
    config.arrowMargin = 0;
    config.marginXSpacing = 10;
    config.marginYSpacing = 10;
    config.intervalSpacing = 10;
    config.menuCornerRadius = 4;
    config.menuScreenMinLeftRightMargin = 10;
    config.menuScreenMinBottomMargin = 10;
    config.menuMaxHeight = 200;
    config.separatorInsetLeft = 10;
    config.separatorInsetRight = 10;
    config.separatorHeight = 1;
    config.fontSize = 15;
    config.itemHeight = 40;
    config.itemMaxWidth = 150;
    config.alignment = NSTextAlignmentLeft;
    config.shadowOfMenu = false;
    config.hasSeparatorLine = true;
    config.dismissWhenRotationScreen = false;
    config.revisedMaskWhenRotationScreen = false;
    config.dismissWhenClickBackground = true;
    config.titleColor = [UIColor whiteColor];
    config.separatorColor = [UIColor blackColor];
    config.shadowColor = [UIColor blackColor];
    config.menuBackgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    config.maskBackgroundColor = [UIColor clearColor];
    config.selectedColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    return config;

}

@end



@implementation HKPopMenuItem

#pragma mark - public func



- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image block:(HKPopMenuItemAction)block {
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _block = block;
    }
    return self;
}



- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action {
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _target = target;
        _action = action;
    }
    return self;
}

#pragma mark - private func

- (void)performAction {
    __strong id target = self.target;
    __weak typeof(self) weakSelf = self;
    if (_block) {
        _block(weakSelf);
    }
    if (target && [target respondsToSelector:_action]) {
        [target performSelectorOnMainThread:_action withObject:weakSelf waitUntilDone:true];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}


@end




@interface HKPopMenuTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setInfo:(HKPopMenuItem *)item configuration:(HKPopMenuConfiguration *)configuration;

@end



@implementation HKPopMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"HKPopMenuTableViewCell";
    HKPopMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HKPopMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        cell.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        cell.lineView = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [cell.contentView addSubview:cell.iconImageView];
        [cell.contentView addSubview:cell.titleLabel];
        [cell.contentView addSubview:cell.lineView];
        
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.layer.cornerRadius = 2;
        
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat yMargin = 1;
    CGFloat xMargin = 2;
    CGFloat insetH = CGRectGetHeight(self.lineView.frame);
    CGFloat selectH = CGRectGetHeight(self.bounds) - insetH - yMargin * 2;
    self.selectedBackgroundView.frame = CGRectMake(xMargin, yMargin, CGRectGetWidth(self.bounds) - xMargin * 2, selectH);
}




- (void)setInfo:(HKPopMenuItem *)item configuration:(HKPopMenuConfiguration *)configuration {
    CGFloat margin = configuration.intervalSpacing;
    CGFloat left = configuration.marginXSpacing;
    CGFloat top = configuration.marginYSpacing;
    CGFloat height = configuration.itemHeight;
    CGFloat width = configuration.itemMaxWidth;
    
    CGFloat itemH = height - 2 * top;
    CGFloat itemW = width - 2 * left;
    
    if (configuration.hasSeparatorLine) {
        self.lineView.hidden = false;
        CGFloat insetL = configuration.separatorInsetLeft;
        CGFloat insetR = configuration.separatorInsetRight;
        CGFloat insetH = configuration.separatorHeight;
        self.lineView.backgroundColor = [UIColor clearColor];
        self.lineView.layer.backgroundColor = configuration.separatorColor.CGColor;
        self.lineView.frame = CGRectMake(insetL, height - insetH, width - insetL - insetR, insetH);
    } else {
        self.lineView.hidden = true;
    }
    
    if (item.image) {
        self.iconImageView.hidden = false;
        self.iconImageView.image = item.image;
        self.iconImageView.frame = CGRectMake(left, top, itemH, itemH);
        CGFloat labelX = CGRectGetMaxX(self.iconImageView.frame) + margin;
        
        self.titleLabel.frame = CGRectMake(labelX, top, width - labelX - left, itemH);
        
    } else {
        self.iconImageView.hidden = true;
        self.titleLabel.frame = CGRectMake(left, top, itemW, itemH);
    }
    
    self.titleLabel.text = item.title;
    self.titleLabel.font = item.titleFont;
    self.titleLabel.textColor = item.titleColor;
    self.titleLabel.textAlignment = configuration.alignment;
    self.backgroundColor = configuration.menuBackgroundColor;
    self.selectedBackgroundView.backgroundColor = configuration.selectedColor;
}

@end




@interface HKPopMenuView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray<__kindof HKPopMenuItem *> *menuItems;
@property (nonatomic, strong) HKPopMenuConfiguration *configuration;
@property (nonatomic, assign, readonly) CGPoint startPoint;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) CAShapeLayer *triangleLayer;
@property (nonatomic, strong, readonly) UIView *shadowView;
@property (nonatomic, weak, readonly) UIView *targetView;
@property (nonatomic, weak, readonly) UIView *inView;
@property (nonatomic, assign, readonly) CGRect targetRect;

- (void)dismissPopMenu;

@end

@implementation HKPopMenuView



- (instancetype)initInView:(UIView *)inView withRect:(CGRect)rect menuItems:(NSArray<__kindof HKPopMenuItem *> *)menuItems options:(HKPopMenuConfiguration *)options {
    CGRect frame = [UIScreen mainScreen].bounds;
    if (options.revisedMaskWhenRotationScreen) {
        CGFloat max = MAX(frame.size.width, frame.size.height);
        frame.size = CGSizeMake(max, max);
    }
    if (self = [super initWithFrame:frame]) {
        CGRect vFrame = rect;
        CGPoint centerPoint = CGPointMake(CGRectGetMinX(vFrame) + vFrame.size.width / 2.0, CGRectGetMinY(vFrame) + vFrame.size.height / 2.0);
        _targetRect = rect;
        _inView = inView;
        [self setupWithFrame:vFrame centerPoint:centerPoint menuItems:menuItems options:options];
    }
    return self;
}



- (instancetype)initInView:(UIView *)inView withView:(UIView *)view menuItems:(NSArray<__kindof HKPopMenuItem *> *)menuItems options:(HKPopMenuConfiguration *)options {
    CGRect frame = [UIScreen mainScreen].bounds;
    if (options.revisedMaskWhenRotationScreen) {
        CGFloat max = MAX(frame.size.width, frame.size.height);
        frame.size = CGSizeMake(max, max);
    }
    if (self = [super initWithFrame:frame]) {
        CGRect vFrame = [view.superview convertRect:view.frame toView:inView];
        CGPoint centerPoint = CGPointMake(CGRectGetMinX(vFrame) + vFrame.size.width / 2.0, CGRectGetMinY(vFrame) + vFrame.size.height / 2.0);
        _targetView = view;
        _inView = inView;
        [self setupWithFrame:vFrame centerPoint:centerPoint menuItems:menuItems options:options];
    }
    return self;
}




- (void)setupWithFrame:(CGRect)vFrame centerPoint:(CGPoint)centerPoint menuItems:(NSArray<__kindof HKPopMenuItem *> *)menuItems options:(HKPopMenuConfiguration *)options {
    self.configuration = options;
    self.menuItems = menuItems;
    
    UIFont *itemFont = [UIFont systemFontOfSize:self.configuration.fontSize];
    UIColor *itemTitleColor = self.configuration.titleColor;
    
    [menuItems enumerateObjectsUsingBlock:^(__kindof HKPopMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.titleFont) {
            obj.titleFont = itemFont;
        }
        if (!obj.titleColor) {
            obj.titleColor = itemTitleColor;
        }
    }];
    
    self.backgroundColor = self.configuration.maskBackgroundColor;
    
    CGFloat itemHeight = self.configuration.itemHeight;
    CGFloat menuWidth = self.configuration.itemMaxWidth;
    CGFloat triangleHeight = self.configuration.arrowSize;
    CGFloat triangleMargin = self.configuration.arrowMargin;
    CGFloat menuScreenLeftRightMinMargin = self.configuration.menuScreenMinLeftRightMargin;
    
    CGFloat tableViewH = itemHeight * menuItems.count;
    BOOL isBounces = tableViewH > self.configuration.menuMaxHeight;
    
    if (isBounces) {
        tableViewH = self.configuration.menuMaxHeight;
    }
    
    BOOL isDown = tableViewH + triangleHeight + triangleMargin + CGRectGetMaxY(vFrame) < SCREEN_HEIGHT - self.configuration.menuScreenMinBottomMargin;
    
    CGFloat triangleX = centerPoint.x;
    CGFloat triangleY = isDown ? CGRectGetMaxY(vFrame) + triangleMargin : CGRectGetMinY(vFrame) - triangleMargin;
    
    CGFloat tableViewY = CGRectGetMaxY(vFrame) + triangleHeight + triangleMargin - 0.5 * tableViewH;
    CGFloat tableViewX = triangleX - menuWidth * 0.5;
    
    
    if (!isDown) {
        tableViewY = triangleY - triangleHeight - tableViewH * 0.5;
    }
    
    CGPoint anchorPoint = isDown ? CGPointMake(0.5f, 0.0f) :CGPointMake(0.5f, 1.0f);
    
    //fixed bug: tableViewX < menuScreenLeftRightMinMargin + menuWidth * 0.5
    if (tableViewX < menuScreenLeftRightMinMargin) {
        tableViewX = menuScreenLeftRightMinMargin;
        anchorPoint.x = (triangleX - tableViewX)/menuWidth;
        tableViewX = triangleX - menuWidth * 0.5;
        
    } else if (tableViewX + menuWidth > SCREEN_WIDTH - menuScreenLeftRightMinMargin){
        tableViewX = SCREEN_WIDTH - menuScreenLeftRightMinMargin - menuWidth;
        anchorPoint.x = (triangleX - tableViewX)/menuWidth;
        tableViewX = triangleX - menuWidth * 0.5;
    }
    
    _startPoint = CGPointMake(triangleX, triangleY);
    
    CGRect tableFrame = CGRectMake(tableViewX, tableViewY, menuWidth, tableViewH);
    
    _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = self.configuration.menuBackgroundColor;
    _tableView.layer.cornerRadius = self.configuration.menuCornerRadius;
    _tableView.layer.masksToBounds = true;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = isBounces;
    _tableView.layer.anchorPoint = anchorPoint;
    _tableView.rowHeight = itemHeight;
    [self addSubview:_tableView];
    
    if (self.configuration.shadowOfMenu) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        
        UIView *shadow = [[UIView alloc] init];
        shadow.backgroundColor = [UIColor clearColor];
        shadow.frame = CGRectMake(_startPoint.x, _startPoint.y + triangleHeight, 1, 1);
        if (!isDown) {
            shadow.frame = CGRectMake(_startPoint.x, _startPoint.y - triangleHeight, 1, 1);
        }
        CGRect rect = CGRectMake(_startPoint.x -tableViewX - (anchorPoint.x+ 0.5) * menuWidth, _startPoint.y + triangleHeight - tableViewY - 0.5 *tableViewH, menuWidth, tableViewH);
        if (!isDown) {
            rect.origin.y = tableViewY + triangleHeight - _startPoint.y - 0.5 * tableViewH;
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.configuration.menuCornerRadius];
        shadow.layer.shadowPath = path.CGPath;
        
        shadow.layer.shadowOpacity = 0.8;
        shadow.layer.shadowColor = _configuration.shadowColor.CGColor;
        shadow.layer.shadowOffset = CGSizeMake(0, 1);
        shadow.layer.shadowRadius = 5;
        
        _shadowView = shadow;
        [self insertSubview:shadow belowSubview:_tableView];
        [CATransaction commit];
    }
    
    [self drawTriangleLayerIsDown:isDown];
}



- (void)drawTriangleLayerIsDown:(BOOL)isDown {
    CGFloat triangleHeight = self.configuration.arrowSize;
    CGFloat triangleLength = triangleHeight * 2.0 / 1.732;
    CGPoint point = _startPoint;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (isDown) {
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x - triangleLength * 0.5, point.y + triangleHeight)];
        [path addLineToPoint:CGPointMake(point.x + triangleLength * 0.5, point.y + triangleHeight)];
    } else {
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x - triangleLength * 0.5, point.y - triangleHeight)];
        [path addLineToPoint:CGPointMake(point.x + triangleLength * 0.5, point.y - triangleHeight)];
    }
    
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    triangleLayer.path = path.CGPath;
    triangleLayer.fillColor = _configuration.menuBackgroundColor.CGColor;
    triangleLayer.strokeColor = _configuration.menuBackgroundColor.CGColor;
    
    if (self.configuration.shadowOfMenu) {
        triangleLayer.shadowOpacity = 0.8;
        triangleLayer.shadowColor = _configuration.shadowColor.CGColor;
        triangleLayer.shadowOffset = CGSizeMake(0, 0);
        triangleLayer.shadowRadius = 5;
    }
    
    _triangleLayer = triangleLayer;
    [self.layer insertSublayer:triangleLayer below:_tableView.layer];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.configuration.dismissWhenClickBackground) {
        [HKPopMenu dismissMenu];
        if (self.configuration.dismissBlock) {
            self.configuration.dismissBlock();
        }
    }
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuItems.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.configuration.cellForRowConfig) {
        return self.configuration.cellForRowConfig(tableView, indexPath, self.configuration, self.menuItems[indexPath.row]);
    }
    
    HKPopMenuTableViewCell *cell = [HKPopMenuTableViewCell cellWithTableView:tableView];
    HKPopMenuItem *item = self.menuItems[indexPath.row];
    [cell setInfo:item configuration:self.configuration];
    
    if (indexPath.row == self.menuItems.count - 1) {
        cell.lineView.hidden = true;
    }
    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    HKPopMenuItem *item = self.menuItems[indexPath.row];
    [item performAction];
    [HKPopMenu dismissMenu];
}



- (void)showMenuInView:(UIView *)view {
    [view addSubview:self];
    
    HKPopMenuAnimationStyle style = _configuration.style;
    
    if (style == HKPopMenuAnimationStyleScale) {
        self.tableView.transform = CGAffineTransformIdentity;
        self.shadowView.transform = CGAffineTransformIdentity;
        self.tableView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        self.shadowView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        self.alpha = 0;
        
        [UIView animateWithDuration:kXHDefaultAnimateDuration animations:^{
            self.alpha = 1;
            self.tableView.transform = CGAffineTransformIdentity;
            self.shadowView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
        
    } else if (style == HKPopMenuAnimationStyleFade) {
        self.alpha = 0;
        [UIView animateWithDuration:kXHDefaultAnimateDuration animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}



- (void)dismissPopMenu {
    HKPopMenuAnimationStyle style = _configuration.style;
    
    if (style == HKPopMenuAnimationStyleWeiXin) {
        self.alpha = 1;
        [UIView animateWithDuration:kXHDefaultAnimateDuration animations:^{
            self.tableView.transform = CGAffineTransformMakeScale(0.6, 0.6);
            self.shadowView.transform = CGAffineTransformMakeScale(0.6, 0.6);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissCompletion];
        }];
        
    } else if (style == HKPopMenuAnimationStyleScale) {
        self.alpha = 1;
        [UIView animateWithDuration:kXHDefaultAnimateDuration animations:^{
            self.tableView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            self.shadowView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissCompletion];
        }];
    } else if (style == HKPopMenuAnimationStyleFade) {
        self.alpha = 1;
        [UIView animateWithDuration:kXHDefaultAnimateDuration animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissCompletion];
        }];
    } else if (style == HKPopMenuAnimationStyleNone) {
        [self dismissCompletion];
    }
}


- (void)dismissCompletion {
    self.configuration = nil;
    self.menuItems = nil;
    [self.shadowView removeFromSuperview];
    [self.tableView removeFromSuperview];
    [self.triangleLayer removeFromSuperlayer];
    [self removeFromSuperview];
}

@end




@interface HKPopMenu ()

@property (nonatomic,   weak) HKPopMenuView *popmenuView;
@property (nonatomic, assign) BOOL isObserving;

@end

@implementation HKPopMenu

#pragma mark - public func
+ (void)showMenuInView:(UIView *)inView withRect:(CGRect)rect menuItems:(NSArray<__kindof HKPopMenuItem *> *)menuItems withOptions:(HKPopMenuConfiguration *)options {
    if (options == nil) {
        options = [HKPopMenuConfiguration defaultConfiguration];
    }
    [[self sharedManager] showMenuInView:inView withRect:rect menuItems:menuItems withOptions:options];
}


+ (void)showMenuWithView:(UIView *)view menuItems:(NSArray<__kindof HKPopMenuItem *> *)menuItems withOptions:(HKPopMenuConfiguration *)options {
    [self showMenuInView:nil withView:view menuItems:menuItems withOptions:options];
}


+ (void)showMenuInView:(UIView *)inView withView:(UIView *)view menuItems:(NSArray<__kindof HKPopMenuItem *> *)menuItems withOptions:(HKPopMenuConfiguration *)options {
    if (options == nil) {
        options = [HKPopMenuConfiguration defaultConfiguration];
    }
    [[self sharedManager] showMenuInView:inView withView:view menuItems:menuItems withOptions:options];
}


+ (void)dismissMenu {
    [[self sharedManager] dismissMenu];
}


+ (instancetype)sharedManager{
    static HKPopMenu *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HKPopMenu alloc] init];
    });
    return manager;
}


#pragma mark - implementation
- (void)dealloc {
    if (_isObserving) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}



- (void)showMenuInView:(UIView *)inView withRect:(CGRect)rect menuItems:(NSArray<__kindof HKPopMenuItem *> *)menuItems withOptions:(HKPopMenuConfiguration *)options {
    
    if (_popmenuView) {
        [_popmenuView dismissPopMenu];
        _popmenuView = nil;
    }
    if (!_isObserving) {
        _isObserving = true;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationDidChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    if (!inView) {
        inView = [UIApplication sharedApplication].keyWindow;
    }
    HKPopMenuView *popmenuView = [[HKPopMenuView alloc] initInView:inView withRect:rect menuItems:menuItems options:options];
    _popmenuView = popmenuView;
    [_popmenuView showMenuInView:inView];
}



- (void)showMenuInView:(UIView *)inView withView:(UIView *)view menuItems:(NSArray<__kindof HKPopMenuItem *> *)menuItems withOptions:(HKPopMenuConfiguration *)options {
    
    if (_popmenuView) {
        [_popmenuView dismissPopMenu];
        _popmenuView = nil;
    }
    if (!_isObserving) {
        _isObserving = true;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationDidChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    if (!inView) {
        inView = [UIApplication sharedApplication].keyWindow;
    }
    HKPopMenuView *popmenuView = [[HKPopMenuView alloc] initInView:inView withView:view menuItems:menuItems options:options];
    _popmenuView = popmenuView;
    [_popmenuView showMenuInView:inView];
}

#pragma mark - orientation

- (void)orientationDidChange:(NSNotification *)note {
    HKPopMenuConfiguration *options = _popmenuView.configuration;
    
    if (options.dismissWhenRotationScreen) {
        [self dismissMenu];
    } else {
        NSArray<__kindof HKPopMenuItem *> *menuItems = _popmenuView.menuItems;
        UIView *inView = _popmenuView.inView;
        
        if (_popmenuView.targetView) {
            UIView *withView = _popmenuView.targetView;
            [self dismissMenuAnimation:NO];
            
            // refresh the inView frame
            [inView layoutIfNeeded];
            [inView setNeedsDisplay];
            HKPopMenuAnimationStyle style = options.style;
            options.style = HKPopMenuAnimationStyleNone;
            [self showMenuInView:inView withView:withView menuItems:menuItems withOptions:options];
            options.style = style;
        } else {
            CGRect rect = _popmenuView.targetRect;
            [self dismissMenuAnimation:NO];
            
            // refresh the inView frame
            [inView layoutIfNeeded];
            [inView setNeedsDisplay];
            HKPopMenuAnimationStyle style = options.style;
            options.style = HKPopMenuAnimationStyleNone;
            [self showMenuInView:inView withRect:rect menuItems:menuItems withOptions:options];
            options.style = style;
        }
    }
}

- (void)dismissMenu {
    [self dismissMenuAnimation:YES];
}

- (void)dismissMenuAnimation:(BOOL)animation {
    if (_popmenuView) {
        if (animation) {
            [_popmenuView dismissPopMenu];
        } else {
            [_popmenuView dismissCompletion];
            _popmenuView = nil;
        }
    }
    if (_isObserving) {
        _isObserving = false;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

@end

