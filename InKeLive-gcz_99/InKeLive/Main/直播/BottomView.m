//
//  BottomView.m
//  InKeLive
//
//  Created by 1 on 2016/12/13.
//  Copyright © 2016年 jh. All rights reserved.
//底部工具栏

#import "BottomView.h"
@interface BottomView()<UITextFieldDelegate>

@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"createFlag.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
    NSString *creat= [dict objectForKey:@"createFlag"];
    if ([creat isEqualToString:@"1"]) {
        _createFlag = YES;
    }else{
        _createFlag = NO;
    }
    CGFloat width = (SCREEN_WIDTH - 132)/5;;
    
    for (NSInteger i = 0; i < self.imageArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:self.imageArr[i]] forState:UIControlStateNormal];
        if (i == 4) {
            [button setImage:[UIImage imageNamed:@"living_voice_off"] forState:UIControlStateSelected];
        }
        [button addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 150+i; //由于是循环创建的,所以需要设置tag
        button.frame = CGRectMake(132+i* width, 10, 40, 40);
        [self addSubview:button];
    }
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(4, 14, 115, 32)];
    textField.layer.cornerRadius = 16;
    textField.layer.masksToBounds = YES;
    textField.placeholder = @"  一起来聊天吧";
    textField.font = [UIFont systemFontOfSize:12];
    textField.tag = 100;
    textField.textColor = [UIColor whiteColor];
    textField.delegate = self;
    textField.backgroundColor = RGBA(0, 0, 0, 0.2);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"  一起来聊天吧" attributes:
                                      @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                        NSFontAttributeName:textField.font
                                        }];
    textField.attributedPlaceholder = attrString;
    [self addSubview:textField];
}

- (void)bottomClick:(id)sender{
    UIButton *tagButton = (UIButton *)sender;
    if (self.buttonClick) {
        self.buttonClick(tagButton.tag);
    }
}

- (NSArray *)imageArr{
    //图片数组
    if (_imageArr == nil) {
        NSLog(@"_createFlag == %d",_createFlag);
        if (_createFlag) {
            _imageArr = @[@"living_private_chat",@"living_gift",@"living_turn_camera", @"living_beauty", @"living_voice_on"];
        }else{
           _imageArr = @[@"living_private_chat",@"living_gift"];
        }
    }
    return _imageArr;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if (self.textFieldChangeClick) {
        self.textFieldChangeClick();
    }
}

@end
