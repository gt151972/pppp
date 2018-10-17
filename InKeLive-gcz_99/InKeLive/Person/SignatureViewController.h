//
//  SignatureViewController.h
//  InKeLive
//
//  Created by 高天的Mac on 2018/8/30.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol signDelegate <NSObject>
- (void)addItemViewController:(UIViewController *)controller didFinishEnteringItem:(NSString *)item;
@end
@interface SignatureViewController : UIViewController
@property (nonatomic, copy) NSString *strInfo;
@property (nonatomic, weak) id <signDelegate> delegate;
@end
