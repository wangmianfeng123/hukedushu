//
//  HKBookRateVC.m
//  Code
//
//  Created by Ivan li on 2019/12/24.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookRateVC.h"
#import "HKBookTimerCell.h"
  
#import "HKBookModel.h"
#import "HKEnumerate.h"
#import "GKPlayer.h"



@interface HKBookRateVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray <HKBookModel*>*dataSource;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UIView *bgView;

@property (nonatomic, assign)NSInteger currentSelectTimeIndex;




@end

@implementation HKBookRateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}



- (void)createUI {
    
    self.zf_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self setupHeaderView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [self.bgView addGestureRecognizer:tapGesture];
    
    [self.tableView reloadData];
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.4];
    }
    return _bgView;
}


- (void)tapGestureClick {
    [self closeBtnClick];
}



- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2) style:UITableViewStyleGrouped];
        [_tableView registerClass:[HKBookRateCell class] forCellReuseIdentifier:NSStringFromClass([HKBookRateCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.rowHeight = 50;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [UIView new];
        
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}




- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.height = 50;
    headerView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.tableView.tableHeaderView = headerView;
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightSemibold);
    titleLabel.textColor = COLOR_27323F_EFEFF6;
    titleLabel.text = @"倍速播放";
    [titleLabel sizeToFit];
    titleLabel.x = 15;
    titleLabel.centerY = headerView.height * 0.5;
    [headerView addSubview:titleLabel];
    
    // 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:imageName(@"ic_pulldown_v2_14") forState:UIControlStateNormal];
    [closeBtn setImage:imageName(@"ic_pulldown_v2_14") forState:UIControlStateSelected];
    closeBtn.width = 35;
    closeBtn.height = headerView.height;
    closeBtn.x = self.view.width - closeBtn.width;
    closeBtn.centerY = headerView.height * 0.5;
    [headerView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setHKEnlargeEdge:20];
    
    // 分割线
    UIView *separator = [[UIView alloc] init];
    separator.frame = CGRectMake(0, headerView.height - 1, self.view.width, 1);
    separator.backgroundColor = COLOR_F8F9FA_333D48;
    [headerView addSubview:separator];
}



- (void)closeBtnClick {
    self.bgView.backgroundColor = [UIColor clearColor];
    [self dismissViewControllerAnimated:YES completion:^{ }];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKBookModel *model = self.dataSource[indexPath.row];
    HKBookRateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKBookRateCell class]) forIndexPath:indexPath];
    cell.bookModel = model;
    return cell;
}

#pragma mark <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dataSource enumerateObjectsUsingBlock:^(HKBookModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.is_selected = (idx == indexPath.row)? YES :NO;
    }];
    
    // 保存速率
    [self saveBookPlayRateIndex:indexPath.row +1];
    
    HKBookModel *model = self.dataSource[indexPath.row];
    if (self.bookRateVCCellClick) {
        self.bookRateVCCellClick(model, [model.title floatValue],indexPath.row +1);
    }
    [tableView reloadData];
    [self closeBtnClick];
    
    [self umRateEvent:indexPath];
}


#pragma mark - 友盟统计
- (void)umRateEvent:(NSIndexPath*)indexPath {
    
    switch (indexPath.row) {
        case 0:
            [MobClick event:um_hukedushu_speedpage_0_75];
            break;
        case 1:
            [MobClick event:um_hukedushu_speedpage_1_0X];
            break;
        case 2:
            [MobClick event:um_hukedushu_speedpage_1_25X];
            break;
        case 3:
            [MobClick event:um_hukedushu_speedpage_1_5X];
            break;
        case 4:
            [MobClick event:um_hukedushu_speedpage_2_0X];
            break;
            
        default:
            break;
    }
}


- (void)saveBookPlayRateIndex:(NSInteger)index {
    [HKNSUserDefaults setInteger:index forKey:HKBookPlayRateIndex];
    [HKNSUserDefaults synchronize];
}


- (NSMutableArray<HKBookModel*>*)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSInteger index = [HKNSUserDefaults integerForKey:HKBookPlayRateIndex];
        for (int i = 0; i< 5; i++) {
            HKBookModel *model = [HKBookModel new];
            switch (i) {
                case 0:
                    model.title = @"0.75";
                    model.is_selected = NO;
                    break;
                case 1:
                    model.title = @"1.0";
                    model.is_selected = NO;
                    break;
                case 2:
                    model.title = @"1.25";
                    model.is_selected = NO;
                    break;
                    
                case 3:
                    model.title = @"1.5";
                    model.is_selected = NO;
                    break;
                case 4:
                    model.title = @"2.0";
                    model.is_selected = NO;
                    break;
            }
            if (index > 0) {
                if (index - 1 == i) {
                    model.is_selected = YES;
                }
            }else{
                if (1 == i ) {
                    model.is_selected = YES;
                }
            }
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}


@end






@implementation HKBookRateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}



- (void)createUI {
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.selectIV];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.centerY.right.equalTo(self.contentView);
    }];
    
    [self.selectIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.centerY.equalTo(self.titleLB);
    }];
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _titleLB;
}




- (UIImageView*)selectIV {
    if (!_selectIV) {
        _selectIV = [UIImageView new];
        _selectIV.image = imageName(@"ic_right1_v2_14");
        _selectIV.hidden = YES;
    }
    return _selectIV;
}

- (void)setBookModel:(HKBookModel *)bookModel {
    _bookModel = bookModel;
    self.titleLB.text = [NSString stringWithFormat:@"%@X",bookModel.title];
    if ([bookModel.title isEqualToString:@"1.0"]) {
        self.titleLB.text = [NSString stringWithFormat:@"%@X（正常速度）",bookModel.title];
    }
    self.titleLB.textColor = bookModel.is_selected ? COLOR_FF3221 :COLOR_27323F_EFEFF6;
    self.selectIV.hidden = !bookModel.is_selected;
}


@end
