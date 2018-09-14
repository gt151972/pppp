//
//  AnchorListView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/5.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "AnchorListView.h"
@interface AnchorListView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AnchorListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor]; //背景透明
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    _btnRoomName = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, 17)];
    [_btnRoomName setImage:[UIImage imageNamed:@"living_arrows_up"] forState:UIControlStateNormal];
    [_btnRoomName setImage:[UIImage imageNamed:@"living_arrows_down"] forState:UIControlStateSelected];
    [_btnRoomName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRoomName.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_btnRoomName addTarget:self action:@selector(btnChangeTable:) forControlEvents:UIControlEventTouchUpInside];
    _btnRoomName.selected = NO;
    [self addSubview:_btnRoomName];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 17, SCREEN_WIDTH/4 , SCREEN_WIDTH+20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = SCREEN_WIDTH/4;
    [self addSubview:_tableView];
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"AnchorListTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIImageView *imgHead = [[UIImageView alloc] init];
    imgHead.layer.cornerRadius = SCREEN_WIDTH/8 - 15;
    imgHead.layer.masksToBounds = YES;
    _model = [_arrayAnchor objectAtIndex:indexPath.row];
    [imgHead sd_setImageWithURL:[NSURL URLWithString:_model.userSmallHeadPic] placeholderImage:[UIImage imageNamed:@"default_head"]];
    [cell.contentView addSubview:imgHead];
    [imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell.contentView);
        make.width.height.equalTo(cell.contentView).offset(-30);
    }];
    
    UILabel *labUserName = [[UILabel alloc] init];
    labUserName.textColor = [UIColor whiteColor];
    labUserName.textAlignment = NSTextAlignmentCenter;
    labUserName.text = _model.userAlias;
    labUserName.font = [UIFont systemFontOfSize:10];
    [cell.contentView addSubview:labUserName];
    [labUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgHead.mas_bottom).offset(3);
        make.height.equalTo(@10);
        make.width.centerX.equalTo(cell.contentView);
    }];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _model = [_arrayAnchor objectAtIndex:indexPath.row];
    NSLog(@"arr = %@",_model.pullStreamUrl);
    NSLog(@"arr = %@",_model.pushStreamUrl);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"_arrayAnchor.count == %lu",(unsigned long)_arrayAnchor.count);
    return _arrayAnchor.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, 20)];
    _labRoomId = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, 20)];
    _labRoomId.textColor = [UIColor whiteColor];
    _labRoomId.textAlignment = NSTextAlignmentCenter;
    _labRoomId.font = [UIFont systemFontOfSize:10];
    _labRoomId.text = [NSString stringWithFormat:@"ID: %@",[_dicAnchor objectForKey:@"room_id"]];
    [view addSubview:_labRoomId];
    return view;
}

#pragma mark Action
- (void)btnChangeTable: (UIButton *)button{
    button.selected = !button.selected;
    _tableView.hidden = button.selected;
    [_tableView reloadData];
}

@end
