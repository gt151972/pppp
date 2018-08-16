//
//  TakePhoto.h
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/12.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TakePhoto : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImage *imagePhoto;
}
- (UIImage *)takePhotoWithVC :(UIViewController*)viewController;
@end
