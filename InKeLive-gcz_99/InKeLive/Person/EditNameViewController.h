//
//  EditNameViewController.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/30.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditNameViewControllerDelegate <NSObject>
- (void)addNameViewController:(UIViewController *)controller didFinishEnteringName:(NSString *)Name;
@end

@interface EditNameViewController : UIViewController
@property (nonatomic, copy) NSString *strOldName;
@property (nonatomic, weak) id <EditNameViewControllerDelegate> delegate;

@end
