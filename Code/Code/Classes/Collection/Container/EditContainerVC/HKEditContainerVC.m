//
//  HKEditContainerVC.m
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//
#import "HKEditContainerVC.h"
#import "HKEditPicCell.h"
#import "HKEditTagCell.h"
#import "HKEditTitleCell.h"
#import "HKEditAblumInfoCell.h"
#import "ACActionSheet.h"
#import "HKEditAblumTitleVC.h"
#import "HKContainerTagVC.h"
#import "HKCategoryAlbumModel.h"
#import "UpYunFormUploader.h"
#import "HKAlbumListModel.h"


@interface HKEditContainerVC ()<UITableViewDelegate,UITableViewDataSource,HKImagePickerControllerDelegate,HKEditAblumInfoCellDelegate> {
    HKImagePickerController  *_imagePickerController;
}



@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)HKEditPicCell *editPicCell;

@property(nonatomic,strong)HKCategoryAlbumModel *albumModel;
/** 删除专辑 */
@property(nonatomic,strong)UIButton *deleteBtn;
/** 图片URL */
@property(nonatomic,copy)NSString *imageUrl;
/** 封面图片 */
@property(nonatomic,strong)UIImage *coverImage;
/** 专辑名 */
@property(nonatomic,copy)NSString *albumName;
/** 专辑简介 */
@property(nonatomic,copy)NSString *albumInfo;

@end




@implementation HKEditContainerVC

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
    self.title = @"编辑专辑";
    [self createLeftBarButton];
    [self rightBarButtonItemWithTitle:@"完成" color:COLOR_27323F_EFEFF6 action:@selector(rightBarItemAction:)];
    self.view.backgroundColor = COLOR_F8F9FA_333D48;
    [self.view addSubview:self.tableView];
    [self getAlbumInfoWithAlbumId:self.albumId];
}


- (void)rightBarItemAction:(id)sender {
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:2];
    HKEditAblumInfoCell *cell = [self.tableView cellForRowAtIndexPath:index];

    if ([cell.placeholderTextView isFirstResponder]) {
        [cell.placeholderTextView resignFirstResponder];
    }else{
        [self submitEditInfo];
    }
}


- (UIButton*)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithTitle:@"删除专辑" titleColor:[UIColor colorWithHexString:@"#FF3221"] titleFont:@"16" imageName:nil];
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_A8ABBE];
        _deleteBtn.backgroundColor = bgColor;
        _deleteBtn.clipsToBounds = YES;
        _deleteBtn.layer.cornerRadius = PADDING_5;
        _deleteBtn.frame = CGRectMake(PADDING_15, 22, SCREEN_WIDTH-PADDING_30, 45);
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}


- (void)deleteBtnClick:(UIButton*)btn {
    [self deleteAlbumRequest:self.albumId];
}


#pragma mark 删除专辑
- (void)deleteAlbumRequest:(NSString*)albumId {
    
    if (!isEmpty(albumId)) {
        NSDictionary *dict = @{@"album_id":albumId};
        [HKHttpTool POST:ALBUM_DELETE_ALBUM parameters:dict success:^(id responseObject) {
            if (HKReponseOK) {
                [self popToCollectionAlbumVC];
                NSDictionary *dict = @{@"albumId":albumId};
                HK_NOTIFICATION_POST_DICT(HKDeleteAlbumNotification, nil, dict);
            }
        } failure:^(NSError *error) {
            
        }];
    }
}


#pragma mark 返回到专辑列表页
- (void)popToCollectionAlbumVC {
    NSInteger index = [[self.navigationController viewControllers]indexOfObject:self];
    if (2 <= index) {
        UIViewController *VC = [self.navigationController.viewControllers objectAtIndex:index-2];
        if (VC) {
            [self.navigationController popToViewController:VC animated:YES];
        }
    }
}




- (UIView*)tableFooterView {
    
    UIView *footerView = [UIView new];
    UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
    footerView.backgroundColor = bgColor;

    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45+22);
    [footerView addSubview:self.deleteBtn];
    return footerView;
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor hkdm_colorWithColorLight:COLOR_eeeeee dark:COLOR_333D48];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_F8F9FA_333D48;
        //_tableView.tableFooterView = [self tableFooterView];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        [_tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0)];
    }
    return _tableView;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  isEmpty(self.albumModel.album_id)?0 :3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (0 == section) {
        return 1;
    }else if (1 == section) {
        return 1;
    }else if (2 == section) {
        return 2;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (0 == section) {
        return 80;
    }else if (1 == section) {
        return 50;
    }else if (2 == section){
        if (0 == row) {
            return 50;
        }else{
            return 180;
        }
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.05;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (0 == section) {
        _editPicCell = [HKEditPicCell initCellWithTableView:tableView];
        _editPicCell.model = self.albumModel;
        return _editPicCell;
    }else if (1 == section) {
        if (0 == row) {
            HKEditTitleCell *cell = [HKEditTitleCell initCellWithTableView:tableView];
            cell.title = self.albumModel.name;
            return cell;
        }else{
            HKEditTagCell *cell = [HKEditTagCell initCellWithTableView:tableView];
            cell.model = self.albumModel;
            return cell;
        }
    }else if (2 == section){
        if (0 == row) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKIntroductionCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKIntroductionCell"];
                cell.textLabel.text = @"简介";
                [cell.textLabel setTextColor:COLOR_27323F_EFEFF6];
                [cell.textLabel setFont:HK_FONT_SYSTEM(PADDING_15)];
            }
            return cell;
        }else{
            HKEditAblumInfoCell *cell = [HKEditAblumInfoCell initCellWithTableView:tableView];
            cell.delegate = self;
            cell.introduceText = self.albumModel.introduce;
            return cell;
        }
    }
    return [UITableViewCell new];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (0 == section) {
        [self getPhoto];
        
    }else if (1 == section) {
        
        if (0 == row) {
            WeakSelf;
            HKEditAblumTitleVC *VC = [HKEditAblumTitleVC new];
            VC.indexPath = indexPath;
            VC.editAblumTitleBlock = ^(NSString *title, NSIndexPath *indexPath) {
                HKEditTitleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.title = title;
                weakSelf.albumName = title;
            };
            [self pushToOtherController:VC];
            
        }else{
            HKContainerTagVC *VC = [[HKContainerTagVC alloc]initWithModel:self.albumModel];
            //[[HKContainerTagVC alloc]initWithModelArray:self.albumModel.label_list];
            [self pushToOtherController:VC];
        }
    }
}




#pragma mark -- HKEditAblumInfoCell delegate
- (void)albumInfo:(NSString *)text {
    NSLog(@"albumInfo -- %@",text);
    self.albumInfo = text;
}




//************************   相机 照片  ***********************//

- (void)getPhoto {
    WeakSelf;
    NSArray *titleArr =  @[@"从相册选择",@"拍照"];
    NSArray *titleColorArr = @[COLOR_0076ff,COLOR_0076ff];
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil
                                                    cancelButtonTitle:@"取消"
                                                     cancelTitleColor:COLOR_0076ff                  destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:titleColorArr
                                                     actionSheetBlock:^(NSInteger buttonIndex) {
                                                        
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
- (void)selectImageFinished:(UIImage *)image{
    
    self.coverImage = image;
    NSData *imageData = UIImageJPEGRepresentation(image,0.5);
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:imageData, nil];
    if (array) {
        [self getServerUpyunPolicy:imageData];
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
- (void)setAlertView:(NSString*)title  message:(NSString*)message{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - 专辑信息
- (void)getAlbumInfoWithAlbumId:(NSString*)albumId{
    
    NSDictionary *dict = @{@"album_id":albumId};
    [HKHttpTool POST:ALBUM_EDIT parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            HKCategoryAlbumModel *model = [HKCategoryAlbumModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.albumModel = model;
            self.tableView.tableFooterView = [self tableFooterView];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}




#pragma mark - 提交专辑修改信息
- (void)submitEditInfo {
    
    //album_id 合集id     //name  合集名称    //introduce   合集介绍
    //cover 封面图地址   //label_id  标签ID，多个标签用英文逗号隔开
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.albumId forKey:@"album_id"];
    
    NSString *name = (isEmpty(self.albumName) ?self.albumModel.name :self.albumName);
    [parameters setValue:name forKey:@"name"];
    
    NSString *albumInfo = (isEmpty(self.albumInfo)?self.albumModel.introduce :self.albumInfo);
    [parameters setValue:albumInfo forKey:@"introduce"];
    
    
    NSString *imageUrl = (isEmpty(self.imageUrl)?self.albumModel.cover :self.imageUrl);
    [parameters setValue:imageUrl forKey:@"cover"];
    
    //[parameters setValue:@"0" forKey:@"label_id"];
    
    
    [HKHttpTool POST:ALBUM_UPDATE parameters:parameters success:^(id responseObject) {
        if (HKReponseOK) {
            self.model.name = name;
            self.model.introduce = albumInfo;
            
            if (!isEmpty(self.imageUrl)) {
                NSString * url = @"https://pic.huke88.com/";
                self.model.cover = [NSString stringWithFormat:@"%@%@",url,self.imageUrl];;
            }
            self.hKEditContainerVCBlock ?self.hKEditContainerVCBlock(self.model) :nil;
            [self backAction];
        }
    } failure:^(NSError *error) {
        
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
            }
        }
    } failure:^(NSError *error) {
        
    }];
}




//服务器端签名的表单上传
- (void)upYunloadWithData:(NSData*)imageData policy:(NSString*)policy   signature:(NSString*)signature  operatorName:(NSString*)operator {
    
    WeakSelf;
    [HKProgressHUD showStatus:LMBProgressHUDStatusWaitting text:@"上传中"];
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
                       // 将url 保存给服务器
                       NSString *imageUrl = responseBody[@"url"];
                       dispatch_async(dispatch_get_main_queue(), ^(){
                           [HKProgressHUD hideHUD];
                           if (!isEmpty(imageUrl)) {
                               weakSelf.imageUrl = imageUrl;
                               [weakSelf.editPicCell setImage:weakSelf.coverImage];
                               showTipDialog(@"上传成功");
                           }
                       });
                   }
                   failure:^(NSError *error,
                             NSHTTPURLResponse *response,
                             NSDictionary *responseBody) {
                       NSLog(@"上传失败 message：%@", responseBody);
                       //主线程刷新ui
                       dispatch_async(dispatch_get_main_queue(), ^(){
                           [HKProgressHUD hideHUD];
                           showTipDialog(@"上传失败");
                       });
                   }
                  progress:^(int64_t completedBytesCount,
                             int64_t totalBytesCount) {
                      dispatch_async(dispatch_get_main_queue(), ^(){
                          
                      });
                  }];
}




@end



