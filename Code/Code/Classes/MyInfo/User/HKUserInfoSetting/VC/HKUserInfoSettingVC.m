//
//  HKUserInfoSettingVC.m
//  Code
//
//  Created by Ivan li on 2018/3/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUserInfoSettingVC.h"
#import "HKUserEditPicCell.h"
#import "HKEditTagCell.h"
#import "HKUserEditTitleCell.h"
#import "HKEditAblumInfoCell.h"
#import "ACActionSheet.h"
#import "HKCategoryAlbumModel.h"
#import "HKEditUserTitleVC.h"
#import "UpYunFormUploader.h"
#import "HKProgressHUD.h"
#import <UMShare/UMShare.h>
#import "HKUserJobVC.h"
#import "HKShareVisibleCellConfig.h"
#import "BindPhoneVC.h"
#import "HKWechatLoginShareCallback.h"


//
//#define UPY_POLICY @"eyJidWNrZXQiOiJodWtlODgtcGljIiwiZXhwaXJhdGlvbiI6MTUyMTc3MDk3NiwiY29udGVudC1sZW5ndGgtcmFuZ2UiOiIxLDgwMjQwMDAwMDAiLCJzYXZlLWtleSI6ImFwcC9hdmF0YXIvMjAxOC0wMy0yMy9BQ0E1ODNBQi1GNTM3LTRERUItOTg5NC1BMTVCMjM5NDlEOEJ7LnN1ZmZpeH0ifQ=="
//
//#define UPY_SIGNATURE  @"7fbb992033c0477c3a1df782f8470bbd"
//空间名
#define UPY_SPACE @"huke88-pic"
//操作员
#define UPY_OPERATER @"huke88ooopic"


typedef NS_ENUM(NSInteger, HKsocialPlatform) {
    HKsocialPlatform_ZERO = 0,
    HKsocialPlatform_QQ = 1, // QQ
    HKsocialPlatform_SINA ,  // SINA
    HKsocialPlatform_WECHAT // WECHAT
};




@interface HKUserInfoSettingVC ()<UITableViewDelegate,UITableViewDataSource,HKImagePickerControllerDelegate,HKEditAblumInfoCellDelegate> {
    HKImagePickerController  *_imagePickerController;
}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)HKUserEditPicCell *editPicCell;

@property(nonatomic,strong)HKCategoryAlbumModel *albumModel;
/** 三方登录平台 */
@property(nonatomic,strong)NSMutableArray *socialPlatformArray;
/** 三方登录平台 */
@property(nonatomic,strong)NSMutableArray *socialTagArray;

@property(nonatomic,assign)NSUInteger socialCount;

@property(nonatomic,strong)HKUserModel *userM;

@property(nonatomic,strong)HKShareVisibleCellConfig *shareVisibleCellConfig;

@end


@implementation HKUserInfoSettingVC




- (void)viewDidLoad {
    [super viewDidLoad];
    [self initImagePickerController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadView {
    [super loadView];
    [self createUI];
}


- (void)createUI {
    self.title = @"编辑资料";
    [self socialTagArray];
    [self socialPlatformArray];
    
    [self createLeftBarButton];
    [self.view addSubview:self.tableView];
    [self refreshUI];
    [self hkDarkModel];
    
    
    
}

- (void)hkDarkModel {
    self.tableView.backgroundColor = COLOR_F8F9FA_333D48;
    self.view.backgroundColor = COLOR_F8F9FA_333D48;
}


- (HKShareVisibleCellConfig*)shareVisibleCellConfig {
    if (!_shareVisibleCellConfig) {
        _shareVisibleCellConfig = [HKShareVisibleCellConfig new];
    }
    return _shareVisibleCellConfig;
}


- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf getServerData];
    }];
    [self getServerData];
}


#pragma mark 获取账号资料数据2

- (void)getServerData {
    
    [HKHttpTool POST:SETTING_ACCOUNT_DATA parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            HKUserModel *userM = [HKUserModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.userM = userM;
            self.shareVisibleCellConfig.userM = userM;
            
            [HKAccountTool shareAccount].job = userM.job;
            [HKAccountTool shareAccount].phone = userM.phone;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}




- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_F8F9FA;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [UIView new];
        
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    if (nil == self.userM) {
//        return 4;
//    }else{
//        return 4 + 3;
//    }
//    if ([[CommonFunction getAPPStatus] isEqualToString:@"1"]) {
//        return 6;
//    }
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3: case 4:case 5:
            return [self.shareVisibleCellConfig numberOfRowsInSection:section];
            break;
        case 6:
            return 1;
            break;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  (0 == indexPath.section) ?100 :44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0: case 1: case 5:
            return 8;
            break;
    }
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if (0 == section) {
        _editPicCell = [HKUserEditPicCell initCellWithTableView:tableView];
        _editPicCell.imageData = UIImageJPEGRepresentation(self.iconImage,1);
        return _editPicCell;
        
    }else if (1 == section) {
        
        NSInteger row = indexPath.row;
        HKUserEditTitleCell *cell = [HKUserEditTitleCell initCellWithTableView:tableView];
        if (0 == row) {
            cell.textLabel.text = @"昵称";
            cell.title = [HKAccountTool shareAccount].username;
            cell.isBind = YES;
        }else{
            cell.textLabel.text = @"职业";
            BOOL isJob = isEmpty(self.userM.job);
            cell.title = isJob ?@"未完成" :self.userM.job;
            cell.isBind = !isJob;
        }
        return cell;
    }else if (2 == section) {
        
        HKUserEditTitleCell *cell = [HKUserEditTitleCell initCellWithTableView:tableView];
        NSString *phone = [CommonFunction getUserPhoneNo];
        cell.title = isEmpty(phone)? @"未绑定":phone;
        cell.isBind = !isEmpty(phone);
        cell.textLabel.text = @"手机";
        return cell;
        
    }else {
        
        switch (section) {
            case 3:
            {
                HKUserEditTitleCell *cell = [HKUserEditTitleCell initCellWithTableView:tableView];
                cell.isBind = self.userM.is_bind_wechat;
                cell.title = cell.isBind ? @"已绑定" :@"未绑定";
                cell.textLabel.text = @"微信";
                return cell;
            }
            case 4:
            {
                HKUserEditTitleCell *cell = [HKUserEditTitleCell initCellWithTableView:tableView];
                cell.isBind = self.userM.is_bind_qq;
                cell.title = cell.isBind ? @"已绑定" :@"未绑定";
                cell.textLabel.text = @"QQ";
                return cell;
            }
            case 5:
            {
                HKUserEditTitleCell *cell = [HKUserEditTitleCell initCellWithTableView:tableView];
                cell.isBind = self.userM.is_bind_weibo;
                cell.title = cell.isBind ? @"已绑定" :@"未绑定";
                cell.textLabel.text = @"微博";
                return cell;
            }
                
            case 6:
            {
                HKUserEditTitleCell *cell = [HKUserEditTitleCell initCellWithTableView:tableView];
                cell.textLabel.text = @"注销账号";
                return cell;
            }
        }
    }
    return [UITableViewCell new];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    if (0 == section) {
        [self getPhoto];
    }
    else{
        [self _tableView:tableView selectRowAtIndexPath:indexPath];
    }
}



- (void)_tableView:(UITableView *)tableView selectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (1 == section) {
        if (0 == row) {
            //昵称
            HKEditUserTitleVC *VC = [HKEditUserTitleVC new];
            VC.indexPath = indexPath;
            VC.editAblumTitleBlock = ^(NSString *title, NSIndexPath *indexPath) {
                HKUserEditTitleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.title = title;
            };
            [self pushToOtherController:VC];
        }else{
            HKUserJobVC *VC = [HKUserJobVC new];
            VC.userJobSelectBlock = ^(HKJobModel *jobModel) {
                StrongSelf;
                //刷新UI
                [strongSelf getServerData];
            };
            [self pushToOtherController:VC];
        }
    }else if (2 == section) {
        
        // 是否关联手机号
        if (isEmpty([CommonFunction getUserPhoneNo])) {
            BindPhoneVC *VC = [BindPhoneVC new];
            VC.bindPhoneType = HKBindPhoneType_Ordinary;
            VC.bindPhoneBlock = ^(NSString *phone) {
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self pushToOtherController:VC];
        }else{
            [MBProgressHUD showTipMessageInWindow:Web_Modify_Phone timer:2];
        }
        
    }else{
        [self _selectSection:indexPath tableView:tableView];
    }
}



- (void)_selectSection:(NSIndexPath *)indexPath  tableView:(UITableView *)tableView {

    HKUserEditTitleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    switch (section) {
        case 3:
            //微信
            [self qiutOrBindPlatform:cell.isBind platform:UMSocialPlatformType_WechatSession indexPath:indexPath];
            break;
        case 4:
            //QQ
            [self qiutOrBindPlatform:cell.isBind platform:UMSocialPlatformType_QQ indexPath:indexPath];
            break;
        case 5:
            //微博
            [self qiutOrBindPlatform:cell.isBind platform:UMSocialPlatformType_Sina indexPath:indexPath];
            break;
            
        case 6:
            //注销账号
            [self logoutAccount];
            break;
    }
}



/** 注销账号 */
- (void)logoutAccount {
    
//    if (isEmpty(self.userM.phone)) {
//        return;
//    }
    
    
    if ([[CommonFunction getAPPStatus] isEqualToString:@"1"]) {
//    if (1) {
        WeakSelf;
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            label.text = @"注销账号";
            label.textColor = COLOR_030303;
            label.font = HK_FONT_SYSTEM_BOLD(15);
        })
        .LeeAddContent(^(UILabel *label) {
            NSString *text = @"关于您在虎课网的所有数据都将会被清除\n您确定要注销虎课网账号吗？";
            //label.text = [NSString stringWithFormat:@"%@%@",text,weakSelf.userM.contact_phone];
            label.text = text;
            label.textColor = COLOR_030303;
            label.font = HK_FONT_SYSTEM(15);
        })
        .LeeAddAction(^(LEEAction *action) {
            action.title = @"确定";
            action.titleColor = COLOR_3D8BFF;
            action.font = HK_FONT_SYSTEM(15);
            action.clickBlock = ^{
                
                [HKProgressHUD showStatus:LMBProgressHUDStatusWaitting text:@"正在注销您的账户，请稍等..."];
                [HKHttpTool POST:USER_deleteAccount parameters:nil success:^(id responseObject) {
                    [HKProgressHUD hideHUD];
                    if (HKReponseOK) {
                        NSLog(@" 成功 退出");
                        NSLog(@"%@",responseObject);
                        signOut();
                        showTipDialog(@"您的账户已被注销，请重新注册账号");
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }
                } failure:^(NSError *error) {

                }];
            };
        })
        .LeeAddAction(^(LEEAction *action) {
            action.title = @"取消";
            action.titleColor = COLOR_555555;
            action.font = HK_FONT_SYSTEM(15);
            action.type = LEEActionTypeCancel;
        })
        .LeeCornerRadius(12)
        .LeeHeaderColor([UIColor whiteColor])
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    }else{
        WeakSelf;
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            label.text = @"注销账号";
            label.textColor = COLOR_030303;
            label.font = HK_FONT_SYSTEM_BOLD(15);
        })
        .LeeAddContent(^(UILabel *label) {
            NSString *text = @"如需要注销虎课账号，请联系客服\n工作日：9:00-22:00\n节假日：9:00-18:00";
            //label.text = [NSString stringWithFormat:@"%@%@",text,weakSelf.userM.contact_phone];
            label.text = text;
            label.textColor = COLOR_030303;
            label.font = HK_FONT_SYSTEM(15);
        })
        .LeeAddAction(^(LEEAction *action) {
            action.title = @"在线客服";
            action.titleColor = COLOR_3D8BFF;
            action.font = HK_FONT_SYSTEM(15);
            action.clickBlock = ^{
    //            NSString *phoneNum = weakSelf.userM.contact_phone;
    //            [CommonFunction callServiceWithPhone:phoneNum];
                //应用内跳转
                [HKH5PushToNative runtimePush:self.userM.kf_url.className arr:self.userM.kf_url.list currectVC:nil];
            };
        })
        .LeeAddAction(^(LEEAction *action) {
            action.title = @"取消";
            action.titleColor = COLOR_555555;
            action.font = HK_FONT_SYSTEM(15);
            action.type = LEEActionTypeCancel;
        })
        .LeeCornerRadius(12)
        .LeeHeaderColor([UIColor whiteColor])
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    }
}




#pragma mark 取消绑定 或者 绑定 第三方
- (void)qiutOrBindPlatform:(BOOL)isBind  platform:(UMSocialPlatformType)platform  indexPath:(NSIndexPath *)indexPath {
    
    if (isBind) {
        [self qiutBindPlatform:platform indexPath:indexPath];
    }else{
        [self clickSocialPlatform:platform indexPath:indexPath];
    }
}


- (void)clickSocialPlatform:(UMSocialPlatformType)platform  indexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    //showWaitingDialogWithView(@"绑定中...", self.view);
    //closeWaitingDialog();
    
    if (platform == UMSocialPlatformType_WechatSession) {
        // 微信登录 微信原生 SDK
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        
        [WXApi sendReq:req completion:^(BOOL success) {
            
        }];
        
        [HKWechatLoginShareCallback sharedInstance].wechatLoginCallback = nil;
        [HKWechatLoginShareCallback sharedInstance].wechatLoginCallback = ^(NSDictionary * _Nonnull userInfoDict) {
            StrongSelf;
            NSString *unionid = userInfoDict[@"unionid"];
            NSString *openid = userInfoDict[@"openid"];
            [strongSelf bindOrQuitWithUnionId:unionid openId:openid platform:platform  indexPath:indexPath];
        };
    }else{
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platform currentViewController:self
                                                       completion:^(id result, NSError *error) {
                                                           
                                                           StrongSelf;
                                                           UMSocialUserInfoResponse *resp = result;
                                                           if (error) {
                                                               showTipDialog(Cancel_Authorized);
                                                           }else{
                                                               // 第三方登录数据(为空表示平台未提供)
                                                            [strongSelf bindOrQuitWithUnionId: resp.unionId openId:resp.openid
                                                                                  platform:platform  indexPath:indexPath];
                                                           }
                                                       }];
    }
}



#pragma mark 绑定 或者 解除绑定 第三方
- (void)bindOrQuitWithUnionId:(NSString*)unionId  openId:(NSString*)openId  platform:(UMSocialPlatformType)platform
                   indexPath:(NSIndexPath *)indexPath {
    
    NSString *client = nil;
    if (platform == UMSocialPlatformType_WechatSession) {
        client = @"2";
    }else if (platform == UMSocialPlatformType_QQ) {
        client = @"1";
    }else {
        client = @"3";
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:(openId.length ?openId :unionId),@"openid",
                              unionId,@"unionid",client,@"client",nil];
    
    __block HKUserEditTitleCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *url = cell.isBind ?SETTING_REMOVE_BIND :SETTING_BIND;
    
    WeakSelf;
    [HKHttpTool POST:url parameters:parameters success:^(id responseObject) {
        
        if (HKReponseOK) {
            StrongSelf;
            if (cell.isBind) {
                cell.title = @"未绑定";
            }else{
                cell.title = @"已绑定";
            }
            
            if (platform == UMSocialPlatformType_WechatSession) {
                strongSelf.userM.is_bind_wechat = !strongSelf.userM.is_bind_wechat;
            }else if (platform == UMSocialPlatformType_QQ) {
                strongSelf.userM.is_bind_qq = !strongSelf.userM.is_bind_qq;
            }else {
                strongSelf.userM.is_bind_weibo = !strongSelf.userM.is_bind_weibo;
            }
            cell.isBind = !cell.isBind;
        }
        NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
        //[HKProgressHUD showMessage:msg afterDelay:2];
        showTipDialog(msg);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


/** 解除绑定 */
- (void)qiutBindPlatform:(UMSocialPlatformType)platformType  indexPath:(NSIndexPath *)indexPath {
    
    if ([self isHaveBind]) {
        [self forbidQiutBind];
        return;
    }
    
    WeakSelf;
    [LEEAlert alert].config
    .LeeAddContent(^(UILabel *label) {
        StrongSelf;
        [label setFont:HK_FONT_SYSTEM(15)];
        UIColor *textColor = COLOR_030303;
        label.textColor = textColor;
        label.text = [strongSelf deleteBindTitle:platformType];
    })
    .LeeAddAction(^(LEEAction *action) {

        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = COLOR_555555;
    })
    .LeeAddAction(^(LEEAction *action) {

        action.type = LEEActionTypeDefault;
        action.title = @"解绑";
        action.titleColor = COLOR_555555;
        action.clickBlock = ^{
            StrongSelf;
            [strongSelf clickSocialPlatform:platformType indexPath:indexPath];
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}




/** 检测 是否 只存在1个 绑定第三方   */
- (BOOL)isHaveBind {
    if (isEmpty(self.userM.phone)) {
        
        int count = 0;
        if (self.userM.is_bind_weibo){
            count ++;
        }
        if (self.userM.is_bind_qq) {
            count ++;
        }
        if (self.userM.is_bind_wechat) {
            count ++;
        }
        if (1 == count) {
            return YES;
        }
        return NO;
    }else{
        return NO;
    }
}


/** 禁止解绑 */
- (void)forbidQiutBind {
    
        [LEEAlert alert].config
        .LeeAddContent(^(UILabel *label) {
            [label setFont:HK_FONT_SYSTEM(15)];
            UIColor *textColor = COLOR_030303;
            label.textColor = textColor;
            label.text = @"当前第三方账号为唯一账号，不可解绑";
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            action.title = @"知道了";
            action.titleColor = COLOR_ff7c00;
            action.backgroundColor = COLOR_ffffff;
        })
        .LeeHeaderColor(COLOR_ffffff)
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
}



- (NSString*)deleteBindTitle:(UMSocialPlatformType)platformType {
    NSString *str = nil;
    if (platformType == UMSocialPlatformType_QQ) {
        str = @"是否确认要解绑？解绑后，\nQQ将不能登录";
    }else if (platformType == UMSocialPlatformType_Sina) {
        str = @"是否确认要解绑？解绑后，\n微博将不能登录";
    }else if (platformType == UMSocialPlatformType_WechatSession) {
        str = @"是否确认要解绑？解绑后，\n微信将不能登录";
    }
    return str;
}







//************************   相机 照片  ***********************//

- (void)getPhoto{
    WeakSelf;
    NSArray *titleArr =  @[@"从相册选择",@"拍照"];
    NSArray *titleColorArr = @[COLOR_0076ff,COLOR_0076ff];
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" cancelTitleColor:COLOR_0076ff destructiveButtonTitle:nil otherButtonTitles:titleArr
                                                    buttonTitleColors:titleColorArr  actionSheetBlock:^(NSInteger buttonIndex) {
                                                        
                                                        if (0 == buttonIndex) {
                                                            //从相册选择
                                                            [weakSelf selectPicFromAlbum];
                                                        }else if (1 == buttonIndex){
                                                            //拍照
                                                            [weakSelf selectPicFromCamera];
                                                        }else{
                                                            //取消
                                                        }
                                                    }];
    [actionSheet show];
}



- (void)initImagePickerController {
    
    if (!_imagePickerController) {
        _imagePickerController = [[HKImagePickerController alloc]initWithIsCaches:NO andIdentifier:@"HKImagePickerController"];
        _imagePickerController.delegate = self;
        // _imagePickerController.isEditImage = NO; //裁剪图片
    }
}


#pragma mark - _imagePickerController  delegate
// 获取 选中的图片
- (void)selectImageFinished:(UIImage *)image{
    
    NSData *imageData = UIImageJPEGRepresentation(image,1);
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:imageData, nil];
    if (array) {
        //NSString *userId = [self getUserId];
        //[self uploadIcon:userId imageData:array];
        [self getServerUpyunPolicy:imageData];
        //[self.editPicCell setImageData:imageData];
    }
}



#pragma mark - 拍照
- (void)selectPicFromCamera {
    //模拟器
    if (TARGET_IPHONE_SIMULATOR == 1) {
        return ;
    }
    WeakSelf;
    [_imagePickerController selectImageFromCameraSuccess:^(UIImagePickerController *imagePickerController) {
        [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
    } fail:^{
        [ weakSelf setAlertView:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机"];
    }];
}



#pragma mark - 从相册选图
- (void)selectPicFromAlbum {
    WeakSelf;
    [_imagePickerController selectImageFromAlbumSuccess:^(UIImagePickerController *imagePickerController) {
        [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
    } fail:^{
        [ weakSelf setAlertView:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册"];
    }];
}





#pragma mark
- (void)setAlertView:(NSString*)title  message:(NSString*)message {
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}





//服务器端签名的表单上传
- (void)upYunloadWithData:(NSData*)imageData policy:(NSString*)policy   signature:(NSString*)signature  operatorName:(NSString*)operator {
    //从 app 服务器获取的上传策略 policy
    //NSString *policy = UPY_POLICY;
    //从 app 服务器获取的上传策略签名 signature
    //NSString *signature = UPY_SIGNATURE;
    
    /*  测试本地图片
     NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
     NSString *filePath = [resourcePath stringByAppendingPathComponent:@"huke.png"];
     NSData *fileData = [NSData dataWithContentsOfFile:filePath];
     */
    
    [HKProgressHUD showStatus:LMBProgressHUDStatusWaitting text:@"上传中"];
    WeakSelf;
    //操作员
    NSString *operatorName = operator;//UPY_OPERATER;
    UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
    [up uploadWithOperator:operatorName
                    policy:policy
                 signature:signature
                  fileData:imageData
                  fileName:nil
                   success:^(NSHTTPURLResponse *response,
                             NSDictionary *responseBody) {
                       NSLog(@"上传成功 responseBody：%@", responseBody);
                       NSString *imageUrl = responseBody[@"url"];
                       // 将url 保存给服务器
                       dispatch_async(dispatch_get_main_queue(), ^(){
                           if (!isEmpty(imageUrl)) {
                               [weakSelf iconUrlToServer:imageUrl imageData:imageData];
                           }
                       });
                   }
                   failure:^(NSError *error,
                             NSHTTPURLResponse *response,
                             NSDictionary *responseBody) {
                       NSLog(@"上传失败 error：%@", error);
                       NSLog(@"上传失败 code=%ld, responseHeader：%@", (long)response.statusCode, response.allHeaderFields);
                       NSLog(@"上传失败 message：%@", responseBody);
                       //主线程刷新ui
                       dispatch_async(dispatch_get_main_queue(), ^(){
                           [HKProgressHUD hideHUD];
                           showTipDialog(@"上传失败");
                       });
                   }
                  progress:^(int64_t completedBytesCount,
                             int64_t totalBytesCount) {
                      NSLog(@"upload progress: %lld / %lld", completedBytesCount, totalBytesCount);
                      //主线程刷新ui
                      dispatch_async(dispatch_get_main_queue(), ^(){
                      });
                  }];
}



/** 1--获取又拍云 图片上传签名  2---上传图片 */
- (void)getServerUpyunPolicy:(NSData*)imageData {
    
    NSString *url = [CommonFunction getBaseUrl];
    [HKHttpTool POST:SITE_UPYUN_SIGN baseUrl:url parameters:nil success:^(id responseObject) {
        
        if (HKReponseOK) {
            NSString *policy = responseObject[@"data"][@"policy"];
            NSString *signature = responseObject[@"data"][@"signature"];
            NSString *operatorName = responseObject[@"data"][@"operator"];
            
            if ([HkNetworkManageCenter shareInstance].networkStatus > 0) {
                
                [self upYunloadWithData:imageData policy:policy signature:signature operatorName:operatorName];
            }else{
                showTipDialog(NETWORK_ALREADY_LOST);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


/** 将 又拍云 的图片URL 传给 后端 */
- (void)iconUrlToServer:(NSString *)url imageData:(NSData*)imageData {
    
    [HKHttpTool POST:USER_UPDATE_AVATOR  parameters:@{@"avator":url} success:^(id responseObject) {
        
        [HKProgressHUD hideHUD];
        
        if (HKReponseOK) {
            NSString *avator = responseObject[@"data"][@"avator"];
            if (!isEmpty(avator)) {
                //showTipDialog(@"上传成功");
                
                [self.editPicCell setImageData:imageData];
                
                //更新用户图片信息
                HKUserModel *model = [HKAccountTool shareAccount];
                model.avator = avator;
                [HKAccountTool saveOrUpdateAccount:model];
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    HK_NOTIFICATION_POST(HKUserInfoChangeNotification, nil);
                });
            }
        }
    } failure:^(NSError *error) {
        [HKProgressHUD hideHUD];
    }];
}


@end




