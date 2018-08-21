//
//  EditInfoViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/21.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "EditInfoViewController.h"

@interface EditInfoViewController ()
@property (nonatomic, strong) NSArray *arrayTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation EditInfoViewController

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _arrayTitle = @[@[@"头像"],@[@"昵称",@"账号",@"个性签名"],@[@"性别",@"QQ",@"微信"]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UITableView *)tableView{
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
