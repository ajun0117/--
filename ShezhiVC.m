//
//  ShezhiVC.m
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShezhiVC.h"
#import "ShoucangVC.h"
#import "HistoryVC.h"
#import "XinshouVC.h"
#import "BanbenVC.h"
#import "YijianVC.h"
#import "BangdingVC.h"

@implementation ShezhiVC
@synthesize myTableView;
@synthesize array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.array=[NSArray arrayWithObjects:@"我的收藏",@"历史记录",@"新手指南",@"版本信息",@"意见反馈",@"微博绑定", nil];
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
    
    UIButton *fanhuiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fanhuiBtn.frame=CGRectMake(5, 5, 50, 30);
    [fanhuiBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    fanhuiBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [fanhuiBtn setTitle:@"主页" forState:UIControlStateNormal];
    [fanhuiBtn addTarget:self action:@selector(toZhuye) forControlEvents:UIControlEventTouchUpInside];
    [topIM addSubview:fanhuiBtn];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.center=topIM.center;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=UITextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:18];
    label.text=@"设置";
    [topIM addSubview:label];
    [label release];
    
    self.myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 460-44) style:UITableViewStyleGrouped];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.scrollEnabled=NO;
    [self.view addSubview:myTableView];
    [myTableView release];
    
}

#pragma mark- 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ind=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ind];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ind];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    cell.textLabel.text=[array objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            ShoucangVC *shouVC=[[ShoucangVC alloc]init];
            [self.navigationController pushViewController:shouVC animated:YES];
            break;}
        case 1:{
            HistoryVC *historyVC=[[HistoryVC alloc]init];
            [self.navigationController pushViewController:historyVC animated:YES];
            break;}
        case 2:{
            XinshouVC *xinVC=[[XinshouVC alloc]init];
            [self.navigationController pushViewController:xinVC animated:YES];
            break;}
        case 3:{
            BanbenVC *banVC=[[BanbenVC alloc]init];
            [self.navigationController pushViewController:banVC animated:YES];
            break;}
        case 4:{
            YijianVC *yiVC=[[YijianVC alloc]init];
            [self.navigationController pushViewController:yiVC animated:YES];
            break;}
        case 5:{
            BangdingVC *bangdingVC=[[BangdingVC alloc]init];
            [self.navigationController pushViewController:bangdingVC animated:YES];
            break;}
            
        default:
            break;
    }
}


-(void)toZhuye{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
    [myTableView release];
    [array release];
    [super dealloc];
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
