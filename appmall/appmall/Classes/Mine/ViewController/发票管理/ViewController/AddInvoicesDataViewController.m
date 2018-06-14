//
//  AddInvoicesDataViewController.m
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "AddInvoicesDataViewController.h"
#import "LeftLabelRightTextFieldView.h"
#import "QRadioButton.h"
@interface AddInvoicesDataViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QRadioButtonDelegate>
{
    UILabel *line2;
    UILabel *line3;
    UILabel *line4;
    UILabel *line5;
    UILabel *line6;
    UILabel *line7;
    NSString *url;
    NSString *path;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contViewH;
/**  抬头类型*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *ttlxView;
/**  发票抬头*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *fpttView;
/**  税号*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *shView;
/**  开户行*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *khhView;
/**  账号*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *zhView;
/**  地址*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *dzView;
/**  电话*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *dhView;
/**  是否选中企业*/
@property (nonatomic, assign) BOOL isQY;

/**  发票证明材料*/
@property (nonatomic, strong) LeftLabelRightTextFieldView *fpzmclView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSMutableArray *headImageArr;

/**  type*/
@property (nonatomic, strong) NSString *type;
@property (weak, nonatomic) IBOutlet UIView *contView;

/**  拍照*/
@property (nonatomic, strong) UIButton *pzBtn;

/**  path*/
@property (nonatomic, strong) NSString *path;

/**  image*/
@property (nonatomic, strong) UIImage *img;

@property (weak, nonatomic) IBOutlet UIButton *tjBtn;



- (IBAction)tjBtnAction:(UIButton *)sender;

@end

@implementation AddInvoicesDataViewController
-(NSMutableArray *)headImageArr{
    if (_headImageArr == nil) {
        _headImageArr = [NSMutableArray array];
    }
    return _headImageArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.isUpdateFaPDetail == YES) {
        self.title = @"编辑发票信息";
    }else{
        self.title = @"添加发票信息";
    }
    self.isQY = YES;
    [self initCompontments];
    [self setRightButton:@"模板下载" titleColor:[UIColor colorWithHexString:@"#666666"] isTJXHX:YES];
}

- (void)rightBtnPressed{
    NSLog(@"模板下载");
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [self getData];
}

- (void)getData{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getInvoiceProveApi];
    NSDictionary *paraDic = [HttpTool getCommonPara];
    [HttpTool getWithUrl:requestUrl params:paraDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
           
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }else{
            self.path = dic[@"data"][@"path"];
            [self toSaveImage:self.path];
        }
    } failure:^(NSError *error) {
         [self.loadingView stopAnimation];
    }];
}



- (void)toSaveImage:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString: urlString];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
        if (isInCache)
        {
            _img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        }
        else
        {
            //从网络下载图片
            NSData *data = [NSData dataWithContentsOfURL:url];
            _img = [UIImage imageWithData:data];
        }
    }];
   
    // 保存图片到相册中
    UIImageWriteToSavedPhotosAlbum(_img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    
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

- (void)initCompontments{
    self.tjBtn.layer.masksToBounds = YES;
    self.tjBtn.layer.cornerRadius = 5;
    // 抬头类型
    self.ttlxView = [[LeftLabelRightTextFieldView alloc] init];
    self.ttlxView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.ttlxView];
    self.ttlxView.rightLabel.hidden = YES;
    self.ttlxView.leftLabel.attributedText = [NSString attributedStarWthStr:@"*抬头类型"];
    self.ttlxView.rightTextField.hidden = YES;
    
    
    QRadioButton *sex_women = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    [sex_women setTitle:@"个人/非企业单位" forState:UIControlStateNormal];
    [sex_women setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sex_women.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.ttlxView addSubview:sex_women];
    
    [sex_women mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ttlxView.mas_right).offset(-5);
        make.centerY.equalTo(self.ttlxView.mas_centerY);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(140);
    }];
    QRadioButton *sex_men = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    [sex_men setTitle:@"企业单位" forState:UIControlStateNormal];
    [sex_men setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sex_men.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.ttlxView addSubview:sex_men];
    [sex_men setChecked:YES];
    [sex_men mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sex_women.mas_left).offset(-5);
        make.centerY.equalTo(self.ttlxView.mas_centerY);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(80);
    }];
    
    
    [self.ttlxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(0);
        make.height.mas_offset(44);
    }];
    UILabel *line = [UILabel creatLineLable];
    [self.contView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contView).mas_offset(15);
        make.right.equalTo(self.contView).mas_offset(-15);
        make.height.mas_offset(1);
        make.top.equalTo(self.ttlxView.mas_bottom);
    }];
    
    
    
    // 发票抬头
    self.fpttView = [[LeftLabelRightTextFieldView alloc] init];
    self.fpttView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.fpttView];
    self.fpttView.rightLabel.hidden = YES;
    self.fpttView.leftLabel.attributedText = [NSString attributedStarWthStr:@"*发票抬头"];
    self.fpttView.rightTextField.placeholder = @"请输入发票抬头";
    [self.fpttView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line.mas_bottom);
        make.height.mas_offset(44);
    }];
    UILabel *line1 = [UILabel creatLineLable];
    [self.contView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contView).mas_offset(15);
        make.right.equalTo(self.contView).mas_offset(-15);
        make.height.mas_offset(1);
        make.top.mas_equalTo(self.fpttView.mas_bottom);
    }];

    // 税号
    self.shView = [[LeftLabelRightTextFieldView alloc] init];
    self.shView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.shView];
    self.shView.rightLabel.hidden = YES;
    self.shView.leftLabel.attributedText = [NSString attributedStarWthStr:@"*税号"];
    self.shView.rightTextField.placeholder = @"请输入税号";
    [self.shView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line1.mas_bottom);
        make.height.mas_offset(44);
    }];
    line2 = [UILabel creatLineLable];
    [self.contView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contView).mas_offset(15);
        make.right.equalTo(self.contView).mas_offset(-15);
        make.height.mas_offset(1);
        make.top.mas_equalTo(self.shView.mas_bottom);
    }];
    
    // 开户行
    self.khhView = [[LeftLabelRightTextFieldView alloc] init];
    self.khhView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.khhView];
    self.khhView.rightLabel.hidden = YES;
    self.khhView.leftLabel.attributedText = [NSString attributedStarWthStr:@"*开户行"];
    self.khhView.rightTextField.placeholder = @"请输入开户行";
    [self.khhView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line2.mas_bottom);
        make.height.mas_offset(44);
    }];
    line3 = [UILabel creatLineLable];
    [self.contView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contView).mas_offset(15);
        make.right.equalTo(self.contView).mas_offset(-15);
        make.height.mas_offset(1);
        make.top.mas_equalTo(self.khhView.mas_bottom);
    }];
    
//    /**  账号*/
//    @property (nonatomic, strong) LeftLabelRightTextFieldView *zhView;
    self.zhView = [[LeftLabelRightTextFieldView alloc] init];
    self.zhView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.zhView];
    self.zhView.rightLabel.hidden = YES;
    self.zhView.leftLabel.attributedText = [NSString attributedStarWthStr:@"*账号"];
    self.zhView.rightTextField.placeholder = @"请输入账号";
    [self.zhView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line3.mas_bottom);
        make.height.mas_offset(44);
    }];
    line4 = [UILabel creatLineLable];
    [self.contView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contView).mas_offset(15);
        make.right.equalTo(self.contView).mas_offset(-15);
        make.height.mas_offset(1);
        make.top.mas_equalTo(self.zhView.mas_bottom);
    }];
    
    
    
//    /**  地址*/
//    @property (nonatomic, strong) LeftLabelRightTextFieldView *dzView;
    
    self.dzView = [[LeftLabelRightTextFieldView alloc] init];
    self.dzView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.dzView];
    self.dzView.rightLabel.hidden = YES;
    self.dzView.leftLabel.attributedText = [NSString attributedStarWthStr:@"*地址"];
    self.dzView.rightTextField.placeholder = @"请输入地址";
    [self.dzView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line4.mas_bottom);
        make.height.mas_offset(44);
    }];
    line5 = [UILabel creatLineLable];
    [self.contView addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contView).mas_offset(15);
        make.right.equalTo(self.contView).mas_offset(-15);
        make.height.mas_offset(1);
        make.top.mas_equalTo(self.dzView.mas_bottom);
    }];
    
//    /**  电话*/
//    @property (nonatomic, strong) LeftLabelRightTextFieldView *dhView;
    
    self.dhView = [[LeftLabelRightTextFieldView alloc] init];
    self.dhView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.dhView];
    self.dhView.rightLabel.hidden = YES;
    self.dhView.leftLabel.attributedText = [NSString attributedStarWthStr:@"*电话"];
    self.dhView.rightTextField.placeholder = @"请输入电话";
    [self.dhView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line5.mas_bottom);
        make.height.mas_offset(44);
    }];
    line6 = [UILabel creatLineLable];
    [self.contView addSubview:line6];
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contView).mas_offset(15);
        make.right.equalTo(self.contView).mas_offset(-15);
        make.height.mas_offset(1);
        make.top.mas_equalTo(self.dhView.mas_bottom);
    }];
    
    
    
    

    // 发票证明材料
    self.fpzmclView = [[LeftLabelRightTextFieldView alloc] init];
    self.fpzmclView.backgroundColor = [UIColor whiteColor];
    [self.contView addSubview:self.fpzmclView];
    self.fpzmclView.rightLabel.hidden = YES;
    self.fpzmclView.leftLabel.attributedText = [NSString attributedStarWthStr:@"  发票证明材料"];
    self.fpzmclView.rightTextField.hidden = YES;
    
    // 拍照按钮
    self.pzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fpzmclView addSubview:self.pzBtn];
    [self.pzBtn addTarget:self action:@selector(pzAction) forControlEvents:UIControlEventTouchUpInside];
    [self.pzBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line6.mas_bottom);
         make.height.mas_offset(44);
    }];
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"查看详情"];
    [self.fpzmclView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.top.equalTo(line6.mas_bottom).offset(17.5);
        make.height.mas_offset(10);
        make.width.mas_offset(10);
    }];
    
    [self.fpzmclView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(line6.mas_bottom);
        make.height.mas_offset(44);
    }];

    
    
}


- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    
    if ([radio.titleLabel.text isEqualToString:@"个人/非企业单位"]) { // 个人/非企业单位
        self.shView.hidden = YES;
        self.fpzmclView.hidden = YES;
        self.khhView.hidden = YES;
        self.zhView.hidden = YES;
        self.dhView.hidden = YES;
        self.dzView.hidden = YES;
        line2.hidden = YES;
        line3.hidden = YES;
        line4.hidden = YES;
        line5.hidden = YES;
        line6.hidden = YES;
        self.contViewH.constant = 250;
        self.isQY = NO;
        self.type = @"1";
    }else{// 企业单位
        self.type = @"2";
        self.contViewH.constant = 500;
        self.shView.hidden = NO;
        self.fpzmclView.hidden = NO;
        self.khhView.hidden = NO;
        self.zhView.hidden = NO;
        self.dhView.hidden = NO;
        self.dzView.hidden = NO;
        line2.hidden = NO;
        line3.hidden = NO;
        line4.hidden = NO;
        line5.hidden = NO;
        line6.hidden = NO;
        self.isQY = YES;
    }
}


- (void)pzAction{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //处理点击拍照
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Test on real device, camera is not available in simulator" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePicker animated:YES completion:nil];
        
        
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //处理点击从相册选取
        // 跳转到相机或相册页面
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.editing = YES;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if (@available(iOS 11, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
    
}

#pragma mark --- 选择照片代理方法UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * oldImage = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        oldImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //将图片保存到相册的方法的参数说明：image:需要保存的图片，self：代理对象，@selector :完成后执行的方法
    }else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        oldImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    [self uploadImage:oldImage];
    
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}



/**拍照上传时，先保存图片到图库，再上传*/
-(void)uploadImage:(UIImage*)image {
    //旋转图片
    UIImage *imageSales = [UIImage fixOrientation:image];
    //显示头像
//    [self.iconImage setImage:imageSales];
    NSString *headDicUrl = [NSString stringWithFormat:@"%@%@",CommentResAPI,APIuploadfileimg];
    //    NSString *dateStr = [NSDate dateNow];
    //    NSString *nameStr = [@"" stringByAppendingString:[NSString stringWithFormat:@"_%@",dateStr]];
    [self.headImageArr addObject:imageSales];
    NSDictionary *pramaDic = @{@"file":imageSales};
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    //保存头像
    [HttpTool uploadWithUrl:headDicUrl andImages:self.headImageArr andPramaDic:pramaDic completion:^(NSString *url, NSError *error) {
        NSLog(@"正在上传");
        
    } success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        [self.loadingView stopAnimation];
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"message"]];
            return ;
        }
        url =  dict[@"data"][@"url"];
        path = dict[@"data"][@"path"];
        [self showNoticeView:@"上传成功"];
        
    } fail:^(NSError *error){
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)tjBtnAction:(UIButton *)sender {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    if (self.isQY == YES) {
        if (!IsNilOrNull(self.tempid)) {
            [paraDic setObject:self.tempid forKey:@"tempid"];
        }
        
        if (IsNilOrNull(self.fpttView.rightTextField.text)) {
            [self showNoticeView:@"请输入发票抬头"];
            return;
        }else{
            [paraDic setObject:self.fpttView.rightTextField.text forKey:@"issuingoffice"];
        }
        if (IsNilOrNull(self.shView.rightTextField.text)) {
            [self showNoticeView:@"请输入税号"];
             return;
        }else{
            [paraDic setObject:self.shView.rightTextField.text forKey:@"number"];
        }
        if (IsNilOrNull(self.khhView.rightTextField.text)) {
            [self showNoticeView:@"请输入开户行"];
             return;
        }else{
            [paraDic setObject:self.khhView.rightTextField.text forKey:@"bankname"];
        }
        if (IsNilOrNull(self.zhView.rightTextField.text)) {
            [self showNoticeView:@"请输入账号"];
             return;
        }else{
            [paraDic setObject:self.zhView.rightTextField.text forKey:@"cardno"];
        }
        if (IsNilOrNull(self.dzView.rightTextField.text)) {
            [self showNoticeView:@"请输入地址"];
             return;
        }else{
             [paraDic setObject:self.dzView.rightTextField.text forKey:@"address"];
        }
        if (IsNilOrNull(self.dhView.rightTextField.text)) {
            [self showNoticeView:@"请输入电话"];
            return;
        }else{
             [paraDic setObject:self.dhView.rightTextField.text forKey:@"mobile"];
        }
        if (IsNilOrNull(path)) {
            [self showNoticeView:@"请上传发票证明材料"];
            return;
        }else{
             [paraDic setObject:path forKey:@"prove"];
        }
        [paraDic setObject:@"2" forKey:@"invoiceheadtype"];
        
    }else{
        if (IsNilOrNull(self.fpttView.rightTextField.text)) {
            [self showNoticeView:@"请输入发票抬头"];
            return;
        }else{
              [paraDic setObject:self.fpttView.rightTextField.text forKey:@"issuingoffice"];
        }
        if (!IsNilOrNull(self.tempid)) {
            [paraDic setObject:self.tempid forKey:@"tempid"];
        }
        [paraDic setObject:@"1" forKey:@"invoiceheadtype"];
        
    }
    
    
    
    NSString *requestUrl;
    if (self.isUpdateFaPDetail == YES) {
       requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,editInvoiceTempApi];
    }else{
       requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,addInvoiceTempApi];
    }
    
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool postWithUrl:requestUrl params:paraDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] == 200) {
            if (self.isUpdateFaPDetail == YES) {
                [self showNoticeView:@"修改成功"];
            }else{
               [self showNoticeView:@"添加成功"];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (self.isUpdateFaPDetail == YES) {
                [self showNoticeView:@"修改失败"];
            }else{
                [self showNoticeView:@"添加失败"];
            }
        }
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (self.isUpdateFaPDetail == YES) {
            [self showNoticeView:@"修改失败"];
        }else{
            [self showNoticeView:@"添加失败"];
        }
    }];
    
    
}
@end
