//
//  AccountView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/11/5.
//  Copyright © 2018 jh. All rights reserved.
//

#import "AccountView.h"
@interface AccountView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *viewBK;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayData;
@end
@implementation AccountView
//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        [self setSubViews];
//    }
//    return self;
//}
- (void)setSubViews: (NSArray *)array{
    self.arrayData = [NSArray arrayWithArray:array];
    NSLog(@"self.arrData == %@",self.arrayData);
    [self addSubview:self.viewBK];
    _tableView = [[UITableView alloc] init];
    if (array.count !=0) {
        _tableView.frame = CGRectMake(16, 205, SCREEN_WIDTH-32, 40*array.count);
        if (kIs_iPhoneX) {
            _tableView.frame = CGRectMake(16, 227, SCREEN_WIDTH-32, 40*array.count);
        }
    }else{
       _tableView.frame = CGRectMake(16, 205, SCREEN_WIDTH-32, 40);
        if (kIs_iPhoneX) {
            _tableView.frame = CGRectMake(16, 227, SCREEN_WIDTH-32, 40);
        }
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 40;
    _tableView.backgroundColor = [UIColor redColor];
    [self addSubview:_tableView];
}

-(UIButton*)viewBK {
    if(_viewBK == nil) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _viewBK = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewBK.frame = frame;
        _viewBK.backgroundColor = [UIColor clearColor];
        [_viewBK addTarget:self action:@selector(btnBgClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewBK;
}

- (void)btnBgClicked{
    [self hide];
}
- (void)popShow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}
-(void)hide {
    [self removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"AccountTableViewCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = TEXT_COLOR;
    if (_arrayData) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[_arrayData objectAtIndex:indexPath.row] objectForKey:@"uid"]];
    }else{
        cell.textLabel.text = @"没有历史账号....";
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrayData.count>0) {
        return _arrayData.count;
    }else{
        return 1;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"uid == %@",[[_arrayData objectAtIndex:indexPath.row] objectForKey:@"uid"]);
    self.btnAccountClick([[_arrayData objectAtIndex:indexPath.row] objectForKey:@"uid"],[[_arrayData objectAtIndex:indexPath.row] objectForKey:@"userPwd"]);
}
@end
