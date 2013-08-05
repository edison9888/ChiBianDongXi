//
//  DistrictView.m
//  ChiBianDongXi 2.0
//
//  Created by lanou on 7/16/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "DistrictView.h"
#import "NetworkConnection.h"
#import "NetConnectionMacro.h"


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)




@implementation DistrictView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}



- (void)getMapData
{
    self.districtNameArray = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    self.districtNameDic = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
    self.flag = NO; // 标记是否有数据传回来了.
    
    //创建一个选定按钮
    self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedButton.frame = CGRectMake(225, 7, 50, 27);
    [_selectedButton setTitle:@"选定" forState:UIControlStateNormal];
    _selectedButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    _selectedButton.backgroundColor = [UIColor colorWithRed: 133/255.0 green:175/255.0 blue:24/255.0 alpha:1.0];

    [self addSubview:self.selectedButton];
    
    
    //创建一个SegmentedControl,选择地址或商圈
    NSArray *itemsArray = [NSArray arrayWithObjects:@"地图",@"商圈", nil];
    self.segmentControl = [[[UISegmentedControl alloc] initWithItems:itemsArray] autorelease] ;
    self.segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    _segmentControl.tintColor = [UIColor colorWithRed:133/255.0 green:185/255.0 blue:24/255.0 alpha:1.0];
    _segmentControl.frame = CGRectMake(5, 5, 160, 30);
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_segmentControl];
    
    
   
    [self showMap];  //显示地图页面
    
    
    //拼接字典， 请求商圈数据
    NSDictionary *getDistricDic = [NSDictionary dictionaryWithObjectsAndKeys:@"all",@"city", nil];
    
    self.networkConnection = [[NetworkConnection alloc] init];
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kDistrict methodUrl:KGetDistrict params:getDistricDic];
    [self.networkConnection asynchronousGetWithTarget:self callBack:@selector(getDistrict)];
    

    //创建一个商圈tableView
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 40, 280, self.bounds.size.height -40) style:UITableViewStylePlain] autorelease];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
    self.tableView.hidden = YES;
    
}


//提取数据
-(void) getDistrict
{
    //接受网络请求所得到的数据
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.networkConnection.receivedData options:0 error:nil];
    
    dic = [dic objectForKey:@"response-body"];
    dic = [dic objectForKey:@"getDistrict"];
     
    NSArray * cityListArray = [dic objectForKey:@"cityList"];  //取出城市列表
    
    //取出系统存储的位置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *cityName = [defaults objectForKey:@"cityName"];
    
    
    for (int i = 0; i < cityListArray.count; i++)
    {
        NSDictionary *cityListDic = [[NSDictionary alloc] init];
        //[cityListArray objectAtIndex:i];
        if (cityName == nil)
        {
            cityListDic = [cityListArray objectAtIndex:0];  //如果没有默认值， 取北京的商业圈。
            self.districtNameArray = [cityListDic objectForKey:@"districtList"];
        }
        else
        {
            cityListDic = [cityListArray objectAtIndex:i];
            if ([[cityListDic objectForKey:@"cityName"] isEqualToString:cityName])
            {
                self.districtNameArray = [cityListDic objectForKey:@"districtList"];
                
            }
         }
    }
     
    self.flag = YES;// 数据已经传回来了。
    
    [self.tableView reloadData];
}


-(void)showMap  //显示地图
{
    
    self.locationMapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 40, 290, self.bounds.size.height-40)]autorelease] ;
    self.locationMapView.showsUserLocation = YES;
    self.locationMapView.delegate = self;
    [self addSubview: self.locationMapView];
    
    
    [self.locationMapView setRegion:MKCoordinateRegionMake(self.currentLocation.coordinate, MKCoordinateSpanMake(0.03, 0.03)) animated:YES];
    
    
    //创建一个圆覆盖地址范围，
    UIImageView *regionIamgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location@2x.png"]];
    if (iPhone5) {
        regionIamgeView.frame = CGRectMake(15, 50, 255, 255);
    }
    else
    {
       regionIamgeView.frame = CGRectMake(15, 30, 255, 255);
    }
     
    [self.locationMapView addSubview: regionIamgeView];
    regionIamgeView.userInteractionEnabled = NO;
    [regionIamgeView release];
    
}


-(void)selectedSegment:(id)sender  //判断segmentController的状态
{
    if (_segmentControl.selectedSegmentIndex == 0)
    {
        self.selectedButton.hidden = NO;
        self.tableView.hidden = YES;
        self.locationMapView.hidden = NO;
        
    }
    else if(_segmentControl.selectedSegmentIndex == 1)
    {
        self.selectedButton.hidden = YES;
        self.locationMapView.hidden = YES;
        self.tableView.hidden = NO;
        
    }
    
}


#pragma mark --TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.flag == NO) {
        return 5;
    }
    return self.districtNameArray.count ;
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier] autorelease];
    }
    
    if (self.flag == NO)
    {
        return cell;
    }
      
    NSDictionary *districtName = [self.districtNameArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [districtName objectForKey:@"districtName"]  ;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *districtName = [self.districtNameArray objectAtIndex:indexPath.row];
    
    NSArray *locationArray = [districtName objectForKey:@"districtLocation"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: locationArray forKey:@"currentLocution"];
    [defaults setObject:[districtName objectForKey:@"districtName"] forKey:@"addressName"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNear" object:nil userInfo:nil];

    [self.superview removeFromSuperview];
    
}





- (void)dealloc
{
    [self.currentLocation release];
    [self.tableView release];
    [self.locationMapView release];
    [self.selectedButton release];
    [self.networkConnection release];
    [self.segmentControl release];
    [self.districtNameDic release];
    [self.districtNameArray release];
    [super dealloc];
}



@end
