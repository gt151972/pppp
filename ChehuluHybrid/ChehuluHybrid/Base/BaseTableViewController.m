//
//  BaseTableViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/5/25.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseTableViewController.h"
#define reuseIdentifier @"historyMistakeTableView"
@interface BaseTableViewController ()

@end

@implementation BaseTableViewController
+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static BaseTableViewController *instance;
    dispatch_once(&onceToken,^{
        instance = [[BaseTableViewController alloc] init];
    });
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  白色导航栏
 *
 *  @param strTitle 导航栏标题
 */
- (void)navigationTypeWhite:(NSString *)strTitle{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 64)];
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, gtWIDTH, 44)];
    labTitle.textColor = [UIColor blackColor];
    labTitle.text = strTitle;
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.font = [UIFont systemFontOfSize:18];
    [view addSubview:labTitle];
    [self.navigationController.navigationBar setHidden:NO];
    [view addSubview: [self addBackButton:[UIImage imageNamed:@"btnBackSelect"] :[UIImage imageNamed:@"btnBackNormal"]]];
    [self setHeaderView:view];
}

/**
 *  backItem 图片
 *
 *  @param imageNormal      <#imageNormal description#>
 *  @param imageHighlighted <#imageHighlighted description#>
 */
- (UIButton *)addBackButton: (UIImage *)imageNormal :(UIImage *)imageHighlighted{
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [btnBack setImage:imageNormal forState:UIControlStateNormal];
    [btnBack setImage:imageHighlighted forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];

    return btnBack;
}

- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  颜色
 *
 *  @param UIColor <#UIColor description#>
 *
 *  @return <#return value description#>
 */
#define DEFAULT_VOID_COLOR [UIColor whiteColor]
- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
