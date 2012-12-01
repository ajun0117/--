//
//  WhoIsVC.m
//  万网
//
//  Created by Ibokan on 12-11-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WhoIsVC.h"
#import "JSON.h"
#define LIST @"域名",@"注册人姓名",@"注册人单位",@"注册商",@"域名状态",@"域名注册日期",@"域名到期时间",@"DNS服务器",@"注册人电子邮箱",@"注册人地址",@"注册人电话",@"传真"

@implementation WhoIsVC
@synthesize nameStr;
@synthesize resultDic,resultTableView,receiveData;
@synthesize xiangBtn;
@synthesize picArray,XinxiArray,nameArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.picArray=[NSMutableArray array];
        self.XinxiArray=[NSMutableArray array];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bgIM=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"suffix_background.png"]];
    bgIM.frame=CGRectMake(0, 0, 320, 460);
    [self.view addSubview:bgIM];
    [bgIM release];
    
    UIImageView *topIM=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    topIM.image=[UIImage imageNamed:@"top.png"];
    topIM.userInteractionEnabled=YES;
    [self.view addSubview:topIM];
    [topIM release];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.center=topIM.center;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=UITextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:18];
    label.text=@"WHOIS";
    [topIM addSubview:label];
    [label release];
    
    UIButton *fanhuiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fanhuiBtn.frame=CGRectMake(5, 5, 50, 30);
    [fanhuiBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    fanhuiBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [fanhuiBtn setTitle:@"返回" forState:UIControlStateNormal];
    [fanhuiBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [topIM addSubview:fanhuiBtn];
    
    UIButton *commitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame=CGRectMake(265, 5, 50, 30);
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"rightbutton.png"] forState:UIControlStateNormal];
    commitBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [commitBtn setTitle:@"完成" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [topIM addSubview:commitBtn];
    
    self.resultTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 460-44) style:UITableViewStyleGrouped];
    resultTableView.backgroundColor=[UIColor clearColor];
    resultTableView.delegate=self;
    resultTableView.dataSource=self;
    [self.view addSubview:resultTableView];
    [resultTableView release];
    
    [self searWhoIs];
}

-(void)searWhoIs{
    NSLog(@"nameStr-----------%@",nameStr);
    NSString *encodeStr=[self.nameStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//进行编码
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:encodeStr,@"domainname", nil];//这里是domainname 注意！！！
    NSLog(@"dic----%@",dic);
    NSString *tokenStr=[NSString stringWithFormat:@"%@_%@",TOKEN,[self timestamp]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            dic,@"data",
                            @"1.0",@"v",
                            @"whois",@"method",
                            tokenStr,@"trid",
                            @"ios",@"client",nil];
    NSURL *url=[NSURL URLWithString:@"http://hiapp.hichina.com:8080/hiapp/json/whois/"];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    NSString *arguments=[NSString stringWithFormat:@"req=%@",params];
    NSLog(@"arguments -----%@",arguments);
    NSData *postData=[arguments dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [request release];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.receiveData=[NSMutableData data];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receiveData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"receiveData-------------%@",receiveData);
    NSString *receiveStr=[[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSDictionary *dic=[receiveStr JSONValue];
    NSLog(@"dic-------------%@",dic);
    NSDictionary *dicc=[dic objectForKey:@"results"];
    self.resultDic=[dicc objectForKey:@"whois"];

    
    
    [XinxiArray addObjectsFromArray:[NSArray arrayWithObjects:[resultDic objectForKey:@"domainname"],
                                    [resultDic objectForKey:@"registrantname"],
                                     [resultDic objectForKey:@"registrantorganization"],
                                     [resultDic objectForKey:@"sponsoringregistrar"],
                                     [resultDic objectForKey:@"domainstatus"],
                                     [resultDic objectForKey:@"registrationdate"],
                                     [resultDic objectForKey:@"expirationdate"],
                                     [resultDic objectForKey:@"dnsserver"],
                                     [resultDic objectForKey:@"registrantemail"],
                                     [resultDic objectForKey:@"registrantaddress"],
                                     [resultDic objectForKey:@"registrantphone"],
                                     [resultDic objectForKey:@"registrantfax"],nil]];
    [picArray addObjectsFromArray:[NSArray arrayWithObjects:@"whois_域名.png",@"whois_注册人姓名.png",@"whois_单位.png",@"whois_注册商.png",@"whois_状态.png",@"whois_时间.png",@"whois_时间.png",@"whois_服务器.png",@"whois_邮箱.png",@"whois_地址.png",@"whois_电话.png",@"whois_传真.png", nil]];
    self.nameArray=[NSArray arrayWithObjects:LIST, nil];
    [resultTableView reloadData];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error----------%@",[error localizedDescription]);
}


#pragma mark- 请求时间戳
-(NSString *)timestamp{
    NSString *timeStr=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSLog(@"timeStr----%@",timeStr);
    return timeStr;
}




#pragma mark---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [nameArray count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.xiangBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [xiangBtn setBackgroundImage:[UIImage imageNamed:@"scoll_home"] forState:UIControlStateNormal];
    [xiangBtn setTitle:@"点击查看完整信息" forState:UIControlStateNormal];
    [xiangBtn setTitle:@"点击查看概要信息" forState:UIControlStateSelected];
    return xiangBtn;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ind=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ind];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ind];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(150, 10, 160, 15)];
        label.tag=100;
        label.backgroundColor=[UIColor clearColor];
        [cell addSubview:label];
        [label release];
    }
    cell.imageView.image=[UIImage imageNamed:[picArray objectAtIndex:indexPath.row]];
    NSLog(@"nameArray-----%@",nameArray);
    cell.textLabel.text=[nameArray objectAtIndex:indexPath.row];
    UILabel *label=(UILabel *)[cell viewWithTag:100];
    label.text=[XinxiArray objectAtIndex:indexPath.row];

    return cell;
}

-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)commit{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
