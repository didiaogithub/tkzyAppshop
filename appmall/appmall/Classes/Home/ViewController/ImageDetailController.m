//
//  ImageDetailController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ImageDetailController.h"
#define minScale  1
#define maxScale  2
@interface ImageDetailController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrContent;
@property (weak, nonatomic) IBOutlet UIView *cotentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;

@end

@implementation ImageDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    if (_imgUrl != nil) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
    }else if(_img != nil){
         self.imgView.image = self.img;
    }

      _scrContent.delegate = self;
    [_scrContent setMinimumZoomScale:1];
    [_scrContent setMaximumZoomScale:3];
    [_scrContent setZoomScale:1 animated:YES];
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.cotentView;
}
// scale between minimum and maximum. called after any 'bounce' animations缩放完毕的时候调用。
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale

{
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
    NSLog(@"scale is %f",scale);
    [_scrContent setZoomScale:scale animated:NO];
}

- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
