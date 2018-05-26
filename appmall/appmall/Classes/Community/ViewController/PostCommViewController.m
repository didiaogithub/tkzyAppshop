//
//  PostCommViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "PostCommViewController.h"
#import "PictureViewController.h"

@interface PostCommViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewPhotoContent;
@property (weak, nonatomic) IBOutlet UITextView *labCommContent;
@property (weak, nonatomic) IBOutlet UITextField *labCommTitle;
@property (weak, nonatomic) IBOutlet UILabel *labWordNum;
@property (strong, nonatomic)PictureViewController *picturevc;
@property (nonatomic,strong)NSMutableArray *imgUrls;
@property(nonatomic,assign)NSInteger index;

@end

@implementation PostCommViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgUrls = [NSMutableArray arrayWithCapacity:0];
    _picturevc = [[PictureViewController alloc] init];

    [self addChildViewController:_picturevc];
    _picturevc.view.frame =   self.viewPhotoContent.frame;
    _picturevc.view.mj_y = 0;
    [self.viewPhotoContent addSubview:_picturevc.pictureCollectonView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSubmit:(id)sender {
        _index = 0;
        [self .loadingView showNoticeView:@"正在上传图片"];
       [self uploadImage:self.picturevc.itemsSectionPictureArray[0]];
    
    dispatch_queue_t disqueue =  dispatch_queue_create("com.shidaiyinuo.NetWorkStudy", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t disgroup = dispatch_group_create();
 
//    for (UIImage *img in _picturevc.itemsSectionPictureArray) {
//        dispatch_group_async(disgroup, disqueue, ^{
//            sleep(0.1);
//
//        });
//    }
    dispatch_group_notify(disgroup, disqueue, ^{
        
        NSLog(@"dispatch_group_notify 执行");
    });
    
}


-(void)submitComm{
 
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:self.labCommContent.text forKey:@"content"];
    for (int i =  0; i < self.imgUrls.count ; i ++) {
        [pramaDic setObject:self.imgUrls[i] forKey:[NSString stringWithFormat:@"path%d",i + 1]];
    }
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_AddCommunity];
    

    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        
        [self.loadingView stopAnimation];
        
        NSDictionary *dic = json;
        [self.loadingView showNoticeView:dic[@"message"]];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}

-(void)uploadImage:(UIImage *)selectedImge{
    
    NSString *dateStr = [NSDate dateNow];
    NSString *nameStr = [@"" stringByAppendingString:[NSString stringWithFormat:@"_%@",dateStr]];
    NSDictionary *pramaDic = @{@"file":selectedImge};
    NSString *photoImageUrl = [NSString stringWithFormat:@"%@%@", CommentResAPI, APIuploadfileimg];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    //上传图片
    [HttpTool uploadWithUrl:photoImageUrl andImages:@[selectedImge] andPramaDic:nil completion:^(NSString *url, NSError *error) {
        NSLog(@"正在上传%@-%@", url, error);
        
    } success:^(id responseObject) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"message"]];
            return ;
        }
        NSLog(@"%@", dict);
        NSString *pathStr = [NSString stringWithFormat:@"%@",dict[@"data"][@"url"]];
        [self .imgUrls addObject:pathStr];
        if (_index == self.picturevc.itemsSectionPictureArray.count -1) {
            [self submitComm];
            return;
        }else{
            _index ++;
            [self uploadImage:self.picturevc.itemsSectionPictureArray[_index]];
        }
    } fail:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.loadingView stopAnimation];
    }];
}



@end