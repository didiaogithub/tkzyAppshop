//
//  GoodsDetailHeader.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "GoodsDetailHeader.h"
#import "SCGDCommentViewController.h"

@implementation GoodsDetailHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self  = [[[NSBundle mainBundle]loadNibNamed:@"GoodsDetailHeader" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}
- (IBAction)actionComm:(id)sender {
    if (self.detailModel.commentList.count == 0) {
        BaseViewController *baseVC = (BaseViewController *)[self getCurrentVC];
        [baseVC showNoticeView:@"该商品暂无评价"];
    }else{
        SCGDCommentViewController *comment = [[SCGDCommentViewController alloc] init];
        comment.detailModel = self.detailModel;
        [[self getCurrentVC].navigationController pushViewController:comment animated:YES];
    }
}

-(void)loadData{
    [self.actionFanKui setTitle:[NSString stringWithFormat:@"反馈(%ld)",self.detailModel.commentList.count] forState:0];
//    [self.actionHaoping setTitle:@"" forState:0];
}

@end
