//
//  SearchView.m
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "SearchView.h"
#import <AFNetworking.h>
#import "CommonAPIDefines.h"
#import "SearchModel.h"
#import "InKeCell.h"
#import "InKeModel.h"
@interface SearchView()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *searchBarBgView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnChangeFrame;
@property (nonatomic, strong) UIButton *btnSearch;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@end

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //搜索栏
//        [self addSubview:self.searchBar];
        [self initView];
        _arrayData = [NSMutableArray array];
    }
    return self;
}

- (void)initView{
    
    UIButton *btnBg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    btnBg.backgroundColor = RGBA(0, 0, 0, 0.5);
    [btnBg addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBg];
    
    UIView *viewNav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    viewNav.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewNav];
    
    _searchBarBgView  = [[UIView alloc] initWithFrame:CGRectMake(13, 23, SCREEN_WIDTH - 60, 35)];
    _searchBarBgView.layer.borderColor = RGB(128, 128, 128).CGColor;
    _searchBarBgView.layer.borderWidth = 1;
    _searchBarBgView.layer.cornerRadius = 18;
    _searchBarBgView.layer.masksToBounds = YES;
    [self addSubview:_searchBarBgView];
    
    UIImageView *imgSearch = [[UIImageView alloc] init];
    UIImage *imageSearch = [UIImage imageNamed:@"home_search"];
    imgSearch.image = imageSearch;
    [_searchBarBgView addSubview:imgSearch];
    [imgSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@17);
        make.left.equalTo(_searchBarBgView.mas_left).with.offset(12);
        make.centerY.equalTo(_searchBarBgView.mas_centerY);
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.placeholder = @"请输入房间名/房间ID";
    _textField.textColor = RGB(128, 128, 128);
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.textAlignment = NSTextAlignmentLeft;
    [_searchBarBgView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgSearch.mas_right).offset(7);
        make.height.equalTo(@20);
        make.centerY.equalTo(_searchBarBgView.mas_centerY);
        make.right.equalTo(_searchBarBgView.mas_right);
    }];
    
    
    _btnCancel = [[UIButton alloc] init];
    [_btnCancel setTitle:@"返回" forState:UIControlStateNormal];
    [_btnCancel setTitleColor:RGB(23, 23, 23) forState:UIControlStateNormal];
    [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_btnCancel.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_btnCancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [viewNav addSubview:_btnCancel];
    [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.right.equalTo(viewNav.mas_right);
        make.top.equalTo(@20);
    }];
    
    _btnChangeFrame = [[UIButton alloc] initWithFrame:CGRectMake(13, 25, SCREEN_WIDTH - 60, 35)];
//    [_btnChangeFrame setBackgroundColor:[UIColor redColor]];
    [_btnChangeFrame addTarget:self action:@selector(btnChangeFrameClicked) forControlEvents:UIControlEventTouchUpInside];
    [_searchBarBgView addSubview:_btnChangeFrame];
    
    _btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 20, 44, 44)];
    [_btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [_btnSearch setTitleColor:RGB(23, 23, 23) forState:UIControlStateNormal];
    [_btnSearch.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_btnSearch.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_btnSearch addTarget:self action:@selector(btnSearchClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
//    _tableView.
    
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        //宽度空75,放一个按钮
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 75, 30)];
        [_searchBar setSearchBarStyle:UISearchBarStyleDefault];
        
        //_searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.backgroundImage = [UIImage imageNamed:@"global_searchbox_bg"];
        
        _searchBar.layer.cornerRadius = 14;
        _searchBar.layer.masksToBounds = YES;
        [_searchBar setPlaceholder:@"请输入昵称/印客号"];
        
    }
    return _searchBar;
}

//取消
- (void)cancleClick{
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

- (UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(_searchBar.frame.size.width + 5, 0, 50, 30);
        [_cancleButton addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _cancleButton;
}
- (void)btnChangeFrameClicked{
    _btnCancel.frame = CGRectMake(0, 20, 44, 44);
    _searchBarBgView.frame = CGRectMake(44, 25, SCREEN_WIDTH - 88, 35);
    [_btnChangeFrame removeFromSuperview];
    [self addSubview:_btnSearch];
}

- (void)btnSearchClicked{
    NSLog(@"%@",_textField.text);
    [_textField resignFirstResponder];
    [self requestData:_textField.text];
}


- (void)popToView {
    //这个Window是什么?
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    _btnCancel.frame = CGRectMake(0, SCREEN_WIDTH - 44, 44, 44);
    _searchBarBgView.frame = CGRectMake(13, 25, SCREEN_WIDTH - 60, 35);
    [self addSubview:_btnChangeFrame];
    [_btnSearch removeFromSuperview];
    
}

-(void)hide {
    [self removeFromSuperview];
}

- (void)requestData : (NSString *)strInfo{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"cmd"] = CMD_REQUEST_SEARCH;
    parameters[@"uid"] = @"1259";
    parameters[@"sid"] = @"";
    parameters[@"rid"] = @"0";
    parameters[@"info"] = strInfo;
    NSString* strAPIUrl = URL_GiftInfo;
    [manager POST:strAPIUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response == %@",responseObject);
        NSArray *array = [responseObject objectForKey:@"List"];
        for (NSDictionary *dic2 in array) {
//            SearchModel *model = [[SearchModel alloc] init];
//            model.title = [dic objectForKey:@"Title"];
//            model.img = [dic objectForKey:@"img"];
//            model.mLevel = [[dic objectForKey:@"mLevel"] intValue];
//            model.max = [[dic objectForKey:@"max"] intValue];
//            model.online = [[dic objectForKey:@"online"] intValue];
//            model.rId = [[dic objectForKey:@"rId"] intValue];
//            model.uId = [[dic objectForKey:@"uId"] intValue];
            InKeModel* inkItem = [[InKeModel alloc]init];
            inkItem.roomId = [dic2[@"rId"] intValue];
            inkItem.userId =[dic2[@"uId"] intValue];
            inkItem.roomUserCount = [dic2[@"online"] intValue];
            inkItem.roomPic = dic2[@"img"];
            inkItem.userstarPic = dic2[@"img"];
            inkItem.roomName = dic2[@"Title"];
            [_arrayData addObject:inkItem];
        }
        NSLog(@"_arrayData.count == %lu",(unsigned long)_arrayData.count);
        CGFloat height = 294*_arrayData.count;
        CGFloat H = SCREEN_HEIGHT-64 - 59;
        if (height < H) {
            [self.tableView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, height)];
        }else{
            [self.tableView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, H)];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellWithIdentifier = @"HeadTableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
//    }
//    SearchModel *model = [[SearchModel alloc] init];\
//    model = [_arrayData objectAtIndex:indexPath.row];
//    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 150)];
//    labTitle.text = [NSString stringWithFormat:@"%@(%d)",model.title, model.rId];
//    labTitle.textAlignment = NSTextAlignmentLeft;
//    la
//    [cell.contentView addSubview:labTitle];
//    return cell;
    static NSString * identifierId = @"InKeCellId";
    InKeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierId];
    if (cell == nil) {
        cell = [[InKeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    InKeModel *model = [_arrayData objectAtIndex:indexPath.row];
    [cell updateCell:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 294;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrayData != nil) {
        return _arrayData.count;
    }else{
        return 0;
    }
}

@end
