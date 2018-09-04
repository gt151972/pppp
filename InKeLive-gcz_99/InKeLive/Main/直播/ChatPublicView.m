//
//  ChatPublicView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/3.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ChatPublicView.h"
#import "MBProgressHUD+MJ.h"
#import "DPK_NW_Application.h"
@interface ChatPublicView()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIButton *viewBK;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *btnSend;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ChatPublicView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _arrayUser = [NSMutableArray array];
//        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"大家", @"userName", @"0", @"userId", nil];
//        [_arrayUser addObject:dic];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    [self viewBK];
    [self textField];
    [self btnSend];
    [self tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
    [self addSubview:_viewBK];
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40)];
    viewBg.backgroundColor = RGB(243, 243, 243);
    [self addSubview:viewBg];
    
    _btnUserChoose = [[UIButton alloc] initWithFrame:CGRectMake(5, 4, SCREEN_WIDTH/3-10, 33)];
    [_btnUserChoose setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [_btnUserChoose setBackgroundColor:[UIColor whiteColor]];
    _btnUserChoose.layer.masksToBounds = YES;
    _btnUserChoose.layer.cornerRadius = 3;
    _btnUserChoose.layer.borderColor = GRAY_COLOR.CGColor;
    _btnUserChoose.layer.borderWidth = 0.3;
    _btnUserChoose.titleLabel.font = [UIFont systemFontOfSize:14];
    _btnUserChoose.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnUserChoose setTitle:@"@大家一起说的" forState:UIControlStateNormal];
    [_btnUserChoose addTarget:self action:@selector(btnUserChooseClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [viewBg addSubview:_btnUserChoose];
    [viewBg addSubview:_textField];
    [viewBg addSubview:_btnSend];
    [self addSubview:_tableView];
    [_tableView setHidden:YES];
    
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

- (UITextField *)textField{
    if (_textField == nil) {
        _textField  = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 4, SCREEN_WIDTH*2/3-58, 32)];
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.layer.masksToBounds = YES;
        _textField.layer.cornerRadius = 3;
        _textField.layer.borderColor = GRAY_COLOR.CGColor;
        _textField.layer.borderWidth = 0.3;
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:13];
        _textField.textAlignment = NSTextAlignmentLeft;
    }
    return _textField;
}

-(UIButton*)btnSend {
    if(_btnSend == nil) {
        CGRect frame = CGRectMake(SCREEN_WIDTH - 65, 4, 60, 33);
        _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSend.frame = frame;
        _btnSend.backgroundColor = MAIN_COLOR;
        [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
        [_btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnSend.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btnSend addTarget:self action:@selector(btnSendClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSend;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, SCREEN_HEIGHT - 140, SCREEN_WIDTH/3-10, 100) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = GRAY_COLOR;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.rowHeight = 25;
        _tableView.delegate =self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)sendMessage:(NSString *)strInfo sendID:(int)sendId receiverID:(int)receiverId{
    
}




- (void)popShow{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

-(void)hide{
    [self removeFromSuperview];
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"chatPublicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.textLabel.text = [[_arrayUser objectAtIndex:indexPath.row] objectForKey:@"userName"];
    cell.textLabel.textColor = RGB(32, 32, 32);
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_btnUserChoose setTitle:[NSString stringWithFormat:@"@%@",[[_arrayUser objectAtIndex:indexPath.row] objectForKey:@"userName"]] forState:UIControlStateNormal];
    self.strNanme = [[_arrayUser objectAtIndex:indexPath.row] objectForKey:@"userName"];
    self.userId = [[[_arrayUser objectAtIndex:indexPath.row] objectForKey:@"userId"] intValue];
    [_tableView setHidden:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayUser.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (void)keyboardAction:(NSNotification*)sender{
    // 通过通知对象获取键盘frame: [value CGRectValue]
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // <注意>具有约束的控件通过改变约束值进行frame的改变处理
    if([sender.name isEqualToString:UIKeyboardWillShowNotification]){
        //        self.toBottom.constant = [value CGRectValue].size.height;
        self.frame = CGRectMake(0, -[value CGRectValue].size.height, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}


#pragma mark Action
-(void)btnBgClicked{
    [self hide];
}

-(void)btnUserChooseClicked{
    [_tableView setHidden:!_tableView.hidden];
}

- (void)btnSendClicked{
    if (_textField.text.length <= 0) {
        [MBProgressHUD showAlertMessage:@"不能发送空内容"];
    }else{
        if (self.publicChatSend) {
            self.publicChatSend(_textField.text, self.userId, self.strNanme);
        }
        _textField.text = @"";
    }
}

@end
