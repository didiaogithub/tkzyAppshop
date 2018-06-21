//
//  CommunityViewController.h
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "RootBaseViewController.h"
#import "CommListModel.h"

@interface CommunityViewController : RootBaseViewController
-(void)comunityShare:(CommListModelItem *)model  andIndex:(NSInteger )index;
@end
