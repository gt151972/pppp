//
//  WBCheckButton.h
//  InKeLive
//
//  Created by gu  on 17/9/3.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    WBCheckButtonStyleDefault = 0 ,
    WBCheckButtonStyleBox = 1 ,
    WBCheckButtonStyleRadio = 2
} WBCheckButtonStyle;

@interface WBCheckButton : UIControl

@property(nonatomic, weak) id delegate;
@property(nonatomic, strong) UILabel* label;
@property(nonatomic, strong) UIImageView* icon;
@property(nonatomic, assign) WBCheckButtonStyle style;

-(BOOL)isChecked:(id)sender;
-(void)setChecked:(BOOL)bcheck;
-(void)clicked:(id)sender;

@end
