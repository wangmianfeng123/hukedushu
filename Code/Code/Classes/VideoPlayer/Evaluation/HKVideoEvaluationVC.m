//
//  HKVideoEvaluationVC.m
//  Code
//
//  Created by eon Z on 2021/9/2.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKVideoEvaluationVC.h"
#import "LevelView.h"
#import "StarView.h"
#import "VideoServiceMediator.h"
#import "HKPresentVC.h"
#import "HKFeedbackView.h"
#import "HKImgModel.h"
#import "ACActionSheet.h"
#import "UpYunFormUploader.h"
#import "HKCommentImgCell.h"
#import "UIView+HKLayer.h"
#import "HKCommentTipView.h"
#import "UIViewController+FullScreen.h"


@interface HKVideoEvaluationVC ()<StarViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    int i;
}
@property(nonatomic,strong) LevelView *levelView;


@property(nonatomic,strong)HKFeedbackView *feedBackView;

@property(nonatomic,strong)StarView *starView;
@property(nonatomic,copy)NSString *videoId;
@property (nonatomic, strong)UIImagePickerController *imagePickerController;
@property (nonatomic , strong) NSMutableArray * imgArray;
@property (nonatomic , strong) UICollectionView * collectionView;
@property (nonatomic , assign) CGFloat image_height;
@property (nonatomic , assign) CGFloat image_width;
@property (nonatomic , strong) NSMutableDictionary * urlDic;
@property (nonatomic , strong) UIButton * questionBtn;
@property (nonatomic , strong) UIButton * tipBtn;
@property (nonatomic , strong) HKCommentTipView * tipView;

@end

@implementation HKVideoEvaluationVC

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGFloat w = (SCREEN_WIDTH - 11 *2)/3.0;
        layout.itemSize = CGSizeMake(w, w);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.collectionViewLayout = layout;
        _collectionView.showsVerticalScrollIndicator =  NO;
        _collectionView.showsHorizontalScrollIndicator =  NO;
        _collectionView.backgroundColor = COLOR_FFFFFF_333D48;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCommentImgCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKCommentImgCell class])];
    }
    return _collectionView;
}

- (UIButton*)questionBtn {
    if (!_questionBtn) {
        _questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _questionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _questionBtn.backgroundColor = COLOR_F8F9FA_7B8196;
        [_questionBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
        [_questionBtn setTitle:@"我要提问" forState:UIControlStateNormal];
        [_questionBtn addTarget:self action:@selector(questionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_questionBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_ask_2_37" darkImageName:@"ic_ask_dark_2_37"] forState:UIControlStateNormal];
        [_questionBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_ask_sel_2_37" darkImageName:@"ic_ask_sel_dark_2_37"]  forState:UIControlStateSelected];
        [_questionBtn addCornerRadius:12.0];
        [_questionBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:-2];
        _questionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    return _questionBtn;
}

- (UIButton*)tipBtn {
    if (!_tipBtn) {
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_quiz_comment_2_37" darkImageName:@"ic_quiz_comment_dark_2_37"] forState:UIControlStateNormal];
        [_tipBtn addTarget:self action:@selector(tipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
}

- (void)tipBtnClick{
    [self.tipView removeFromSuperview];
    self.tipView = [HKCommentTipView viewFromXib];
    self.tipView.alpha = 0.0;
    [self.view addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.tipBtn.mas_bottom).offset(5);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.tipView.alpha = 0.5;
    }];
}

- (void)questionBtnClick{
    self.questionBtn.selected = !self.questionBtn.selected;
}

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
}
- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    
    self.hk_hideNavBarShadowImage = YES;
    [self createLeftBarButton];
    self.title = @"我要评论";
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    //[self forbidBackGestureRecognizer];
    self.navigationPopGestureRecognizerEnabled = NO;
    [self rightBarButtonItemWithTitle:@"提交" color:COLOR_FF7820 action:@selector(rightBarItemClick)];
    
    [self.view addSubview:self.levelView];
    [self.view addSubview:self.starView];
    [self.view addSubview:self.feedBackView];
    [self.view addSubview:self.questionBtn];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tipBtn];
    self.collectionView.hidden = NO;
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(KNavBarHeight64);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    [self.feedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.levelView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(IS_IPHONE_XS ?210:180);
    }];
    
    [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedBackView.mas_bottom);
        make.left.equalTo(self.view).offset(15);
        make.size.mas_equalTo(CGSizeMake(86, 24));
    }];
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionBtn.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerY.equalTo(self.questionBtn);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.questionBtn.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(11);
        make.right.equalTo(self.view).offset(-11);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(300);
    }];
}

-(void)backAction{
    [self.view endEditing:YES];
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
    comment = self.feedBackView.feedbackView.text;
    
    NSInteger starIndex = self.starView.selectIndex;
    NSInteger levelIndex = self.levelView.selectIndex;
    
    
    if (starIndex <=0) {
        showTipDialog(@"还没有完成评价");
        return;
    }
    
    if (levelIndex <=0 ) {
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
        [self submitCommentWithVideoId:self.videoId score:[NSString stringWithFormat:@"%ld",(long)starIndex]
                             difficult:[NSString stringWithFormat:@"%ld", (long)levelIndex]
                               content:comment
                             imgArrays:nil];
    }
}

- (NSMutableDictionary *)urlDic{
    if (_urlDic == nil) {
        _urlDic = [NSMutableDictionary dictionary];
    }
    return _urlDic;
}

- (StarView*)starView {
    if (!_starView) {
        _starView = [[StarView alloc]init];
        _starView.deletate = self;
    }
    return _starView;
}

- (LevelView*)levelView {
    
    if (!_levelView) {
        _levelView = [[LevelView alloc]init];
    }
    return _levelView;
}

- (HKFeedbackView*)feedBackView {
    if (!_feedBackView) {
        _feedBackView = [[HKFeedbackView alloc]init];
    }
    return _feedBackView;
}


- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
    }
    return _imagePickerController;
}


- (void)submitComment:(NSInteger)selectIndex comment:(NSString *)comment {
    
}

#pragma mark - 提交评论
- (void)submitCommentWithVideoId:(NSString*)videoId  score:(NSString *)score  difficult:(NSString *)difficult  content:(NSString *)content  imgArrays:(NSString *)imgUrlString{
    
    content = isEmpty(content) ?@" ": content;
    
    if (!self.videoId.length) return;

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setSafeObject:self.videoId forKey:@"video_id"];
    [dic setSafeObject:score forKey:@"score"];
    [dic setSafeObject:difficult forKey:@"difficult"];
    [dic setSafeObject:content forKey:@"content"];
    [dic setSafeObject:[NSString stringWithFormat:@"%d",self.questionBtn.selected] forKey:@"is_ask"];
    
    if (imgUrlString.length) {
        [dic setObject:[NSNumber numberWithFloat:self.image_width] forKey:@"image_width"];
        [dic setObject:[NSNumber numberWithFloat:self.image_height] forKey:@"image_height"];
        [dic setObject:imgUrlString forKey:@"pic"];
    }
    
    @weakify(self);
    [HKHttpTool POST:@"/video/submit-comment" parameters:dic success:^(id responseObject) {
        [HKProgressHUD hideHUD];
        @strongify(self)
        if ([CommonFunction detalResponse:responseObject]) {
            //is_commit：0-当日已评论 1-当日首次评论
            NSString *type = [NSString stringWithFormat:@"%@",[responseObject[@"data"] objectForKey:@"is_commit"]];
            if ([type isEqualToString:@"1"]) {
                showDetailTipDialog(@"评价成功", @"当日首次评价,恭喜获得30虎课币");
            }else{
                showTipDialog(@"评价成功");
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [MyNotification postNotificationName:HKPresentVCRefreshNotification object:[HKPresentVC class]];
            });
            [MyNotification postNotificationName:@"refreshVideoCommentData" object:nil];
        }else{
            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        [HKProgressHUD hideHUD];
    }];
}





void showDetailTipDialog(NSString * text,NSString * detailText) {
    
    __block MBProgressHUD *mbStaticProgressHUD = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
    [[[[UIApplication sharedApplication]delegate]window] addSubview:mbStaticProgressHUD];
    mbStaticProgressHUD.layer.zPosition =  INT8_MAX;
    
    mbStaticProgressHUD.bezelView.color = [UIColor blackColor];
    mbStaticProgressHUD.bezelView.alpha = 0.5f;
    mbStaticProgressHUD.label.numberOfLines = 0;
    mbStaticProgressHUD.contentColor = [UIColor whiteColor];
    
    mbStaticProgressHUD.label.text = text;
    mbStaticProgressHUD.label.font = [UIFont systemFontOfSize: (IS_IPHONE6PLUS ? 15:14)];
    mbStaticProgressHUD.mode = MBProgressHUDModeText;
    
    mbStaticProgressHUD.yOffset = -SCREEN_HEIGHT/10;
    
    mbStaticProgressHUD.detailsLabel.text = detailText;
    mbStaticProgressHUD.detailsLabel.font = [UIFont systemFontOfSize: (IS_IPHONE6PLUS ? 13:12)];
        
    [mbStaticProgressHUD showAnimated:YES];
    [mbStaticProgressHUD setRemoveFromSuperViewOnHide:YES];
    [mbStaticProgressHUD hideAnimated:YES afterDelay:1.5];
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
    [self.collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/** 1--获取又拍云 图片上传签名  2---上传图片 */
- (void)getServerUpyunPolicy:(NSData*)imageData withIndex:(int)index{
    NSString * url = nil;
    NSDictionary *dic = nil;
    url = @"/up-yun/generate-upload-token";
    dic = @{@"type":@"2"};
    
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
                                   NSInteger starIndex = self.starView.selectIndex;
                                   NSInteger levelIndex = self.levelView.selectIndex;
                                   [self submitCommentWithVideoId:self.videoId score:[NSString stringWithFormat:@"%ld",(long)starIndex]
                                                        difficult:[NSString stringWithFormat:@"%ld", (long)levelIndex]
                                                          content:self.feedBackView.feedbackView.text
                                                        imgArrays:str];
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
        [self.collectionView reloadData];
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
