//
//  HKImagePickerController.m
//  Code
//
//  Created by pg on 2017/2/24.
//
//

#import "HKImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Blur.h"

@interface HKImagePickerController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController * imagePickerController;

@property (nonatomic,strong) UIImage * image;

@end



//是否采用裁剪后的图片
static BOOL jh_isEditImage = YES;

@implementation HKImagePickerController

- (void)setIsEditImage:(BOOL)isEditImage{
    jh_isEditImage = isEditImage;
}

#pragma mark - 初始化方法
- (instancetype)initWithIsCaches:(BOOL)isCaches andIdentifier:(NSString *)identifier{
    self = [super init];
    if (self) {
        self.isCaches = isCaches;
        self.identifier = identifier;
    }
    return self;
}

#pragma mark - 来自相机
- (void)selectImageFromCameraSuccess:(CameraSuccess)success fail:(CameraFail)failure{
    
    if (failure) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
            failure(self.imagePickerController);
            return;
        }
    }
    if (success) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            success(self.imagePickerController);
        }
    }
}

#pragma mark - 来自相簿
- (void)selectImageFromAlbumSuccess:(AlbumSuccess)success fail:(AlbumFail)failure{
    
    if (@available(iOS 9.0, *)) {
        
        PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
        switch (photoAuthorStatus) {
          case PHAuthorizationStatusAuthorized:
            {
                if (success) {
                    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    success(self.imagePickerController);
                }
            }
              break;
            
            case PHAuthorizationStatusNotDetermined:
            {
                @weakify(self);
                [self selectPhotoRequestAuthorization:^(UIImagePickerController *imagePickerController) {
                    @strongify(self);
                    if (success) {
                        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        success(self.imagePickerController);
                    }
                }];
            }
                break;
                
            case PHAuthorizationStatusDenied:
            case PHAuthorizationStatusRestricted:
            {
                if (failure) {
                    failure(self.imagePickerController);
                }
                return;
            }
              break;
          default:
              break;
        }
    }else{
        if (failure) {
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
                failure(self.imagePickerController);
                return;
            }
        }
        if (success) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            success(self.imagePickerController);
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *jpeg = (NSString *)kUTTypeJPEG;
    NSString *typeImage = (NSString *)kUTTypeImage;
    NSString *png = (NSString *)kUTTypePNG;

    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:jpeg] || [mediaType isEqualToString:typeImage] || [mediaType isEqualToString:png]) {
        
        UIImage *image = [UIImage new];
        image = (jh_isEditImage ?info[UIImagePickerControllerEditedImage] :info[UIImagePickerControllerOriginalImage]);
        //对图片进行处理 改变尺寸 压缩
         //self.image = [UIImage imageByScalingAndCroppingForSize:CGSizeMake(120, 120) source:image];
        double size = image.size.height*image.size.width;
        if ( size > 640 * 640){
    
            CGRect thumbnailRect = CGRectZero;
            thumbnailRect.origin = CGPointMake(0, 0);
            thumbnailRect.size.width  = 640;
            thumbnailRect.size.height = 640;
            UIGraphicsBeginImageContext(thumbnailRect.size);// 裁剪图片
    
            [image drawInRect:thumbnailRect];
            self.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }else{
            self.image = [image copy];
        }
        
        //self.image = (jh_isEditImage ?info[UIImagePickerControllerEditedImage] :info[UIImagePickerControllerOriginalImage]);
        //NSString * url = info[UIImagePickerControllerMediaURL];
        
        if (self.isCaches == true && self.identifier != nil && ![self.identifier  isEqual: @""]) {
            if ([self.delegate respondsToSelector:@selector(selectImageFinishedAndCaches:cachesIdentifier:isCachesSuccess:)]) {
                BOOL cachesStatus = [self saveImageToCaches:self.image
                                                 identifier:self.identifier];
                [self.delegate selectImageFinishedAndCaches:self.image
                                           cachesIdentifier:self.identifier
                                            isCachesSuccess:cachesStatus];
            }
        }
        else if ([self.delegate respondsToSelector:@selector(selectImageFinished:)]) {
            [self.delegate selectImageFinished:self.image];
        }
    }
     [picker dismissViewControllerAnimated:YES completion:nil];
}


//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
//{
//    /*添加处理选中图像代码*/
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    //    [picker dismissModalViewControllerAnimated:YES];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}



#pragma mark - 读取缓存的图片
- (UIImage *)readImageFromCachesIdentifier:(NSString *)identifier {
    NSString * path = [NSString stringWithFormat:@"%@/%@",cachesPath(),identifier];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData * imgeData = [[NSFileManager defaultManager] contentsAtPath:path];
        if (imgeData) {
            UIImage * image = [[UIImage alloc]initWithData:imgeData];
            return image;
        }
    }
    return nil;
}

#pragma mark - 删除指定缓存的图片
- (BOOL)removeCachePictureForIdentifier:(NSString *)identifier {
    NSString * path = [NSString stringWithFormat:@"%@/%@",cachesPath(),identifier];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        NSError * error ;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error) {
            NSLog(@"remove picture for id:%@ failure",identifier);
            return false;
        }
        return true;
    }
    return false;
}

#pragma mark - 删除全部图片
- (BOOL)removeCachePictures{
    if ([[NSFileManager defaultManager]fileExistsAtPath:cachesPath()]) {
        NSError * error;
        [[NSFileManager defaultManager] removeItemAtPath:cachesPath() error:&error];
        if (error) {
            NSLog(@"remove pictures fail , error : %@ , path = %@",error,cachesPath());
            return false;
        }
        return true;
    }
    return false;
}

#pragma mark - 缓存图片
- (BOOL)saveImageToCaches:(UIImage *)image identifier:(NSString *)identifier {
    NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
    if (imageData) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachesPath()]) {
            NSError * error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:cachesPath()
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                NSLog(@"create cache dir error: %@   path: %@",error,cachesPath());
                return false;
            }
            NSLog(@"creat cache dir success :%@",cachesPath());
        }
        if (self.identifier) {
            NSString * path = [NSString stringWithFormat:@"%@/%@",cachesPath(),self.identifier];
            BOOL isSuccess = [[NSFileManager defaultManager] createFileAtPath:path
                                                                     contents:imageData
                                                                   attributes:nil];
            if (isSuccess) {
                return YES;
            }
        }
    }
    return false;
}



- (UIImagePickerController *)imagePickerController{
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = jh_isEditImage;
        _imagePickerController.mediaTypes  = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeJPEG,(NSString *)kUTTypePNG];
    }
    return _imagePickerController;
}



static inline NSString * cachesPath(){
    return [NSString stringWithFormat:@"%@/jhImageCaches",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true)[0]];
}

- (void)dealloc{
//    NSLog(@"dealloc : %@",self);
}






+ (void)hk_savedPhotosAlbum:(NSString*)URL {
    

    if (@available(iOS 9.0, *)) {
        
        PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
        switch (photoAuthorStatus) {
          case PHAuthorizationStatusAuthorized:
            {
                if (!isEmpty(URL)) {
                    [[SDWebImageManager sharedManager] loadImageWithURL:HKURL(URL) options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {

                        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                    }];
                }
            }
              break;
            
            case PHAuthorizationStatusNotDetermined:
            {
                [self savePhotoRequestPhotoAuthorization:URL];
            }
              break;
            case PHAuthorizationStatusDenied:
            case PHAuthorizationStatusRestricted:
            {
                NSLog(@"Denied or Restricted");
                [ self setAlertView:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册"];
                return;
            }
              break;
          default:
              break;
        }
        
    }else{
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
            [ self setAlertView:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册"];
            return;
        }
        
        [[SDWebImageManager sharedManager] loadImageWithURL:HKURL(URL) options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }];
    }
}




- (void)selectPhotoRequestAuthorization:(AlbumSuccess)success{
    
    @weakify(self);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        @strongify(self);
    if (status == PHAuthorizationStatusAuthorized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(self.imagePickerController);
            }
        });
    }
    else {
        NSLog(@"Denied or Restricted");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ self class]setAlertView:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册"];
        });
        return;
    }
    }];
}



+ (void)savePhotoRequestPhotoAuthorization:(NSString *)URL {
    
    @weakify(self);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        @strongify(self);
    if (status == PHAuthorizationStatusAuthorized) {
        if (!isEmpty(URL)) {
            [[SDWebImageManager sharedManager] loadImageWithURL:HKURL(URL) options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {

                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }];
        }
    }
    else {
        NSLog(@"Denied or Restricted");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ self class]setAlertView:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册"];
        });
        return;
    }
    }];
}



+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo; {
    if (error) {
        //保存失败
        showTipDialog(@"保存失败");
    } else {
        //保存失败
        showTipDialog(@"保存成功");
    }
}



#pragma mark
+ (void)setAlertView:(NSString*)title  message:(NSString*)message {
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}





@end
