//
//  MicStatusView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/11/5.
//  Copyright © 2018 jh. All rights reserved.
//

#import "MicStatusView.h"
@interface MicStatusView()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *arrayTitle;
    NSArray *arraySelect;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton* viewBK;
@property (nonatomic, strong) UILabel* labTitle;
@end;
@implementation MicStatusView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        arrayTitle = @[@"关闭音频",@"关闭视频"];
        arraySelect = @[@"打开音频",@"打开视频"];
        self.isVideoPause = NO;
        self.isAudioPause = NO;
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    [self addSubview:self.viewBK];
    [self addSubview:self.tableView];
}


-(UIButton*)viewBK {
    if(_viewBK == nil) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _viewBK = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewBK.frame = frame;
        _viewBK.backgroundColor = RGBA(0, 0, 0, 0);
        _viewBK.tag = 2000;
        [_viewBK addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewBK;
}

-(UITableView*)tableView {
    if(_tableView == nil) {
        CGRect frame = CGRectMake(SCREEN_WIDTH - 110, SCREEN_HEIGHT - 49-54, 101, 62);
        if (kIs_iPhoneX) {
            frame = CGRectMake(SCREEN_WIDTH - 120, SCREEN_HEIGHT - 69-54, 101, 62);
        }
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = RGBA(0,0,0,0.7);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 27;
        _tableView.scrollEnabled = NO;
        //tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    }
    return _tableView;
}

#pragma mark UITableView 接口
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"SpecialTableView";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 31)];
    _labTitle.text = [arrayTitle objectAtIndex:indexPath.row];
    _labTitle.textColor = [UIColor whiteColor];
    _labTitle.textAlignment = NSTextAlignmentCenter;
    _labTitle.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:_labTitle];
    if (_isAudioPause && indexPath.row == 0) {
        _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
    }else if (_isVideoPause && indexPath.row == 1){
        _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.isAudioPause = !_isAudioPause;
        if (_isAudioPause) {
            _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
            self.btnButtonClick(4);//当前音频暂停
            NSLog(@"444");
        }else{
            _labTitle.text = [arrayTitle objectAtIndex:indexPath.row];
            self.btnButtonClick(3);//当前音频播放
            NSLog(@"333");
        }
    }
    if (indexPath.row == 1) {
        self.isVideoPause = !_isVideoPause;
        if (_isVideoPause) {
            _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
            self.btnButtonClick(2);//当前视频暂停
        }else{
            _labTitle.text = [arrayTitle objectAtIndex:indexPath.row];
            self.btnButtonClick(1);//当前视频播放
        }
    }

    [self hide];
}

- (void)popShow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self.tableView reloadData];
}
-(void)hide {
    [self removeFromSuperview];
}
@end
