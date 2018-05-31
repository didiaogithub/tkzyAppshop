//
//  WuliuDetailViewCell.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/31.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WuliuDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTop;
@property (weak, nonatomic) IBOutlet UILabel *labBottom;
@property (weak, nonatomic) IBOutlet UILabel *labMid;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
-(void)loadData:(NSString *)model atIndex:(NSInteger)index andInfoCount:(NSInteger)count;
@end
