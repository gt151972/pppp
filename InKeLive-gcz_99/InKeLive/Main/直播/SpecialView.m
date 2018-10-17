//
//  SpecialView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/10/16.
//  Copyright © 2018 jh. All rights reserved.
//

#import "SpecialView.h"
@interface SpecialView()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *arrayTitle;
    NSArray *arraySelect;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton* viewBK;
@property (nonatomic, strong) UILabel* labTitle;
@end

@implementation SpecialView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        arrayTitle = @[@"屏蔽礼物动画",@"屏蔽礼物信息",@"屏蔽进房信息",@"屏蔽退房信息",@"屏蔽喇叭信息"];
        arraySelect = @[@"开启礼物动画",@"开启礼物信息",@"开启进房信息",@"开启退房信息",@"开启喇叭信息"];
        self.isAnimationHide = NO;
        self.isGiftHide = NO;
        self.isEnterHide = NO;
        self.isQuitHide = NO;
        self.isHarnHide = NO;
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
        CGRect frame = CGRectMake(170-30, 64+3, 101, 136);
        if (kIs_iPhoneX) {
            frame = CGRectMake(170-30, 88+3, 101, 136);
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
    return 5;
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
    _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 27)];
    _labTitle.text = [arrayTitle objectAtIndex:indexPath.row];
    _labTitle.textColor = [UIColor whiteColor];
    _labTitle.textAlignment = NSTextAlignmentCenter;
    _labTitle.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:_labTitle];
    if (_isAnimationHide && indexPath.row == 0) {
        _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
    }else if (_isGiftHide && indexPath.row == 1){
        _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
    }else if (_isEnterHide && indexPath.row == 2){
        _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
    }else if (_isQuitHide && indexPath.row == 3){
        _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
    }else if (_isHarnHide && indexPath.row == 4){
        _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.isAnimationHide = !_isAnimationHide;
        self.btnButtonClick(200, _isAnimationHide);
        if (_isAnimationHide) {
            _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
        }else{
            _labTitle.text = [arrayTitle objectAtIndex:indexPath.row];
        }
    }
    if (indexPath.row == 1) {
        self.isGiftHide = !_isGiftHide;
        self.btnButtonClick(201, _isGiftHide);
        if (_isGiftHide) {
            _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
        }else{
            _labTitle.text = [arrayTitle objectAtIndex:indexPath.row];
        }
    }
    if (indexPath.row == 2) {
        self.isEnterHide = !_isEnterHide;
        self.btnButtonClick(202, _isEnterHide);
        if (_isEnterHide) {
            _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
        }else{
            _labTitle.text = [arrayTitle objectAtIndex:indexPath.row];
        }
    }
    if (indexPath.row == 3) {
        self.isQuitHide = !_isQuitHide;
        self.btnButtonClick(203, _isQuitHide);
        if (_isQuitHide) {
            _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
        }else{
            _labTitle.text = [arrayTitle objectAtIndex:indexPath.row];
        }
    }
    if (indexPath.row == 4) {
        self.isHarnHide = !_isHarnHide;
        self.btnButtonClick(204, _isHarnHide);
        if (_isHarnHide) {
            _labTitle.text = [arraySelect objectAtIndex:indexPath.row];
        }else{
            _labTitle.text = [arrayTitle objectAtIndex:indexPath.row];
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
