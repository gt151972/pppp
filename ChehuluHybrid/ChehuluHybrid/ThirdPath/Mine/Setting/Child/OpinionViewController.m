//
//  OpinionViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/27.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "OpinionViewController.h"

@interface OpinionViewController ()<UITextViewDelegate>{
    UITextView *textView;
    UILabel *textViewPlaceholderLabel;
    UIButton *btnSubmit;
}
@end

@implementation OpinionViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"意见反馈"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData{
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
}

- (void)initView{
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 170)];
    [viewBg setBackgroundColor:COLOR_MAIN_WHITE];
    [self.view addSubview:viewBg];
    
    textViewPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, gtWIDTH-40, 18)];
    textViewPlaceholderLabel.text = @"请输入您的宝贵意见";
    textViewPlaceholderLabel.textColor = [UIColor grayColor];
    [self.view addSubview: textViewPlaceholderLabel];
    textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, gtWIDTH-40, 130)];
    textView.textColor = COLOR_TEXT_GARY_DEEP;//设置textview里面的字体颜色
    textView.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小
    textView.delegate = self;//设置它的委托方法
    textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    textView.text = @"";//设置它显示的内容
    textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textView.scrollEnabled = YES;//是否可以拖动
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高
    [self.view addSubview:textView];
    
    btnSubmit = [super addButtomSubmit:@"提交"];
    btnSubmit.frame = CGRectMake(20, 210, gtWIDTH - 40, 48);
    [btnSubmit addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setBackgroundColor:COLOR_MAIN_GRAY];
    [self.view addSubview:btnSubmit];
}

//设置textView的placeholder
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""])
    {
        textViewPlaceholderLabel.hidden = YES;
    }
    
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        textViewPlaceholderLabel.hidden = NO;
    }
    
    if (text.length != 0) {
        [btnSubmit setBackgroundColor:COLOR_MAIN_GREEN];
    }else{
        [btnSubmit setBackgroundColor:COLOR_MAIN_GRAY];
    }
    return YES;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
//    UIBarButtonItem *done =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
//    
//    self.navigationItem.rightBarButtonItem = done;
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
//    self.navigationItem.rightBarButtonItem = nil;
//    [btnSubmit setBackgroundColor:COLOR_BG_GRAY];
    
}

- (void)leaveEditMode {
    
    [textView resignFirstResponder];
    
}

- (void)btnCilcked{
    if (textView.text.length > 0) {
        [indexDAL postUserAdviseAddsWithType:[NSString stringWithFormat:@"%d",self.type] msg:textView.text];
    }
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([cmd isEqualToString:@"UserAdviseAdds"]) {
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            [super alert:[dic objectForKey:@"info"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
