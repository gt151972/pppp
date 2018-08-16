//
//  SelectGiftUserView.m
//  InKeLive
//
//  Created by gu  on 17/9/17.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "SelectGiftUserView.h"
#import "DPK_NW_Application.h"
#import "ClientUserModel.h"
#import "UIImageView+WebCache.h"
#import "LiveUserInfoView.h"

@interface SelectGiftUserView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton* viewBK;
@property (nonatomic, strong) UITableView* userTableView;

@end


@implementation SelectGiftUserView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}

-(void) setSubViews {
    [self addSubview:self.viewBK ];
    [self addSubview:self.userTableView ];
}

-(UIButton*)viewBK {
    if(_viewBK == nil) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _viewBK = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewBK.frame = frame;
        _viewBK.backgroundColor = RGBA(0, 0, 0, 0.3);
        _viewBK.tag = 2000;
        [_viewBK addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewBK;
}

-(UITableView*)userTableView {
    if(_userTableView == nil) {
        CGRect frame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2);
        _userTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _userTableView.dataSource = self;
        _userTableView.delegate = self;
        _userTableView.backgroundColor = RGBA(255, 255, 255, 1.0);
        _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    }
    return _userTableView;
}


//按钮响应按钮
-(void) buttonClicked:(id)sender {
    [self hide];
/*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"单击了动态按钮！"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
*/
}


//弹出窗口
- (void)popShow {
    //这个Window是什么?
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self.userTableView reloadData];
}

-(void)hide {
    [self removeFromSuperview];
}

-(void)dealloc {
    NSLog(@"SelectGiftUserView dealloc()...\n");
}

#pragma mark UITableView 接口
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.userArray !=nil)
        return self.userArray.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"GiftUserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    ClientUserModel* model = [self.userArray objectAtIndex:row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%d)",model.userAlias,model.userId];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", model.userId];
    NSURL *url =[NSURL URLWithString:model.userSmallHeadPic];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    //cell.textLabel.text = [self.dataList objectAtIndex:row];
    //cell.imageView.image = [UIImage imageNamed:@"green.png"];
    //cell.detailTextLabel.text = @"详细信息";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClientUserModel* model = [self.userArray objectAtIndex:indexPath.row];
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"livingUserInfo.plist"];
    NSDictionary*dict =@{@"userId":[NSString stringWithFormat:@"%d",model.userId],
                         @"userAlias":model.userAlias,
                         @"userSmallHeadPic":model.userSmallHeadPic,
                         @"vipLevel":[NSString stringWithFormat:@"%d",model.vipLevel],
                         @"userBigHeadPic":model.userBigHeadPic,
                         @"pushStreamUrl":model.pushStreamUrl,
                         @"pullStreamUrl":model.pullStreamUrl
                         };
    [dict writeToFile:filePathName atomically:YES];
    if (self.userClick) {
        self.userClick(model.userId, model.userAlias);
    }
    
    
    [self hide];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewHead = [[UIView alloc] init];
    viewHead.backgroundColor = [UIColor whiteColor];
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    labTitle.textColor = [UIColor blackColor];
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.font = [UIFont systemFontOfSize:16];
    labTitle.text = [NSString stringWithFormat:@"在线用户(%lu)",(unsigned long)_userArray.count];
    [viewHead addSubview:labTitle];
    return viewHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}


@end
