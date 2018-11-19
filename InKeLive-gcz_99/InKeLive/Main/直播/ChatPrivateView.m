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
@property (nonatomic, strong)UIButton *btnDelete;
@property (weak, nonatomic) NSMutableArray *arrMessageFrame;
@end
@implementation ChatPrivateView
static const CGFloat kHeight=285.0;
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _arrChatMessage = [[NSMutableArray alloc] init];
        _dicMessage = [[NSMutableDictionary alloc] init];
        
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
//        [self reloadDateForTableView];
        
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
//        [self reloadDateForTableView];
    }
    
}

-(void) setSubViews {
    [self addSubview:self.viewBK ];
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kHeight, SCREEN_WIDTH, kHeight)];
    if (kIs_iPhoneX) {
        viewBg.frame = CGRectMake(0, SCREEN_HEIGHT-kHeight-34, SCREEN_WIDTH, kHeight+34);
    }
    viewBg.backgroundColor = [UIColor clearColor];
    [self addSubview:viewBg];
    
    UIView *viewTopBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    viewTopBg.backgroundColor = RGBA(0, 0, 0, 0.8);
    [viewBg addSubview:viewTopBg];
    [viewTopBg addSubview:self.labNameAndId];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 1, 32, 32)];
    [btnClose setImage:[UIImage imageNamed:@"living_close"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnBgClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewTopBg addSubview:btnClose];
    [viewBg addSubview:self.userTableView ];
    [viewBg addSubview:self.messageTableView];
    
    UIView *viewButtonBg = [[UIView alloc] initWithFrame:CGRectMake(51, kHeight-40, SCREEN_WIDTH - 51, 40)];
    if (kIs_iPhoneX) {
        viewButtonBg.frame = CGRectMake(51, kHeight-40, SCREEN_WIDTH - 51, 40 + 34);
    }
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
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(51, 35, SCREEN_WIDTH - 51, kHeight - 35 -40) style:UITableViewStylePlain];
        _messageTableView.dataSource = self;
        _messageTableView.delegate = self;
        _messageTableView.backgroundColor = RGBA(0, 0, 0, 0.5);
        _messageTableView.separatorStyle = UITableViewCellEditingStyleNone;
        _messageTableView.scrollsToTop = NO;
        _messageTableView.allowsSelection = NO;
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
    NSLog(@"_arrChatMessage == %@",_arrChatMessage);
    if(tableView == self.messageTableView){
        static NSString *CellWithIdentifier = @"messageTableViewCell";
        UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        }
        cell.backgroundColor = [UIColor clearColor];
        //        cell.backgroundColor = [UIColor redColor];
        if (_arrChatMessage && _nowRow >= 0 && _lastRow == _nowRow) {
            BOOL haveKey = NO;
            NSArray *arrKey = [[_arrChatMessage objectAtIndex:_nowRow] allKeys] ;
            for (int index = 0; index < arrKey.count; index ++) {
                if ([arrKey[index] isEqualToString:@"message"]) {
                    haveKey = YES;
                    break;
                }
            }
            if (haveKey) {
                NSArray *arr = [[_arrChatMessage objectAtIndex:_nowRow] objectForKey:@"message"];
                UIView *viewBg = [[UIView alloc] init];
                viewBg.layer.cornerRadius = 3;
                viewBg.layer.masksToBounds = YES;
                
                UILabel *labMessage = [[UILabel alloc] init];
                labMessage.font = MessageFont;
                labMessage.numberOfLines = 0;
                labMessage.textAlignment = NSTextAlignmentLeft;
                labMessage.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"msg"];
                CGFloat height = [UILabel getHeightByWidth:labMessage.frame.size.width title:labMessage.text font:labMessage.font];
                labMessage.tag = 6000+indexPath.row;
                NSLog(@"height == %f",height);
                labMessage.frame = CGRectMake(10, 30, SCREEN_WIDTH - 118, height);
                CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 118, 9999);//labelsize的最大值
                CGSize expectSize = [labMessage sizeThatFits:maximumLabelSize];
                labMessage.frame = CGRectMake(8, 10, expectSize.width, expectSize.height);
                NSLog(@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"isMe"]);
                if ([[[arr objectAtIndex:indexPath.row] objectForKey:@"isMe"] intValue] == 1) {
                    viewBg.backgroundColor = MAIN_COLOR;
                    viewBg.frame = CGRectMake(SCREEN_WIDTH - 71 - expectSize.width , 4, expectSize.width + 16, expectSize.height + 20);
                }else{
                    viewBg.backgroundColor = [UIColor whiteColor];
                    viewBg.frame = CGRectMake(4, 4, expectSize.width + 16, expectSize.height + 20);
                }
                [cell.contentView addSubview:viewBg];
                [viewBg addSubview:labMessage];
            }
        }

        return cell;
    }
    if (tableView == _userTableView) {
        static NSString *CellWithIdentifier = @"userTableViewCell";
        UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        }
        //        cell.textLabel.text = @"头像";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = indexPath.row + 500;
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 32, 32)];
        imgHead.layer.masksToBounds = YES;
        imgHead.layer.cornerRadius = 16;
        NSString *strImage = [[_arrChatMessage objectAtIndex:indexPath.row] objectForKey:@"image"];
        [imgHead sd_setImageWithURL:[NSURL URLWithString:strImage] placeholderImage:[UIImage imageNamed:@"default_head"]];
        [cell.contentView addSubview:imgHead];
        _btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(30, 4, 12, 12)];
        [_btnDelete setImage:[UIImage imageNamed:@"living_chat_private_delete"] forState:UIControlStateNormal];
        [_btnDelete addTarget:self action:@selector(btnUserDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnDelete setTag:400+indexPath.row];
        [cell.contentView addSubview:_btnDelete];
        _btnDelete.hidden = YES;
        if (indexPath.row == _lastRow) {
            cell.backgroundColor = RGB(67, 67, 67);
            _btnDelete.hidden = NO;
        }else{
            cell.backgroundColor = [UIColor clearColor];
            _btnDelete.hidden = YES;
        }
       
        return cell;
    }
    
    
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _userTableView) {
        NSLog(@"_arrChatMessage.count == %lu",(unsigned long)_arrChatMessage.count);
        if (_arrChatMessage.count <= 0 ) {
            return 0;
        }else{
            return _arrChatMessage.count;
        }
    }else{
        BOOL haveKey = NO;
        if (_nowRow<0) {
            return 0;
        }else{
            if (_arrChatMessage.count > 0) {
                NSLog(@"_nowRow == %d, count == %ld",_nowRow,_arrChatMessage.count);
                NSArray *arrKey = [[_arrChatMessage objectAtIndex:_nowRow] allKeys] ;
                for (int index = 0; index < arrKey.count; index ++) {
                    if ([arrKey[index] isEqualToString:@"message"]) {
                        haveKey = YES;
                        break;
                    }
                }
                if (haveKey) {
                    NSArray *array = [[_arrChatMessage objectAtIndex:_nowRow] objectForKey:@"message"];
                    NSLog(@"array == %lu",(unsigned long)array.count);
                    return array.count;
                }else{
                    return 0;
                }
            }else{
               return 0;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == _userTableView) {
        UIButton *btn1 = (UIButton *)[_userTableView viewWithTag:_nowRow + 400];
        btn1.hidden = YES;
        UIButton *btn2 = (UIButton *)[_userTableView viewWithTag:indexPath.row + 400];
        btn2.hidden = NO;
        UITableViewCell *cell1 = (UITableViewCell *)[_userTableView viewWithTag:_nowRow + 500];
        cell1.backgroundColor = [UIColor clearColor];
        UITableViewCell *cell2 = (UITableViewCell *)[_userTableView viewWithTag:indexPath.row + 500];
        cell2.backgroundColor = RGB(67, 67, 67);
        _nowRow = [[NSString stringWithFormat:@"%ld",(long)indexPath.row] intValue];
        _lastRow = _nowRow;
        _labNameAndId.text = [NSString stringWithFormat:@"悄悄说:%@(%@)",[[_arrChatMessage objectAtIndex:_nowRow]objectForKey:@"userAlias"],[[_arrChatMessage objectAtIndex:_nowRow]objectForKey:@"userId"]];
        [self reloadDateForTableView];
        
    }else if (tableView == _messageTableView){
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _userTableView) {//7///5
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
    [self setSubViews];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;//3
    [keyWindow addSubview:self];
    NSLog(@"_arrChatMessage == %@",_arrChatMessage);
    CGFloat offset = self.messageTableView.contentSize.height - self.messageTableView.bounds.size.height;
    if (offset > 0)
    {
        [self.messageTableView setContentOffset:CGPointMake(0, offset) animated:NO];
    }
//    [self reloadDateForTableView];
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
    if (self.privateChatSend) {///1
        if (_textField.text.length > 0) {
            NSLog(@"_nowRow == %d",_nowRow);
            if (_arrChatMessage.count >0) {
                self.privateChatSend(_textField.text, [[[_arrChatMessage objectAtIndex:_nowRow] objectForKey:@"userId"]intValue]);
            }else{
                self.privateChatSend(_textField.text, 0);
            }
        }
        _textField.text = @"";
    }
}

- (void)btnUserDeleteClicked: (UIButton *)button{
    [_arrChatMessage removeObjectAtIndex:_nowRow];
    [self reloadDateForTableView];
    
    _nowRow = 0;
    _lastRow = 0;
    if (self.deteleChatUser) {
        self.deteleChatUser(_nowRow);
    }
    if (_arrChatMessage.count <=0) {
        [self hide];
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
        if (kIs_iPhoneX) {
            self.frame = CGRectMake(0, -[value CGRectValue].size.height + 34, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
     }else{
         self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
     }
 }
//- (void)reloadDateForTableView{
//    [_userTableView reloadData];
//    [_messageTableView reloadData];
////    [_messageTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
////    NSLog(@"row == %d",_nowRow);
////    if (_nowRow>0 && _arrChatMessage) {
////        NSArray *array = [[_arrChatMessage objectAtIndex:_nowRow] objectForKey:@"message"];
////        UITableViewCell *cell2 = (UITableViewCell *)[_messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:array.count inSection:0]];
////        [cell2 reloadInputViews];
////        UITableViewCell *cell = (UITableViewCell *)[_userTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_nowRow inSection:0]];
////        cell.selected = YES;
////    }
//}


-(void)reloadDateForTableView{
    CGFloat offset = self.messageTableView.contentSize.height - self.messageTableView.bounds.size.height;
    if (offset > 0)
    {
        [self.messageTableView setContentOffset:CGPointMake(0, offset) animated:NO];
    }
    [_messageTableView reloadData];
    NSLog(@"_lastRow == %d\n _nowRow == %d",_lastRow,_nowRow);
    UITableViewCell *cell = (UITableViewCell *)[_userTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastRow inSection:0]];
    cell.selected = YES;
    
    [_userTableView reloadData];
//    if (_nowRow == _lastRow) {
//
//
//    }
}

@end
