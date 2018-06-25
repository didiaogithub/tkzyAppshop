//
//  MineInfoViewController.m
//  appmall
//
//  Created by majun on 2018/5/23.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "MineInfoViewController.h"
#import "MineInfoCell.h"
#import "AddressTableCell.h"
#import "SexTableCell.h"
#import "WYBirthdayPickerView.h"
#import "QRadioButton.h"
@interface MineInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,QRadioButtonDelegate,UITextFieldDelegate>
{
    NSArray * titleArr;
    NSString *url;
    NSString *path;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
- (IBAction)sciconAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSMutableArray *headImageArr;
/**  nickName*/
@property (nonatomic, strong) NSString *nickName;
/**  realname*/
@property (nonatomic, strong) NSString *realname;

/**  phone*/
@property (nonatomic, strong) NSString *phone;
/**  sex*/
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birth;

/**  textfield*/
@property (nonatomic, strong) UITextField *nicknamet;
/**  textfield*/
@property (nonatomic, strong) UITextField *realnamet;
/**  textfield*/
@property (nonatomic, strong) UITextField *phonet;
@end

@implementation MineInfoViewController
-(NSMutableArray *)headImageArr{
    if (_headImageArr == nil) {
        _headImageArr = [NSMutableArray array];
    }
    return _headImageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    titleArr= @[@"昵称",@"真实姓名",@"手机号码",@"性别",@"出生日期"];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"MineInfoCell" bundle:nil] forCellReuseIdentifier:@"MineInfoCell"];
    self.mTableView.tableFooterView = [UIView new];
    
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = 40;
    self.iconImage.layer.borderColor = [UIColor tt_grayBgColor].CGColor;
    self.iconImage.layer.borderWidth = 1;
    self.iconImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [self.iconImage addGestureRecognizer:singleTap];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.head] placeholderImage:[UIImage imageNamed:@"名师推荐头像"]];
    [self setRightButton:@"保存" BtnFrame:CGRectMake(0, 0, 40, 40) titleColor:[UIColor colorWithHexString:@"#333333"] isTJXHX:NO];
}

- (void)singleTap{
    [self updateIconImage];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tcell;
    if (indexPath.row == 3) {
        static NSString *identifier = @"sexTableCell";//这个identifier跟xib设置的一样
        SexTableCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]  loadNibNamed:@"SexTableCell" owner:self options:nil]  lastObject];
        }
        cell.nameLab.text = titleArr[indexPath.row];
        QRadioButton *sex_men = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
        [sex_men setTitle:@"男" forState:UIControlStateNormal];
        [sex_men setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        [sex_men.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [cell addSubview:sex_men];
        [sex_men setChecked:YES];
        [sex_men mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.nameLab.mas_right).offset(18);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(70);
        }];
        
        QRadioButton *sex_women = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
        [sex_women setTitle:@"女" forState:UIControlStateNormal];
        [sex_women setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        [sex_women.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [cell addSubview:sex_women];
        [sex_women setChecked:YES];
        [sex_women mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sex_men.mas_right).offset(10);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(70);
        }];
        
        QRadioButton *sex_bm = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
        [sex_bm setTitle:@"保密" forState:UIControlStateNormal];
        [sex_bm setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        [sex_bm.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [cell addSubview:sex_bm];
        
        [sex_bm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sex_women.mas_right).offset(10);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(70);
        }];
      
        
      
        
        if ([self.model.sex isEqualToString:@"0"]) {
            [sex_bm setChecked:YES];
        }else if ([self.model.sex isEqualToString:@"1"]){
            [sex_men setChecked:YES];
        }else if([self.model.sex isEqualToString:@"2"]){
            [sex_women setChecked:YES];
        }else{
            [sex_men setChecked:YES];
        }
        
        tcell = cell;
    }else if (indexPath.row == 4){
        static NSString *identifier = @"addressTableCell";//这个identifier跟xib设置的一样
        AddressTableCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]  loadNibNamed:@"AddressTableCell" owner:self options:nil]  lastObject];
        }
        cell.nameLab.text = titleArr[indexPath.row];
        if (self.model.birth) {
            cell.selectLab.text = self.model.birth;
        }
        tcell = cell;
    }else{
        static NSString *identifier = @"MineInfoCell";//这个identifier跟xib设置的一样
        MineInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]  loadNibNamed:@"MineInfoCell" owner:self options:nil]  lastObject];
        }
        cell.nameLab.text = titleArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.contentTextField.text = self.model.nickname;
            self.nicknamet = cell.contentTextField;
        }else if (indexPath.row == 1){
            cell.contentTextField.text = self.model.realname;
           self.realnamet = cell.contentTextField;
        }else{
            cell.contentTextField.text = self.model.phone;
            self.phonet = cell.contentTextField;
        }
        cell.contentTextField.delegate = self;
        cell.contentTextField.tag = indexPath.row;
        tcell = cell;
    }
    return tcell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArr.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *birthDay = nil;
    if (IsNilOrNull(self.model.birth)) {
        birthDay = self.model.birth;
    }
    AddressTableCell *cell = [self.mTableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 4) {
        WYBirthdayPickerView *birthdayPickerView = [[WYBirthdayPickerView alloc] initWithInitialDate:birthDay];
        birthdayPickerView.confirmBlock = ^(NSString *selectedDate) {
            cell.selectLab.text = selectedDate;
            self.birth = cell.selectLab.text;
        };
        
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[WYBirthdayPickerView class]]) {
                [view removeFromSuperview];
            }
        }
        [self.view addSubview:birthdayPickerView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sciconAction:(UIButton *)sender {
   
    [self updateIconImage];
}


- (void)updateIconImage{
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
    [self.iconImage setImage:imageSales];
//    http://tkre.klboo.com/resource/uploadfileimg
//    http://tkre.klboo.com/resource/uploadfileimg
    NSString *headDicUrl = [NSString stringWithFormat:@"%@%@",CommentResAPI,APIuploadfileimg];
//    NSString *dateStr = [NSDate dateNow];
//    NSString *nameStr = [@"" stringByAppendingString:[NSString stringWithFormat:@"_%@",dateStr]];
    [self.headImageArr addObject:imageSales];
    NSDictionary *pramaDic = @{@"file":imageSales};
    
    //保存头像
    [HttpTool uploadWithUrl:headDicUrl andImages:self.headImageArr andPramaDic:pramaDic completion:^(NSString *url, NSError *error) {
        NSLog(@"正在上传");
        
    } success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"message"]];
            return ;
        }
        url =  dict[@"data"][@"url"];
        path = dict[@"data"][@"path"];
        
    } fail:^(NSError *error){
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    if ([radio.titleLabel.text isEqualToString:@"保密"]) {
        self.sex = @"0";
    }else if([radio.titleLabel.text isEqualToString:@"男"]){
        self.sex = @"1";
    }else{
        self.sex = @"2";
    }
}



//UpdateMeInfoUrl
- (void)rightBtnPressed{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    if (IsNilOrNull(self.model.head) && IsNilOrNull(path)) {
        [self.loadingView showNoticeView:@"您还没有自己的头像，请选择一个头像上传在保存吧"];
        return;
    }
    if (path) {
//        NSString *urls = [NSString stringWithFormat:@"%@%@",WebServiceAPI,url];
         [para setObject:path forKey:@"head"];
    }else{
        [para setObject:self.model.head forKey:@"head"];
    }

    [para setObject:self.nicknamet.text forKey:@"nickname"];
    [para setObject:self.realnamet.text forKey:@"realname"];
    [para setObject:self.phonet.text forKey:@"phone"];
    if (self.sex) {
        [para setObject:self.sex forKey:@"sex"];
    }
    if (self.birth) {
       [para setObject:self.birth forKey:@"birth"];
    }

   NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,UpdateMeInfoUrl];
//     requestUrl=[requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [HttpTool postWithUrl:requestUrl params:para success:^(id json) {
        
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] == 200) {
               [self showNoticeView:@"保存成功"];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [self showNoticeView:@"保存失败"];
    }];
}

@end
