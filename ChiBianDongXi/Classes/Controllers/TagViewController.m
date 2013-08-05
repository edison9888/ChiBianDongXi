//
//  TagViewController.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-14.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "TagViewController.h"
#import "NetworkConnection.h"
#import "NetConnectionMacro.h"
#import "ArticlesByTagViewController.h"
#import "SearchViewController.h"
#import "LeftEdgeViewController.h"
#import "AppDelegate.h"
#import "WeekendViewController.h"

@interface TagViewController ()

@end

@implementation TagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityName = [userDefaults objectForKey:@"cityName"];
    
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramsDic setObject:[NSNumber numberWithInt:0] forKey:@"start"];
    
    if ([cityName isEqualToString:@""] || cityName == nil)
    {
        [paramsDic setObject:@"北京" forKey:@"city"];
    }
    else
    {
        [paramsDic setObject:cityName forKey:@"city"];
    }
    [paramsDic setObject:[NSNumber numberWithInt:50] forKey:@"limit"];
    
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kTag methodUrl:KGetTagList params:paramsDic];
    self.tagSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _tagSearchBar.backgroundColor = [UIColor redColor];
    _tagSearchBar.delegate = self;
    //TagLabel
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 320, 46)];
    tagLabel.backgroundColor = [UIColor brownColor];
    tagLabel.text = @"热门话题";
    tagLabel.font = [UIFont systemFontOfSize:28.0];
    [tagLabel setTextAlignment:NSTextAlignmentRight];

    //TableView
    self.tagTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, 320, 370) style:UITableViewStylePlain];
    _tagTableView.dataSource = self;
    _tagTableView.delegate = self;
    self.view.backgroundColor = [UIColor brownColor];

    [self.view addSubview:_tagSearchBar];
    [self.view addSubview:tagLabel];
    [self.view addSubview:_tagTableView];
    [_tagTableView release];
    [tagLabel release];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
   SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.searchStr = self.tagSearchBar.text;   
    [self.navigationController pushViewController:searchVC animated:YES];
    [searchVC release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tagInfoResult.tagInfoArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    TagInfo *tagInfo = [self.tagInfoResult.tagInfoArray objectAtIndex:indexPath.row];
    cell.textLabel.text = tagInfo.tagName;
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagInfo *tagInfo = [self.tagInfoResult.tagInfoArray objectAtIndex:indexPath.row];
    ArticlesByTagViewController *articleByTagVC = [[ArticlesByTagViewController alloc] init];
    articleByTagVC.tagInfo =tagInfo;

    [self.navigationController pushViewController:articleByTagVC animated:YES];
//    [self presentViewController:articleByTagVC animated:YES completion:^{
//        
//    }];
    [articleByTagVC release];
}


-(void) didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result
{
    self.tagInfoResult = (TagList *)result;

    [self.tagTableView reloadData];
}



-(void)dealloc
{
    self.tagTableView = nil;
    self.tagInfoResult = nil;
    self.receiveData = nil;
    self.tagSearchBar= nil;
    self.tagInfo= nil;
    self.networkConnection= nil;
    [super dealloc];
}
@end
