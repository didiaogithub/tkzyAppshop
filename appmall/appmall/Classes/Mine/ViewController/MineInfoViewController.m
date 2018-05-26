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
@interface MineInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray * titleArr;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
- (IBAction)sciconAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    titleArr= @[@"昵称",@"真实姓名",@"手机号码",@"性别",@"出生日期"];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"MineInfoCell" bundle:nil] forCellReuseIdentifier:@"MineInfoCell"];
    self.mTableView.tableFooterView = [UIView new];
    
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = 35;
    self.iconImage.layer.borderColor = [UIColor tt_grayBgColor].CGColor;
    self.iconImage.layer.borderWidth = 1;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.head] placeholderImage:[UIImage imageNamed:@""]];
    [self setRightButton:@"保存"];
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
        tcell = cell;
    }else if (indexPath.row == 4){
        static NSString *identifier = @"addressTableCell";//这个identifier跟xib设置的一样
        AddressTableCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]  loadNibNamed:@"AddressTableCell" owner:self options:nil]  lastObject];
        }
        cell.nameLab.text = titleArr[indexPath.row];
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
        }else if (indexPath.row == 1){
            cell.contentTextField.text = self.model.realname;
        }else{
            cell.contentTextField.text = self.model.phone;
        }
       
        tcell = cell;
    }
    return tcell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArr.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *birthDay = nil;
    if (IsNilOrNull(self.model.birthdate)) {
        birthDay = self.model.birthdate;
    }
    AddressTableCell *cell = [self.mTableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 4) {
        WYBirthdayPickerView *birthdayPickerView = [[WYBirthdayPickerView alloc] initWithInitialDate:birthDay];
        birthdayPickerView.confirmBlock = ^(NSString *selectedDate) {
            cell.selectLab.text = selectedDate;
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
    NSString *headDicUrl = [NSString stringWithFormat:@"%@%@",UploadPicAndPhoto_Url,uploadPic_Url];
    NSString *dateStr = [NSDate dateNow];
    NSString *nameStr = [@"" stringByAppendingString:[NSString stringWithFormat:@"_%@",dateStr]];
    NSDictionary *pramaDic = @{@"name":nameStr,@"ckid":ckidStr,@"file":imageSales};

    
    //保存头像
    [HttpTool uploadWithUrl:headDicUrl andImages:self.headImageArr andPramaDic:pramaDic completion:^(NSString *url, NSError *error) {
        NSLog(@"正在上传");
        
    } success:^(id responseObject) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
    } fail:^(NSError *error){
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}



//UpdateMeInfoUrl
- (void)rightBtnPressed{
    
}

@end
