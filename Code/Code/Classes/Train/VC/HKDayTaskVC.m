//
//  HKDayTaskVC.m
//  Code
//
//  Created by yxma on 2020/8/27.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKDayTaskVC.h"
#import "HKDayTaskHeaderView.h"
#import "HKDayTaskCell.h"
#import "HKDayTaskSecView.h"
#import "HKPunchClockModel.h"
#import "HKTrainDetailModel.h"
#import "UpYunFormUploader.h"
#import "HtmlShowVC.h"
#import "VideoPlayVC.h"
//#import "HKDayTaskModel.h"
//#import "MyTool.h"
#import "HKPhotoBrowserTool.h"

@interface HKDayTaskVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong)  HKDayTaskSecView *secView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HKDayTaskModel * taskDetailModel;
@property (nonatomic, strong) HKDayTaskHeaderView * headView;
@property (nonatomic, strong)UIImagePickerController *imagePickerController;

@end


@implementation HKDayTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zf_prefersNavigationBarHidden = YES;
    // 兼容iOS11
    HKAdjustsScrollViewInsetNever(self, _tableView);
    self.tableView.backgroundColor = COLOR_F8F9FA_333D48;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKDayTaskCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKDayTaskCell class])];
    [self createHeaderView];
    [MobClick event:dailytask_view];
}

- (void)createHeaderView{
    self.headView = [HKDayTaskHeaderView viewFromXib];
    WeakSelf
    self.headView.backBtnBlock = ^{
        [weakSelf backAction];
    };
    self.tableView.tableHeaderView = self.headView;
}

//使表视图的高度自适应
- (void)layoutHeadView {
 
    //利用systemLayoutSizeFittingSize:计算出真实高度
    CGFloat height = [self.tableView.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect headerFrame = self.tableView.tableHeaderView.frame;
    headerFrame.size.height = height;
    //修改tableHeaderView的frame
    self.tableView.tableHeaderView.frame = headerFrame;
}

- (void)loadData{
    @weakify(self);
    NSDictionary *param = @{@"date_time" : self.date, @"id":self.trainingId};
    [HKHttpTool POST:HK_TrainingTaskList_URL parameters:param success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            self.taskDetailModel = [HKDayTaskModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.headView.taskDetailModel = self.taskDetailModel;
            [self layoutHeadView];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.taskDetailModel.sp_task_list.list.count) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.taskDetailModel.sp_task_list.list.count) {
        if (section) {
            return 3;
        }else{
           return self.taskDetailModel.sp_task_list.list.count;
        }
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HKDayTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKDayTaskCell class])];
    cell.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    cell.taskDetailModel = self.taskDetailModel;
    if (self.taskDetailModel.sp_task_list.list.count) {
        if (indexPath.section == 0) {
            cell.model = self.taskDetailModel.sp_task_list.list[indexPath.row];
        }else{
            cell.indexPath = indexPath;
        }
    }else{
        cell.indexPath = indexPath;
    }
    
    cell.didDeleteBlock = ^{
        @weakify(self);
        NSDictionary *param = @{@"id" : self.taskDetailModel.sp_task_list.user_task_id};
        [HKHttpTool POST:HK_TrainingDeleWork_URL parameters:param success:^(id responseObject) {
            @strongify(self);
            if ([CommonFunction detalResponse:responseObject]) {
                [self loadData];
            }
            showTipDialog(responseObject[@"msg"]);
        } failure:^(NSError *error) {

        }];
    };
    cell.didEnlargeBlock = ^{
        @weakify(self);
        if (self.taskDetailModel.sp_task_list.task_image_url.length) {
            [HKPhotoBrowserTool initPhotoBrowserWithUrl:self.taskDetailModel.sp_task_list.task_image_url];
        }
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.taskDetailModel.sp_task_list.list.count) {
        if (indexPath.section == 0) {
            HKTrainTaskModel * taskModel = self.taskDetailModel.sp_task_list.list[indexPath.row];
            
            if (taskModel.live_status == 1) {
                [MobClick event:dailytask_specialtask_click];
                HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
                vc.live_id = taskModel.sp_task_value;
                [self pushToOtherController:vc];
            }else if (taskModel.live_status == 0){
                showTipDialog(@"课程未开始");
            }else{
                showTipDialog(@"课程已结束");
            }
        }else{
            if (indexPath.row == 0) {
                [self lookVideo];
            }else if (indexPath.row == 1){
                [self uploadProductionData];
            }else{
                [self shareToProduct];
            }
        }
    }else{
        if (indexPath.row == 0) {
            [self lookVideo];
        }else if (indexPath.row == 1){
            [self uploadProductionData];
        }else{
            [self shareToProduct];
        }
    }
}

- (void)lookVideo{
    [MobClick event:dailytask_regulartask_videoclick];
    VideoPlayVC * vc = [[VideoPlayVC alloc] initWithNibName:nil bundle:nil placeholderImage:nil lookStatus:LookStatusInternetVideo videoId:self.taskDetailModel.sp_task_list.video_id fromTrainCourse:YES];
    [self pushToOtherController:vc];
}

- (void)uploadProductionData{
    @weakify(self);
    [self checkloadImgBindPhone:^{
        @strongify(self);
        if (self.taskDetailModel.sp_task_list.clock_open) {
            if (!self.taskDetailModel.sp_task_list.is_clock) {
                [MobClick event:dailytask_regulartask_upload];
                self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:self.imagePickerController animated:YES completion:nil];
            }
        }else{
            if (!self.taskDetailModel.sp_task_list.is_clock) {
                showTipDialog(@"作业已过期");
            }
        }
    } bindPhone:^{
        
    }];
    
}

- (void)shareToProduct{
    if (self.taskDetailModel.sp_task_list.is_clock) {
        [MobClick event:dailytask_regulartask_share];
        HtmlShowVC * vc = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:self.taskDetailModel.sp_task_list.share_url];
        [self pushToOtherController:vc];
    }else{
        showTipDialog(@"请先完成作业上传");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.taskDetailModel.sp_task_list.list.count) {
        if (indexPath.section) {
            if (indexPath.row == 0) {
                return 130;
            }else if (indexPath.row == 1){
                if (self.taskDetailModel.sp_task_list.task_image_url.length) {
                    return 130;
                }else{
                    return 110;
                }
            }else{
                return 110;
            }
        }
        return 130;
    }else{
        if (indexPath.row == 0) {
            return 130;
        }else if (indexPath.row == 1){
            if (self.taskDetailModel.sp_task_list.task_image_url.length) {
                return 130;
            }else{
                return 110;
            }
        }else{
            return 110;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.secView = [HKDayTaskSecView viewFromXib];
    self.secView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    if (self.taskDetailModel.sp_task_list.list.count) {
        self.secView.txtLabel.text = section ? @"作业打卡任务:" : @"特殊任务:";
        if (section) {
            self.secView.tipsImgV.hidden = self.taskDetailModel.sp_task_list.task_image_url.length ? YES : NO;
        }else{
            self.secView.tipsImgV.hidden = YES;
        }
        
    }else{
        self.secView.txtLabel.text = @"作业打卡";
        self.secView.tipsImgV.hidden = self.taskDetailModel.sp_task_list.task_image_url.length ? YES : NO;
    }
    return self.secView;
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate = self;
        //_imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (originalImage.size.width >3000 || originalImage.size.height >10000) {
        showTipDialog(@"图片尺寸请不要超过3000*10000px");
        return;
    }
    NSData *imgData = UIImageJPEGRepresentation(originalImage, 0.5);
    if (imgData.length > 1024 * 1024 * 10) {
        showTipDialog(@"图片大小请不要超过10M");
        return;
    }
    if (imgData.length < 10*1024) {
        showTipDialog(@"图片太小请选择一张大图");
        return;
    }
    [self getServerUpyunPolicy:imgData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/** 1--获取又拍云 图片上传签名  2---上传图片 */
- (void)getServerUpyunPolicy:(NSData*)imageData {
    [HKHttpTool POST:HK_TrainingTaskSignalKey_URL parameters:@{@"tid":self.trainingId} success:^(id responseObject) {
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

/** 将 又拍云 的图片URL 传给 后端 */
- (void)iconUrlToServer:(NSString *)url imageData:(NSData*)imageData {
    @weakify(self);
    [HKHttpTool POST:HK_TrainingTaskSubmitTask_URL parameters:@{@"training_id":self.trainingId,@"video_id":self.taskDetailModel.sp_task_list.video_id,@"image_url":url} success:^(id responseObject) {
        [HKProgressHUD hideHUD];
        @strongify(self)
        if ([CommonFunction detalResponse:responseObject]) {
            //showTipDialog(@"作业已提交");
            showTipDialog(responseObject[@"msg"]);
            [self loadData];
        }else{
            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        [HKProgressHUD hideHUD];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tableView reloadData];
}
@end
