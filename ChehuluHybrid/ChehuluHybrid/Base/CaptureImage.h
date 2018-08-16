//
//  CaptureImage.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/1/6.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CaptureImage : NSObject

- (UIImage *)captureScreenView:(UIView *)view;

- (UIImage *)captureScreenScrollView:(UIScrollView *)scrollView;
@end
