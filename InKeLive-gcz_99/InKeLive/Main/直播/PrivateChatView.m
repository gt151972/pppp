//
//  PrivateChatView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/13.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "PrivateChatView.h"
#import "Message.h"
#import "MessageFrame.h"
#import "NSString+Extension.h"
#import "UILabel+WidthAndHeight.h"
#import "ClientUserModel.h"
#import <KeyboardToolBar.h>

@interface PrivateChatView()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnBg;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UITextField *textFieldChat;

@property (nonatomic, strong)NSMutableDictionary *dicMessage;//所有数据

@property (nonatomic, assign) int theUserId;//当前聊天页的id


@property (weak, nonatomic) NSMutableArray *arrMessageFrame;

@end

@implementation PrivateChatView
+ (instancetype)createViewFromNibName:(NSString *)nibName
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    return [nib lastObject];
}

+ (instancetype)createViewFromNib
{
    return [self createViewFromNibName:NSStringFromClass(self.class)];
}

+ (instancetype)userView
{
    //使用的静态函数加载方式
    return [self createViewFromNib];
    //return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
-(void)awakeFromNib {
    [super awakeFromNib];
}

- (NSMutableDictionary *)dicMessage{
    if (!_dicMessage) {
        _dicMessage = [NSMutableDictionary dictionary];
    }
    return _dicMessage;
}

- (NSMutableArray *)arrUserInfo{
    if (!_arrUserInfo) {
        _arrUserInfo = [NSMutableArray array];
    }
    return _arrUserInfo;
}


- (void)initData{
    //headview
    _arrHead = @[@"http://img5q.duitang.com/uploads/item/201406/12/20140612025517_NaA8w.jpeg",
                 @"http://www.pig66.com/uploadfile/2017/0509/20170509094020407.jpg",
                 @"http://cdn.duitang.com/uploads/item/201508/30/20150830105732_nZCLV.jpeg"];
    
    //聊天界面
    const NSString *RMsgKey = @"message";
    const NSString *RMineKey = @"isMine";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Message" ofType:@"plist"];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:path];
    if (!dataArray)
    {
        NSLog(@"读取文件失败");
        return;
    }
    
//    _arrChatMessage = [NSMutableArray arrayWithCapacity:dataArray.count];
    _arrChatMessage = [[NSArray alloc] initWithArray:dataArray];
    NSLog(@"%@",_arrChatMessage);
    [_arrChatMessage enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        Message *message = [[Message alloc] init];
        message.message = dict[RMsgKey];
        message.isMine = [dict[RMineKey] intValue];
        [_arrMessageFrame addObject:message];
    }];
    
//    _arrMessageFrame = [[NSMutableArray alloc] init];
}

// 增加数据源并刷新
- (void)addObject:(MessageFrame *)messageF
         isMine:(BOOL)isMine{
    [_arrMessageFrame addObject:messageF];
    [self.chatTableView reloadData];
}


- (UITableView *)HeadTableView{
    _HeadTableView.separatorColor = [UIColor clearColor];
    _HeadTableView.rowHeight = 40;
    _HeadTableView.delegate = self;
    _HeadTableView.dataSource = self;
    _HeadTableView.backgroundColor = RGBA(50, 50, 50, 0.8);
    return _HeadTableView;
}

- (UITableView *)chatTableView{
    _chatTableView.separatorColor = [UIColor clearColor];
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    _chatTableView.backgroundColor = RGBA(50, 50, 50, 0.5);
    _chatTableView.allowsSelection = NO;
    return _chatTableView;
}

- (UILabel *)labNameAndID{
    return _labNameAndID;
}
- (IBAction)textFieldPrivate:(UITextField *)sender {
    CGRect frame = sender.frame;
    
    //在这里我多加了62，（加上了输入中文选择文字的view高度）这个依据自己需求而定
    int offset = (frame.origin.y+62)-(SCREEN_HEIGHT-216.0);//键盘高度216
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:0.30f];//动画持续时间
    
    if (offset>0) {
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        self.frame = CGRectMake(0.0f, -offset, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    [UIView commitAnimations];
}


- (void)popShow {
    //这个Window是什么?
    [self initData];
    [self.HeadTableView reloadData];
    [self.chatTableView reloadData];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

-(void)hide {
    [self removeFromSuperview];
}

#pragma mark  button click
/**
 点击空白处退出

 @param sender <#sender description#>
 */
- (IBAction)btnBgClicked:(id)sender {
    [self hide];
}


/**
 发送

 @param sender <#sender description#>
 */
- (IBAction)btnSendClicked:(id)sender {
    if (_textFieldChat.text.length > 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(SendPrivateMessage:receiverId:)]) {
            NSDictionary *dict = [_arrUserInfo lastObject];
            int receiverId = [[dict objectForKey:@"userId"]intValue];
            [_delegate SendPrivateMessage:_textFieldChat.text receiverId: receiverId];
            //存储至dic
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_textFieldChat.text,@"messageInfo",
                                 @"1", @"isMe",
                                 nil];
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[_dicMessage objectForKey:[NSString stringWithFormat:@"%d", receiverId]]];
            [arr addObject:dic];
            [_dicMessage setObject:arr forKey:[NSString  stringWithFormat:@"%d",receiverId]];
            //列表中显示
            [_chatTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
            [_chatTableView reloadData];
        }
        [_textFieldChat setText:@""];
    }
}


#pragma mark  tableView
#pragma mark UITableView 接口
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _HeadTableView) {
        return _arrUserInfo.count;
    }else{
        NSArray *array = [NSArray arrayWithArray:[_dicMessage objectForKey:[NSString stringWithFormat:@"%d",_theUserId]]];
        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _HeadTableView) {
        static NSString *CellWithIdentifier = @"HeadTableViewCell";
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
        static NSString *CellWithIdentifier = @"chatTableViewCell";
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
            labMessage.text = [[_dicMessage objectForKey:[NSString stringWithFormat:@"%d",_theUserId]] objectAtIndex:indexPath.row];
            CGFloat height = [UILabel getHeightByWidth:labMessage.frame.size.width title:labMessage.text font:labMessage.font];
            labMessage.tag = 6000+indexPath.row;
            NSLog(@"height == %f",height);
            labMessage.frame = CGRectMake(10, 30, SCREEN_WIDTH - 118, height);
            CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 118, 9999);//labelsize的最大值
            CGSize expectSize = [labMessage sizeThatFits:maximumLabelSize];
            labMessage.frame = CGRectMake(8, 10, expectSize.width, expectSize.height);
            NSLog(@"%@",[[_arrChatMessage objectAtIndex:indexPath.row] objectForKey:@"isMine"]);
            if ([[[_arrChatMessage objectAtIndex:indexPath.row] objectForKey:@"isMine"] intValue] == 1) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _HeadTableView) {
        NSDictionary *dic = [_arrUserInfo objectAtIndex:indexPath.row];
        _theUserId = [[dic objectForKey:@"userId"] intValue];
        //保持左列表排序始终按_arrUserInfo倒叙
        [_arrUserInfo removeObjectAtIndex:indexPath.row];
        [_arrUserInfo addObject:dic];
        [_chatTableView reloadData];
    }else if (tableView == _chatTableView){
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _HeadTableView) {
        return 40;
    }else{
        UILabel *lab = (UILabel *)[self viewWithTag:6000+indexPath.row];
        return lab.size.height + 28;
    }
}
#pragma mark textField
- (UITextField *)textFieldChat{
    _textFieldChat.delegate = self;
    _textFieldChat.tag = 2003;
    [_textFieldChat becomeFirstResponder];
    return _textFieldChat;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    //    NSString*cachePath = array[0];
    //    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"Message.plist"];
    //    NSDictionary*dict =@{@"message":textField.text,@"isMine":@"1"};
    //    [dict writeToFile:filePathName atomically:YES];
    
    //    socket传输
    if (_textFieldChat.text.length > 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(SendPrivateMessage:receiverId:)]) {
            NSDictionary *dict = [_arrUserInfo lastObject];
            int receiverId = [[dict objectForKey:@"userId"]intValue];
            [_delegate SendPrivateMessage:_textFieldChat.text receiverId: receiverId];
            //存储至dic
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_textFieldChat.text,@"messageInfo",
                                 @"1", @"isMe",
                                 nil];
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[_dicMessage objectForKey:[NSString stringWithFormat:@"%d", receiverId]]];
            [arr addObject:dic];
            [_dicMessage setObject:arr forKey:[NSString  stringWithFormat:@"%d",receiverId]];
            //列表中显示
            [_chatTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
            [_chatTableView reloadData];
        }
        _textFieldChat.text = @"";
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [textField resignFirstResponder];
    CGRect frame = textField.frame;
    
    //在这里我多加了62，（加上了输入中文选择文字的view高度）这个依据自己需求而定
    int offset = (frame.origin.y+62)-(SCREEN_HEIGHT-216.0);//键盘高度216
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:0.30f];//动画持续时间
    
    if (offset>0) {
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        self.frame = CGRectMake(0.0f, -offset, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    [UIView commitAnimations];

}

@end
