//
//  TakePhoto.h
//  InKeLive
//  选择一张照片
//  Created by 高婷婷 on 2018/8/22.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

//宏定义单例
#define UPLOAD_IMAGE [DUX_UploadUserIcon shareUploadImage]

@protocol TakePhotoDelegate <NSObject>

@optional
// ** 处理图片的方法
- (void)uploadImageToServerWithImage:(UIImage *)image;

@end

@interface TakePhoto : NSObject<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) id <TakePhotoDelegate> uploadImageDelegate;
@property(nonatomic,strong) UIViewController * fatherViewController;

// ** 单例方法
+ (TakePhoto *)shareUploadImage;

// ** 弹出选项窗口的方法
- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC delegate:(id<TakePhotoDelegate>)aDelegate;

@end
