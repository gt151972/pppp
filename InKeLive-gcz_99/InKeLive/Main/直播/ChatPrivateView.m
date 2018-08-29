//
//  ChatPrivateView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/29.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ChatPrivateView.h"
#import "UILabel+WidthAndHeight.h"
#import "DPK_NW_Application.h"
@interface ChatPrivateView()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UIButton* viewBK;

@property (nonatomic, strong) UITableView* userTableView;
@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *btnSend;
@property (weak, nonatomic) NSMutableArray *arrMessageFrame;
@end
@implementation ChatPrivateView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _arrChatMessage = [[NSMutableArray alloc] init];
        _dicMessage = [[NSMutableDictionary alloc] init];
        [self setSubViews];
    }
    return self;
}

- (void)sendMessage:(NSString *)strInfo sendID:(int)sendId receiverID:(int)receiverId{
    int myUserId = [DPK_NW_Application sharedInstance].localUserModel.userID;
    NSArray *allkey = [_dicMessage allKeys];
    BOOL isOld = 0;
    for (int index = 0; index < allkey.count; index ++ ) {//遍历所有对象,没有创建新对象
        if ([[allkey objectAtIndex:index] intValue] == sendId) {
            isOld = 1;
        }
    }
    if (isOld) {//列表中已有对象
        if (myUserId == sendId) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strInfo, @"messageInfo", @"0", @"isMe", nil];
            _arrChatMessage  = [_dicMessage objectForKey:[NSString stringWithFormat:@"%d",sendId]];
            [_arrChatMessage addObject:dic];
            [_dicMessage setValue:_arrChatMessage forKey:[NSString stringWithFormat:@"%d",sendId]];
            _theUserId = receiverId;
        }else if (myUserId == receiverId){
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strInfo, @"messageInfo", @"1", @"isMe", nil];
            _arrChatMessage  = [_dicMessage objectForKey:[NSString stringWithFormat:@"%d",sendId]];
            [_arrChatMessage addObject:dic];
            [_dicMessage setValue:_arrChatMessage forKey:[NSString stringWithFormat:@"%d",sendId]];
            _theUserId = sendId;
        }
        
        [_messageTableView reloadData];
        
    }else{
        if (myUserId == sendId) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strInfo, @"messageInfo", @"1", @"isMe", nil];
            [_arrChatMessage addObject:dic];
            [_dicMessage setValue:_arrChatMessage forKey:[NSString stringWithFormat:@"%d",receiverId]];
            _theUserId = receiverId;
        }else if (myUserId == receiverId){
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strInfo, @"messageInfo", @"0", @"isMe", nil];
            [_arrChatMessage addObject:dic];
            [_dicMessage setValue:_arrChatMessage forKey:[NSString stringWithFormat:@"%d",sendId]];
            _theUserId = sendId;
            [_userTableView reloadData];
        }
        //左边数组添加一行
        NSLog(@"dic == %@",_dicMessage);
        NSLog(@"arr == %@",_arrChatMessage);
        [_messageTableView reloadData];
    }
    
}

-(void) setSubViews {
    [self addSubview:self.viewBK ];
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    viewBg.backgroundColor = [UIColor clearColor];
    [self addSubview:viewBg];
    
    UIView *viewTopBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    viewTopBg.backgroundColor = RGBA(0, 0, 0, 0.8);
    [viewBg addSubview:viewTopBg];
    [viewTopBg addSubview:self.labNameAndId];
    
    [viewBg addSubview:self.userTableView ];
    [viewBg addSubview:self.messageTableView];
    
    UIView *viewButtonBg = [[UIView alloc] initWithFrame:CGRectMake(51, SCREEN_HEIGHT/2-40, SCREEN_WIDTH - 51, 40)];
    viewButtonBg.backgroundColor = RGB(242, 242, 242);
    [viewBg addSubview:viewButtonBg];
    [viewButtonBg addSubview:self.textField];
    [viewButtonBg addSubview:self.btnSend];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
}
- (NSMutableDictionary *)dicMessage{
    if (!_dicMessage) {
        _dicMessage = [[NSMutableDictionary alloc] init];
    }
    return _dicMessage;
}

- (NSMutableArray *)arrChatMessage{
    if (!_arrChatMessage) {
        _arrChatMessage = [[NSMutableArray alloc] init];
    }
    return _arrChatMessage;
}

- (NSMutableArray *)arrUserInfo{
    if (!_arrUserInfo) {
        _arrUserInfo = [NSMutableArray array];
    }
    return _arrUserInfo;
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

- (UILabel *)labNameAndId{
    if (_labNameAndId == nil) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        _labNameAndId = [[UILabel alloc] initWithFrame:frame];
//        _labNameAndId.text =
        _labNameAndId.textColor = [UIColor whiteColor];
        _labNameAndId.textAlignment = NSTextAlignmentLeft;
        _labNameAndId.font = [UIFont systemFontOfSize:13];
    }
    return _labNameAndId;
}

- (UITableView *)userTableView{
    if (_userTableView == nil) {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, 51, SCREEN_HEIGHT - 35) style:UITableViewStylePlain];
        _userTableView.dataSource = self;
        _userTableView.delegate = self;
        _userTableView.rowHeight = 44;
        _userTableView.backgroundColor = RGBA(0, 0, 0, 0.8);
        _userTableView.separatorStyle = UITableViewCellEditingStyleNone;
    }
    return _userTableView;
}

- (UITableView *)messageTableView{
    if (_messageTableView == nil) {
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(51, 35, SCREEN_WIDTH - 51, SCREEN_HEIGHT/2 - 35 - -40) style:UITableViewStylePlain];
        _messageTableView.dataSource = self;
        _messageTableView.delegate = self;
        _messageTableView.backgroundColor = RGBA(0, 0, 0, 0.5);
        _messageTableView.separatorStyle = UITableViewCellEditingStyleNone;
    }
    return _messageTableView;
}

- (UITextField *)textField{
    if (_textField == nil) {
        _textField  = [[UITextField alloc] initWithFrame:CGRectMake(7, 4, SCREEN_WIDTH - 51-7-68, 32)];
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:13];
        _textField.textAlignment = NSTextAlignmentLeft;
    }
    return _textField;
}

-(UIButton*)btnSend {
    if(_btnSend == nil) {
        CGRect frame = CGRectMake(SCREEN_WIDTH - 65 - 51, 4, 60, 33);
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

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _userTableView) {
        static NSString *CellWithIdentifier = @"userTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        }
        //        cell.textLabel.text = @"头像";
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 32, 32)];
        imgHead.layer.masksToBounds = YES;
        imgHead.layer.cornerRadius = 16;
        NSDictionary *dic = [_arrUserInfo objectAtIndex:indexPath.row];
        [imgHead sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"userSmallHeadPic"]] placeholderImage:[UIImage imageNamed:@"default_head"]];
        [cell.contentView addSubview:imgHead];
        return cell;
    }else{
        static NSString *CellWithIdentifier = @"messageTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        }
        cell.backgroundColor = [UIColor clearColor];
        //        cell.backgroundColor = [UIColor redColor];
        if (_arrChatMessage) {
            UIView *viewBg = [[UIView alloc] init];
            viewBg.layer.cornerRadius = 3;
            viewBg.layer.masksToBounds = YES;
            
            UILabel *labMessage = [[UILabel alloc] init];
            labMessage.font = MessageFont;
            labMessage.numberOfLines = 0;
            labMessage.textAlignment = NSTextAlignmentLeft;
            //            labMessage.text = [[_arrChatMessage objectAtIndex:indexPath.row] objectForKey:@"message"];
            labMessage.text = [[[_dicMessage objectForKey:[NSString stringWithFormat:@"%d",_theUserId]] objectAtIndex:indexPath.row] objectForKey:@"messageInfo"];
            CGFloat height = [UILabel getHeightByWidth:labMessage.frame.size.width title:labMessage.text font:labMessage.font];
            labMessage.tag = 6000+indexPath.row;
            NSLog(@"height == %f",height);
            labMessage.frame = CGRectMake(10, 30, SCREEN_WIDTH - 118, height);
            CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 118, 9999);//labelsize的最大值
            CGSize expectSize = [labMessage sizeThatFits:maximumLabelSize];
            labMessage.frame = CGRectMake(8, 10, expectSize.width, expectSize.height);
            NSLog(@"%@",[[_arrChatMessage objectAtIndex:indexPath.row] objectForKey:@"isMee"]);
            if ([[[_arrChatMessage objectAtIndex:indexPath.row] objectForKey:@"isMe"] intValue] == 1) {
                viewBg.backgroundColor = MAIN_COLOR;
                viewBg.frame = CGRectMake(SCREEN_WIDTH - 71 - expectSize.width , 4, expectSize.width + 16, expectSize.height + 20);
            }else{
                viewBg.backgroundColor = [UIColor whiteColor];
                viewBg.frame = CGRectMake(4, 4, expectSize.width + 16, expectSize.height + 20);
            }
            [cell.contentView addSubview:viewBg];
            [viewBg addSubview:labMessage];
        }
        return cell;
    }
    
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _userTableView) {
        return _arrUserInfo.count;
    }else{
        NSArray *array = [NSArray arrayWithArray:[_dicMessage objectForKey:[NSString stringWithFormat:@"%d",_theUserId]]];
        return array.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _userTableView) {
        NSDictionary *dic = [_arrUserInfo objectAtIndex:indexPath.row];
        _theUserId = [[dic objectForKey:@"userId"] intValue];
        //保持左列表排序始终按_arrUserInfo倒叙
//        [_arrUserInfo removeObjectAtIndex:indexPath.row];
//        [_arrUserInfo addObject:dic];
//        [_messageTableView reloadData];
    }else if (tableView == _messageTableView){
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _userTableView) {
        return 40;
    }else{
        UILabel *lab = (UILabel *)[self viewWithTag:6000+indexPath.row];
        return lab.size.height + 28;
    }
}

- (void)popShow {
    //这个Window是什么?
//    [self setSubViews];
//    [self.userTableView reloadData];
//    [self.messageTableView reloadData];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

-(void)hide {
    [self removeFromSuperview];
}

#pragma mark Action
/**
 点击空白处退出
 
 */
- (void)btnBgClicked{
    [self hide];
}

-(void)btnSendClicked{
    if (self.privateChatSend) {
        if (_textField.text.length > 0) {
            self.privateChatSend(_textField.text, self.theUserId);
        }
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    self.frame = CGRectMake(0, -230, SCREEN_WIDTH, SCREEN_HEIGHT);
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

@end
