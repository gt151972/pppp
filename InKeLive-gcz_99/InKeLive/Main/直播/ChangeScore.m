//
//  ChangeScore.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ChangeScore.h"
@interface ChangeScore()<UITextFieldDelegate>{
    NSString *strChangeScore;
    NSString *strChangeGold;
}
@property (nonatomic, strong) UIButton *viewBK;
@property (nonatomic, strong) UIView *viewBg;
@property (nonatomic, strong) UILabel *labChangeScore;
@property (nonatomic, strong) UILabel *labChangeGold;
@property (nonatomic, strong) UIButton *btnSobmit;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation ChangeScore
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        strChangeGold = @"10000";
        strChangeScore = @"";
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    [self viewBK];
    [self viewBg];
    
    [self addSubview:_viewBK];
    [self addSubview:_viewBg];
    
    _labNowScore = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, SCREEN_WIDTH/2-15, 13)];
//    _labNowScore.text = [NSString stringWithFormat:@"当前积分: %d",_nowScore];
    _labNowScore.textColor = TEXT_COLOR;
    _labNowScore.font = [UIFont systemFontOfSize:12];
    _labNowScore.textAlignment = NSTextAlignmentLeft;
    [_viewBg addSubview:_labNowScore];
    _labNowGold = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 15, SCREEN_WIDTH/2-15, 13)];
//    _labNowGold.text = [NSString stringWithFormat:@"当前金币: %d",_nowGold];
    _labNowGold.textColor = TEXT_COLOR;
    _labNowGold.font = [UIFont systemFontOfSize:12];
    _labNowGold.textAlignment = NSTextAlignmentLeft;
    [_viewBg addSubview:_labNowGold];
    
    _labChangeScore = [[UILabel alloc] initWithFrame:CGRectMake(12, 42, SCREEN_WIDTH/2-15, 13)];
    _labChangeScore.text = [NSString stringWithFormat:@"兑换积分: %@",strChangeScore];
    _labChangeScore.textColor = TEXT_COLOR;
    _labChangeScore.font = [UIFont systemFontOfSize:12];
    _labChangeScore.textAlignment = NSTextAlignmentLeft;
    CGSize newSize = [_labChangeScore sizeThatFits:CGSizeZero];
    _labChangeScore.frame = CGRectMake(12, 42, newSize.width, 13);
    [_viewBg addSubview:_labChangeScore];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(12 + newSize.width, 42, SCREEN_WIDTH/2-12- newSize.width, 13)];
    _textField.delegate = self;
    _textField.textColor = TEXT_COLOR;
    _textField.font = [UIFont systemFontOfSize:12];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_viewBg addSubview:_textField];
    
    _labChangeGold = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 42, SCREEN_WIDTH/2-15, 13)];
    _labChangeGold.text = [NSString stringWithFormat:@"对应金币: %@",_textField.text];
    _labChangeGold.textColor = TEXT_COLOR;
    _labChangeGold.font = [UIFont systemFontOfSize:12];
    _labChangeGold.textAlignment = NSTextAlignmentLeft;
    [_viewBg addSubview:_labChangeGold];
    
    NSArray *arrTitle = @[@"全部兑换", @"10000币\n10000积分", @"50000币\n50000积分"];
    CGFloat width = (SCREEN_WIDTH - 48.0)/3;
    for (int index = 0; index < 3; index ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(index*(width + 12) + 12, 72, width, 45)];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [button setTitle:[arrTitle objectAtIndex:index] forState:UIControlStateNormal];
        [button setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [button setBackgroundColor:RGB(230, 230, 230)];
//        if (index == 0) {
//            button.selected = YES;
//            [button setBackgroundColor:MAIN_COLOR];
//        }
        button.tag = 400+index;
        [button addTarget:self action:@selector(btnChange:) forControlEvents:UIControlEventTouchUpInside];
        if (index > 0) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[arrTitle objectAtIndex:index]];
            [attrStr addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR range:NSMakeRange(0, 6)];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 6)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:RGB(151, 151, 151) range:NSMakeRange(7, 7)];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(7, 7)];
            [button.titleLabel setAttributedText:attrStr];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        }
        [_viewBg addSubview:button];
    }
    _btnSobmit = [[UIButton alloc] initWithFrame:CGRectMake(12, 130, SCREEN_WIDTH - 24, 30)];
    [_btnSobmit setBackgroundColor:MAIN_COLOR];
    [_btnSobmit setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [_btnSobmit setTitle:@"确定兑换" forState:UIControlStateNormal];
    [_btnSobmit addTarget:self action:@selector(btnSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    [_viewBg addSubview:_btnSobmit];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeOneCI:) name:UITextFieldTextDidChangeNotification object:_textField];
}
-(UIButton*)viewBK {
    if(_viewBK == nil) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _viewBK = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewBK.frame = frame;
        _viewBK.backgroundColor = [UIColor clearColor];
        _viewBK.tag = 2000;
        [_viewBK addTarget:self action:@selector(btnBgClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewBK;
}

- (UIView *)viewBg{
    if (_viewBg == nil) {
        CGRectMake(0, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 170);
        _viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 170)];
        _viewBg.backgroundColor = [UIColor whiteColor];
        if (kIs_iPhoneX) {
            _viewBg.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        }
    }
    return _viewBg;
}

#pragma mark Action
- (void)btnBgClicked{
    [self hide];
}

- (void)btnChange:(UIButton *)button{
    UIButton *button1 = (UIButton *)[_viewBg viewWithTag:400];
    UIButton *button2 = (UIButton *)[_viewBg viewWithTag:401];
    UIButton *button3 = (UIButton *)[_viewBg viewWithTag:402];
    button.selected = !button.selected;
    if (button.tag == 400) {
        button2.selected = NO;
        button3.selected = NO;
        [button2 setBackgroundColor:RGB(230, 230, 230)];
        [button3 setBackgroundColor:RGB(230, 230, 230)];
        _textField.text = strChangeScore;
    }else if (button.tag == 401){
        button1.selected = NO;
        button3.selected = NO;
        [button1 setBackgroundColor:RGB(230, 230, 230)];
        [button3 setBackgroundColor:RGB(230, 230, 230)];
        _textField.text = [NSString stringWithFormat:@"10000"];
    }else if (button.tag == 402){
        button1.selected = NO;
        button2.selected = NO;
        [button1 setBackgroundColor:RGB(230, 230, 230)];
        [button2 setBackgroundColor:RGB(230, 230, 230)];
        _textField.text = [NSString stringWithFormat:@"50000"];
    }
    _labChangeGold.text = [NSString stringWithFormat:@"对应金币: %@",_textField.text];
    if (button.selected) {
        [button setBackgroundColor:MAIN_COLOR];
    }else{
        [button setBackgroundColor:RGB(230, 230, 230)];
    }
}

- (void)btnSubmitClick{
    if (self.commendChangeClick) {
        if (_textField.text.length > 0) {
            int score = [_textField.text intValue];
            self.commendChangeClick(score);
        }
        [self hide];
    }
}

- (void)popShow{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

-(void)hide{
    [self removeFromSuperview];
}

- (void)updateUserMoney:(long long)nk NB:(long long)nb {
    NSString* strNK=@"";
    NSString* strNB=@"";
    strNB =[NSString stringWithFormat:@"当前积分: %lld", nb];
    strNK = [NSString stringWithFormat:@"当前金币: %lld", nk];
    strChangeScore = [NSString stringWithFormat:@"%lld",nb];
    strChangeGold = [NSString stringWithFormat:@"%lld",nk];
    self.labNowScore.text = strNB;
    self.labNowGold.text = strNK;
}

#pragma mark UITextFieldDelegate
-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification {
    UITextField *textfield=[notification object];
   _labChangeGold.text = [NSString stringWithFormat:@"对应金币: %@",textfield.text];
}
@end
