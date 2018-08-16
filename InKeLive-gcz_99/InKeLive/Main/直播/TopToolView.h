//
//  TopToolView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/9.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopToolView : UIView
@property (nonatomic, copy) void (^toolClicked)(UIButton *btn);
@end
