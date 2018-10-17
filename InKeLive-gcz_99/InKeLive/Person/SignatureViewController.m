//
//  SignatureViewController.m
//  InKeLive
//
//  Created by 高天的Mac on 2018/8/30.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "SignatureViewController.h"
#import "MBProgressHUD+MJ.h"
@interface SignatureViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labTextNum;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SignatureViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"编辑个性签名";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(btnSubmitClicked)];
    self.navigationItem.rightBarButtonItem.tintColor = TEXT_COLOR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _labTextNum.layer.cornerRadius = 2;
    _labTextNum.layer.masksToBounds = YES;
    int num = [[NSString stringWithFormat:@"%lu",(unsigned long)[self unicodeLengthOfString:_strInfo] ] intValue];
    _labTextNum.text =  [NSString stringWithFormat:@"您最多还能输入%d个字",50-num];
    
    _textView.delegate =self;
    if (_strInfo) {
        _textView.text = _strInfo;
    }else{
        _textView.text = @"今天有什么想和大家分享一下呢？";
    }
    
}

-(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return unicodeLength;
}

#pragma mark Action
- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnSubmitClicked{
    if (![_textView.text isEqualToString:@"今天有什么想和大家分享一下呢？"]) {
        [self.delegate addItemViewController:self didFinishEnteringItem:_textView.text];
    }else{
        [self.delegate addItemViewController:self didFinishEnteringItem:_textView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"今天有什么想和大家分享一下呢？";
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"今天有什么想和大家分享一下呢？"]){
        textView.text=@"";
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    int num = [[NSString stringWithFormat:@"%lu",(unsigned long)[self unicodeLengthOfString:textView.text] ] intValue];
    if (num<0) {
        [MBProgressHUD showAlertMessage:@"长度超出限制"];
        num = 0;
    }
        _labTextNum.text =  [NSString stringWithFormat:@"您最多还能输入%d个字",50-num];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
