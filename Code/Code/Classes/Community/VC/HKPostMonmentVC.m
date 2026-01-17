//
//  HKPostMonmentVC.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPostMonmentVC.h"
#import "HKPostMomentTopView.h"
#import "HKFeedbackView.h"
#import "HKCommentImgCell.h"
#import "HKChooseTopicVC.h"
#import "UpYunFormUploader.h"
#import "HKPostMonmentToolView.h"
#import "HKMonmentTypeModel.h"
#import "ACActionSheet.h"
#import "HKQuestionTipView.h"

@interface HKPostMonmentVC ()<UICollectionViewDelegate,UICollectionViewDataSource,HKFeedbackViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    int uploadTimes;
}
@property(nonatomic,strong)HKFeedbackView *feedBackView;
@property (nonatomic , strong) UICollectionView * collectionView;
@property (nonatomic , strong) NSMutableArray * imgArray;
@property (nonatomic , strong) NSMutableArray * imgUrlArray;
@property (nonatomic, strong)UIImagePickerController *imagePickerController;
@property (nonatomic , strong) HKPostMonmentToolView *toolView;
@property (nonatomic , strong) UIImageView * imgV;
@property (nonatomic , strong) HKQuestionTipView * tipView ;
@end

@implementation HKPostMonmentVC

-(NSMutableArray *)imgUrlArray{
    if (_imgUrlArray == nil) {
        _imgUrlArray = [NSMutableArray array];
    }
    return _imgUrlArray;
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
    }
    return _imagePickerController;
}

-(NSMutableArray *)imgArray{
    if (_imgArray == nil) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGFloat w = IS_IPAD ? (SCREEN_WIDTH -15 * 2)/5.0 : (SCREEN_WIDTH -15 * 2)/3.0;
        layout.itemSize = CGSizeMake(w, w);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.collectionViewLayout = layout;
        _collectionView.showsVerticalScrollIndicator =  NO;
        _collectionView.showsHorizontalScrollIndicator =  NO;
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCommentImgCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKCommentImgCell class])];
    }
    return _collectionView;
}

- (HKFeedbackView*)feedBackView {
    if (!_feedBackView) {
        _feedBackView = [[HKFeedbackView alloc]init];
        _feedBackView.frame = CGRectMake(-10, KNavBarHeight64 + 1, SCREEN_WIDTH+20, 200);
        _feedBackView.longestLenth = 2000;
        _feedBackView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _feedBackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"提问";
    [self createLeftBarButton];
    [self rightBarButtonItemWithTitle:@"发布" color:COLOR_27323F_EFEFF6 action:@selector(postBtnClick)];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    
    // 分割线
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_EFEFF6 dark:COLOR_333D48];
    separator.frame = CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, 0.5);
    [self.view addSubview:separator];
    
    self.feedBackView.feedbackView.layer.borderColor = [UIColor clearColor].CGColor;
    self.feedBackView.pointLabel.text = @"请输入你的问题...";
    [self.view addSubview:self.feedBackView];
    [self.view addSubview:self.collectionView];
    
    
    HKPostMonmentToolView *toolView =[HKPostMonmentToolView viewFromXib];
    toolView.frame = CGRectMake(0, SCREEN_HEIGHT-TAR_BAR_XH-40, SCREEN_WIDTH, 40);
    toolView.didChooseImgBlock = ^{
        if (self.imgArray.count > 9) {
            showTipDialog(@"最多同时上传9张图片");
            return;
        }
        //选图
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    };
    [self.view addSubview:toolView];
    self.toolView = toolView;
    
    
    HKQuestionTipView * tipView = [HKQuestionTipView viewFromXib];
    tipView.frame = CGRectMake(0, SCREEN_HEIGHT-TAR_BAR_XH-40-100, SCREEN_WIDTH, 95);
    [self.view addSubview:tipView];
    self.tipView = tipView;
    
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-TAR_BAR_XH, SCREEN_WIDTH, TAR_BAR_XH)];
    bgView.backgroundColor = COLOR_F8F9FA_333D48;
    [self.view addSubview:bgView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedBackView.mas_bottom);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    [self.feedBackView.feedbackView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)backAction{
    [self.view endEditing:YES];
    if (self.feedBackView.feedbackView.text.length > 0 || self.imgArray.count) {
        NSArray *titleArr =  @[@"放弃发布",@"取消"];
        WeakSelf
        ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {
            if (0 == buttonIndex) {
                [MobClick event: publish_content_cancel];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                //取消
            }
        }];
        [actionSheet show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - keyboard notification
-(void)keyboardShow:(NSNotification*)notification{
    NSDictionary *userinfos = [notification userInfo];
    NSValue *val = [userinfos objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect kbRect = [val CGRectValue];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.toolView.bottom =SCREEN_HEIGHT - kbRect.size.height;
        self.tipView.bottom =SCREEN_HEIGHT - kbRect.size.height-40;
    }];
}

-(void)keyboardHide:(NSNotification*)notification{
    [UIView animateWithDuration:0.3 animations:^{
        self.toolView.bottom =SCREEN_HEIGHT - TAR_BAR_XH;
        self.tipView.bottom =SCREEN_HEIGHT - TAR_BAR_XH-40;
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imgArray.count >= 9) {
        return 9;
    }else{
        return self.imgArray.count + 1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    HKCommentImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCommentImgCell class]) forIndexPath:indexPath];
    if (self.imgArray.count >= 9) {
        cell.imgV.image = self.imgArray[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }else{
        if (indexPath.row == self.imgArray.count) {
            cell.imgV.image = [UIImage hkdm_imageWithNameLight:@"ic_add_upload_2_31" darkImageName:@"ic_add_upload_dark_2_31"];
            cell.deleteBtn.hidden = YES;
        }else{
            cell.imgV.image = self.imgArray[indexPath.row];
            cell.deleteBtn.hidden = NO;
        }
    }
    
    @weakify(self);
    cell.deleteBtnBlock = ^(UIImage * img) {
        @strongify(self);
        [self.imgArray removeObject:img];
        [self.collectionView reloadData];
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.imgArray.count) {
        //选图
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];

    }else{
        //放大
        if (self.imgArray.count) {
            [HKPhotoBrowserTool initPhotoBrowserWithUrlArray:self.imgArray withIndex:indexPath.row delegate:self];
        }
    }
}

#pragma mark ==== HKFeedbackViewDelegate
- (void)postBtnClick{
    if (self.feedBackView.feedbackView.text.length < 5){
        showTipDialog(@"评价至少输入5个文字");
        return;
    }
    if (self.imgArray.count > 9) {
        showTipDialog(@"最多同时上传9张图片");
        return;
    }
    [MobClick event: publish_content_release];

    
    uploadTimes = 0;
    [self.imgUrlArray removeAllObjects];
    if (_imgArray.count) {
        for (UIImage * img in _imgArray) {
            NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
            [self getServerUpyunPolicy:imgData];
        }
    }else{
        [self uploadCommentWithImgUrlArray:nil];
    }
}


#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (originalImage.size.width >10000 || originalImage.size.height >10000) {
        showTipDialog(@"图片尺寸请不要超过10000px*10000px");
        return;
    }
    NSData *imgData = UIImageJPEGRepresentation(originalImage, 0.5);
    if (imgData.length > 1024 * 1024 * 2) {
        showTipDialog(@"图片大小请不要超过2M");
        return;
    }
    if (imgData.length < 10*1024) {
        showTipDialog(@"图片太小请选择一张大图");
        return;
    }
    
    [self.imgArray addObject:originalImage];
    [self.collectionView reloadData];
    self.collectionView.hidden = self.imgArray.count ? NO : YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/** 1--获取又拍云 图片上传签名  2---上传图片 */
- (void)getServerUpyunPolicy:(NSData*)imageData {
    [HKHttpTool POST:@"/up-yun/generate-upload-token" parameters:@{@"type":@"1"} success:^(id responseObject) {
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
        uploadTimes++;
    } failure:^(NSError *error) {
        uploadTimes++;
        if (uploadTimes == self.imgArray.count) {
            showTipDialog(@"图片上传失败");
        }
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
    @weakify(self);
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
                           @strongify(self)
                           if (!isEmpty(imageUrl)) {
                               //获取到图片路径然后上传服务器
                               [self.imgUrlArray addObject:imageUrl];
                               if (self.imgUrlArray.count == self.imgArray.count) {
                                   [self uploadCommentWithImgUrlArray:self.imgUrlArray];
                               }
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

- (void)uploadCommentWithImgUrlArray:(NSMutableArray *)imgUrlArray{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    if ([self.topicModel.ID intValue] == 1) {
        [dic setObject:@"1" forKey:@"type"];
    }else{
        [dic setObject:@"0" forKey:@"type"];
    }
        
    [dic setObject:self.feedBackView.feedbackView.text forKey:@"content"];
    if (imgUrlArray.count) {
        if (imgUrlArray.count == 1) {
            [dic setObject:imgUrlArray[0] forKey:@"images"];
        }else{
            NSString * urlString = nil;
            for (int i = 0; i < self.imgUrlArray.count; i++) {
                if (i == 0) {
                    urlString = self.imgUrlArray[i];
                }else{
                    urlString = [NSString stringWithFormat:@"%@,%@",urlString,self.imgUrlArray[i]];
                }
            }
            [dic setObject:urlString forKey:@"images"];
        }
    }
    
    if ([self.topicModel.ID intValue]) {
        [dic setObject:self.topicModel.ID forKey:@"subjects"];
    }
    
    @weakify(self);
    [HKHttpTool POST:@"/community/create-topic" parameters:dic success:^(id responseObject) {
        [HKProgressHUD hideHUD];
        @strongify(self)
        if ([CommonFunction detalResponse:responseObject]) {
            showTipDialog(@"发布成功");
            [MyNotification postNotificationName:@"postMomentSuccess" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        showTipDialog(@"请检查网络或内容中是否含有特殊字符");
        [HKProgressHUD hideHUD];
    }];
}

@end
