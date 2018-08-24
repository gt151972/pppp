//
//  SendDynamicViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/20.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "SendDynamicViewController.h"
#import <AFNetworking.h>

@interface SendDynamicViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnImagePick;
@property(nonatomic,strong) UIImagePickerController *imagePicker;
@end

@implementation SendDynamicViewController

- (void)awakeFromNib{
    [super awakeFromNib];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发状态";
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnLeft setTitle:@"取消" forState:UIControlStateNormal];
    [btnLeft setTitleColor:RGB(23, 23, 23) forState:UIControlStateNormal];
    [btnLeft.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnLeft addTarget:self action:@selector(btnCancleClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationController.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnRight setTitle:@"发送" forState:UIControlStateNormal];
    [btnRight setTitleColor:RGB(23, 23, 23) forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnRight addTarget:self action:@selector(btnSendClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark ---------Clicked---------
- (void)btnCancleClicked{
    
}

- (void)btnSendClicked{
    
}
- (IBAction)btnPickImageClicked:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    sheet.tag = 2550;
    //显示消息框
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 2550) {
        NSUInteger sourceType = 0;
        // 判断系统是否支持相机
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.delegate = self; //设置代理
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType; //图片来源
            if (buttonIndex == 0) {
                return;
            }else if (buttonIndex == 1) {
                //拍照
                sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else if (buttonIndex == 2){
                //相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}

#pragma mark -实现图片选择器代理-（上传图片的网络请求也是在这个方法里面进行，这里我不再介绍具体怎么上传图片）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    [_btnImagePick setImage:image forState:UIControlStateNormal];
    
    NSString *url1 = @"http://www.aa1258.com/upload";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [manager POST:url1 parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *fileData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:fileData name:@"file" fileName:@"one.jpg" mimeType:@"image/jpeg"];
//        [formData appendPartWithFileURL:fileData name:@"file2" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = [self deleteEscapeStringWithResponseObject:responseObject];
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * datas = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic == %@",jsonDict);
        NSLog(@"成功:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error == %@",error);
    }];
    //上传图片到服务器--在这里进行图片上传的网络请求，这里不再介绍
}

- (NSData * )deleteEscapeStringWithResponseObject:(NSData * )responseObject{
    NSString * str_Json = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"Array\n" withString:@""];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"(" withString:@"{"];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@")" withString:@"}"];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"[" withString:@""];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"]" withString:@""];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@">" withString:@""];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"\n" withString:@";\n"];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"{;" withString:@"{"];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"};" withString:@"}"];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"= " withString:@" = \""];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@";" withString:@"\";"];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"str_js == %@",str_Json);
    NSData * data = [str_Json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"dic == %@",jsonDict);
    return data;
}

//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
