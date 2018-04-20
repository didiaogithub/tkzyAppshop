//
//  SCReleaseCommentCell.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/9/9.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCOrderDetailModel.h"
#import "StarEvaluateView.h"
#import "JSTextView.h"

typedef void (^CommentContentBlock)(NSString *text);
typedef void (^CommentImageBlock)(NSArray<UIImage *> *images);

@interface SCReleaseCommentCell : UITableViewCell

@property (nonatomic, strong) JSTextView *textView;
@property (nonatomic, copy)   CommentContentBlock contentBlock;
@property (nonatomic, strong) StarEvaluateView *startView;
@property (nonatomic, copy)   CommentImageBlock imageBlock;

-(void)returnCommentContent:(CommentContentBlock)contentBlock;
-(void)returnCommentImageBlock:(CommentImageBlock)imageBlock;
-(void)refreshWithDetailModel:(SCOrderDetailGoodsModel*)detailModel;


@end
