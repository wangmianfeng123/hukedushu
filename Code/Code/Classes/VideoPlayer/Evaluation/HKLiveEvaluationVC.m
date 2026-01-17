//
//  HKLiveEvaluationVC.m
//  Code
//
//  Created by eon Z on 2021/9/2.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKLiveEvaluationVC.h"
#import "LevelView.h"
#import "StarView.h"
#import "VideoServiceMediator.h"
#import "HKPresentVC.h"
#import "HKFeedbackView.h"
#import "HKCommentContentView.h"
#import "HKImgModel.h"
#import "ACActionSheet.h"
#import "UpYunFormUploader.h"
#import "HKCommentImgCell.h"
#import "UIViewController+FullScreen.h"


@interface HKLiveEvaluationVC ()<StarViewDelegate,HKCommentContentViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    int i;
}

@property(nonatomic,strong)StarView *starView;
@property(nonatomic,copy)NSString *videoId;
@property (nonatomic , strong) HKCommentContentView * contentView;
@property (nonatomic, strong)UIImagePickerController *imagePickerController;
@property (nonatomic , strong) NSMutableArray * imgArray;
@property (nonatomic , assign) CGFloat image_height;
@property (nonatomic , assign) CGFloat image_width;
@property (nonatomic , strong) NSMutableDictionary * urlDic;
@end

@implementation HKLiveEvaluationVC

-(NSMutableArray *)imgArray{
    if (_imgArray == nil) {
        _imgArray = [[NSMutableArray alloc] init];
    }
    return _imgArray;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.videoId = videoId;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.contentView.hidden =  NO;
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    
    self.hk_hideNavBarShadowImage = YES;
    [self createLeftBarButton];
    self.title = @"我要评价";
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    //[self forbidBackGestureRecognizer];
    self.navigationPopGestureRecognizerEnabled = NO;
    [self rightBarButtonItemWithTitle:@"提交" color:COLOR_FF7820 action:@selector(rightBarItemClick)];
    
    [self.view addSubview:self.starView];
    [self.view addSubview:self.contentView];
    

    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(KNavBarHeight64);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(440);
    }];
}

-(void)backAction{
    NSArray *titleArr =  @[@"放弃评论",@"继续评论"];
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {
               if (0 == buttonIndex) {
                   [self.navigationController popViewControllerAnimated:YES];
               }else{
                   //取消
               }
    }];
    [actionSheet show];
}

- (void)rightBarItemClick {
    
    NSString *comment = nil;
    comment = self.contentView.feedBackView.feedbackView.text;
    
    NSInteger starIndex = self.starView.selectIndex;
    
    if (starIndex <=0) {
        showTipDialog(@"还没有完成评价");
        return;
    }
        
    if (comment.length<5) {
        showTipDialog(@"评价至少输入5个文字");
        return;
    }
    
    //上传图片
    i = 0;
    if (_imgArray.count) {
        for (int i = 0; i < _imgArray.count; i++) {
            UIImage * img = _imgArray[i];
            NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
            [self getServerUpyunPolicy:imgData withIndex:i];
        }
    }else{
        [self uploadCommentWithImgUrlArray:nil];
    }
}

- (NSMutableDictionary *)urlDic{
    if (_urlDic == nil) {
        _urlDic = [NSMutableDictionary dictionary];
    }
    return _urlDic;
}

-(HKCommentContentView *)contentView{
    if (_contentView == nil) {
        _contentView = [[HKCommentContentView alloc] init];
        _contentView.delegate = self;
        _contentView.dataArray = self.imgArray;
    }
    return _contentView;
}

- (StarView*)starView {
    if (!_starView) {
        _starView = [[StarView alloc]init];
        _starView.deletate = self;
    }
    return _starView;
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
    }
    return _imagePickerController;
}

#pragma mark ======= HKCommentContentViewDelegate
-(void)commentContentViewChooseImg{
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
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
    if (self.imgArray.count >= 5) return;
    [self.imgArray addObject:originalImage];
    self.contentView.dataArray = self.imgArray;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/** 1--获取又拍云 图片上传签名  2---上传图片 */
- (void)getServerUpyunPolicy:(NSData*)imageData withIndex:(int)index{
    NSString * url = nil;
    NSDictionary *dic = nil;
    url = HK_LiveCommentSignalKey_URL;
    dic = @{@"live_id":self.videoId};
    
    [HKHttpTool POST:url parameters:dic success:^(id responseObject) {
        if (HKReponseOK) {
            NSString *policy = responseObject[@"data"][@"policy"];
            NSString *signature = responseObject[@"data"][@"signature"];
            NSString *operatorName = responseObject[@"data"][@"operator"];
            
            if ([HkNetworkManageCenter shareInstance].networkStatus > 0) {

                [self upYunloadWithData:imageData policy:policy signature:signature operatorName:operatorName withIndex:index];
            }else{
                showTipDialog(NETWORK_ALREADY_LOST);
            }
        }
        i++;
    } failure:^(NSError *error) {
        i++;
        if (i == self.imgArray.count) {
            showTipDialog(@"图片上传失败");
        }
    }];
}

//服务器端签名的表单上传
- (void)upYunloadWithData:(NSData*)imageData policy:(NSString*)policy signature:(NSString*)signature  operatorName:(NSString*)operator withIndex:(int)index {
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
                               if (index == 0) {
                                   self.image_width = [responseBody[@"image-width"] floatValue];
                                   self.image_height = [responseBody[@"image-height"] floatValue];
                               }
                               //获取到图片路径然后上传服务器
                               [self.urlDic setObject:imageUrl forKey:[NSString stringWithFormat:@"%d",index]];
                               
                               if (self.urlDic.count == self.imgArray.count) {
                                   NSString * str = [self getNeedSignStrFrom:self.urlDic];
                                   [self uploadCommentWithImgUrlArray:str];
                                   
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

- (void)uploadCommentWithImgUrlArray:(NSString *)imgUrlString{
    if (!self.videoId.length) return;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.videoId forKey:@"live_id"];
    NSInteger starIndex = self.starView.selectIndex;
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)starIndex] forKey:@"score"];
    [dic setObject:self.contentView.feedBackView.feedbackView.text forKey:@"content"];
    if (imgUrlString.length) {
            [dic setObject:imgUrlString forKey:@"images_url"];
    }
    
    @weakify(self);
    [HKHttpTool POST:@"/live/comment-add" parameters:dic success:^(id responseObject) {
        [HKProgressHUD hideHUD];
        @strongify(self)
        if ([CommonFunction detalResponse:responseObject]) {
            showTipDialog(@"评价成功");
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [MyNotification postNotificationName:@"refreshCommentData" object:nil];
            });
            
        }else{
            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        [HKProgressHUD hideHUD];
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imgArray.count == 5) {
        return 5;
    }else{
        return self.imgArray.count + 1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    HKCommentImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCommentImgCell class]) forIndexPath:indexPath];
    if (self.imgArray.count == 5) {
        cell.imgV.image = self.imgArray[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }else{
        if (indexPath.row == self.imgArray.count) {
            cell.imgV.image = [UIImage imageNamed:@"ic_frame_2_30"];
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
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.imgArray.count) {
        [self commentContentViewChooseImg];
    }else{
        //放大
        if (self.imgArray.count) {
            [HKPhotoBrowserTool initPhotoBrowserWithUrlArray:self.imgArray withIndex:indexPath.row delegate:self];
        }
    }
}


//字典按key排序
-(NSString *)getNeedSignStrFrom:(id)obj{
    NSDictionary *dict = obj;
    NSArray *arrPrimary = dict.allKeys;
    
    NSArray *arrKey = [arrPrimary sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;//NSOrderedAscending 倒序
    }];
    
    NSString*str =@"";
    //NSString*dicStr =@"";
    for (NSString *s in arrKey) {
        id value = dict[s];
        if([value isKindOfClass:[NSDictionary class]]) {
            value = [self getNeedSignStrFrom:value];
        }
        if([str length] !=0) {
            str = [str stringByAppendingString:@"|"];
        }
        str = [str stringByAppendingFormat:@"%@",value];

        //dicStr = [dicStr stringByAppendingFormat:@"%@:%@",s,value];
        
    }
//    NSLog(@"打印字典字符串str:%@",dicStr);
//    NSLog(@"打印图片url字符串str:%@",str);
    
    return str;
}

@end
