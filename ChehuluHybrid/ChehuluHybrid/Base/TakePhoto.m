//
//  TakePhoto.m
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/12.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "TakePhoto.h"

#define ORIGINAL_MAX_WIDTH 640.0f
#define MAX_IMAGE_SIZE  CGSizeMake(100, 100)

@implementation TakePhoto
- (UIImage *)takePhotoWithVC :(UIViewController*)viewController {
    [self useCameraWithVC:viewController];
    return imagePhoto;
}

- (void)useCameraWithVC: (UIViewController*)viewController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *alertTake = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takeCameraWithVC:viewController];
    }];
    UIAlertAction *alertChoose = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self choosePhotoWithVC:viewController];
    }];
    [alertController addAction:alertCancel];
    [alertController addAction:alertTake];
    [alertController addAction:alertChoose];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)takeCameraWithVC: (UIViewController*)viewController{
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    //    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [viewController presentViewController:imagePickerController animated:YES completion:^{
        
    }];
    //    [self initView];
}
- (void)choosePhotoWithVC: (UIViewController*)viewController{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    //    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [viewController presentViewController:imagePickerController animated:YES completion:^{
        
    }];
    //    [self initView];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@",image);
    imagePhoto = [self imageByScalingToMaxSize:image];
    
//    NSData * imageData = UIImageJPEGRepresentation(image,1);
//    NSLog(@"%lu",([imageData length]/1024));
//    NSLog(@"%@",[self image2DataURL:image]);
//    NSString *strImage = [NSString stringWithFormat:@"ZJJH.renderImageSuccess(\"%@\")",[self image2DataURL:image]];
    //    [[NSUserDefaults standardUserDefaults] setObject:strImage forKey:@"image"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self.wkWebView evaluateJavaScript:strImage completionHandler:nil];
    //    [self initView];
    
    //    [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"ZJJH.renderImageSuccess(\"%@\")",strImage] completionHandler:nil];
}

/**
 *  UIImage -> Base64
 *
 *  @param image 传入图片
 */
- (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    imageData = UIImagePNGRepresentation(image);
    mimeType = @"image/png";
    //    if ([self imageHasAlpha: image]) {
    //        imageData = UIImagePNGRepresentation(image);
    //        mimeType = @"image/png";
    //    } else {
    //        imageData = UIImageJPEGRepresentation(image, 1.0f);
    //        mimeType = @"image/jpeg";
    //    }
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}

#pragma mark image scale utility

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    targetSize = MAX_IMAGE_SIZE;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


@end
