//
//  InvoicesManagerDetailVC.m
//  appmall
//
//  Created by majun on 2018/5/23.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "InvoicesManagerDetailVC.h"

@interface InvoicesManagerDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *orderno;
@property (weak, nonatomic) IBOutlet UILabel *invoicetype;
@property (weak, nonatomic) IBOutlet UILabel *invoicecotent;
@property (weak, nonatomic) IBOutlet UILabel *invoicehead;
@property (weak, nonatomic) IBOutlet UIImageView *invoiceImage;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
/**  path*/
@property (nonatomic, strong) NSString *path;

- (IBAction)downloadBtnAction:(UIButton *)sender;
@end

@implementation InvoicesManagerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票详情";
    
    [self getData];
}

- (void)getData{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [paraDic setObject:self.orderid forKey:@"orderid"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getInvoicedetailByIdApi];
//    {"message":"成功","data":{"path":"","orderno":"SC152765970361","content":"","invoicetype":"1","issuingoffice":"Hhahsdfds","allprice":"0.00"},"code":200}
    [HttpTool getWithUrl:requestUrl params:paraDic success:^(id json) {
        NSDictionary *dic = json;
        NSDictionary *dict = dic[@"data"];
        if ([dic[@"code"] integerValue] == 200) {
            self.orderno.text = [NSString stringWithFormat:@"%@",dict[@"orderno"]];
            if ([dict[@"invoicetype"] isEqualToString:@"1"]) {
                self.invoicetype.text = @"电子发票";
            }else{
                self.invoicetype.text = @"电子发票";
            }
            self.invoicehead.text = dict[@"issuingoffice"];
            self.invoicecotent.text = dict[@"content"];
            self.path = dict[@"path"];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downloadBtnAction:(UIButton *)sender {
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    if (!IsNilOrNull(self.path)) {
        [self toSaveImage:self.path];
    }else{
        [self.loadingView stopAnimation];
        [self showNoticeView:@"发票下载链接是空"];
    }
}

- (void)toSaveImage:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString: urlString];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *img;
    if ([manager diskImageExistsForURL:url])
    {
        img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
    }
    else
    {
        //从网络下载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        img = [UIImage imageWithData:data];
    }
    // 保存图片到相册中
    UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    
}
//保存图片完成之后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        [self.loadingView stopAnimation];
        // Show error message…
        [self showNoticeView:@"图片保存失败"];
        
    }
    else  // No errors
    {
        [self.loadingView stopAnimation];
        // Show message image successfully saved
        [self showNoticeView:@"图片保存成功"];
    }
}
@end
