//
//  AuthorViewController.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/2/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface AuthorViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray * authorListArray;
@property (strong, nonatomic) UITableView * authorTableView;
@end
