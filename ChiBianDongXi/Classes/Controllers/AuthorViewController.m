//
//  AuthorViewController.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/2/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "AuthorViewController.h"

@interface AuthorViewController ()

@end

@implementation AuthorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.authorListArray = [NSArray arrayWithObjects:@"谷俊成 (Andy-iDev)\n",
                                                        @"http://weibo.com/206207\n",
                                                        @"QQ:33321698",
                                                        @"连炜彬 (阳禹团)\n",
                                                        @"http://weibo.com/u/3519007485\n",
                                                        @"QQ:564453730",
                                                        @"颜厚华 (小东邪颜)\n",
                                                        @"http://weibo.com/u/1881351727\n",
                                                        @"QQ:707834120",
                                                        @"陈鹏飞 (草本一植物)\n",
                                                        @"http://weibo.com/u/3567341791\n",
                                                        @"QQ:1250364007",
                                                        nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"作者信息";
    self.authorTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.authorTableView.backgroundColor = [UIColor whiteColor];
    self.authorTableView.dataSource = self;
    self.authorTableView.delegate = self;
    [self.view addSubview:self.authorTableView];
    [self.authorTableView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (nil == cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	}
    
    NSString *t = [self.authorListArray objectAtIndex:indexPath.row];
    
    if (indexPath.row != 0 && indexPath.row != 3 && indexPath.row != 6 && indexPath.row != 9)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"    %@",t ];
    return cell;
}


#pragma mark - Dealloc

- (void)dealloc
{
    [_authorListArray release];
    [super dealloc];
}

@end
