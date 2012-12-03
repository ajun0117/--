//
//  TJxiangxiVC.m
//  万网
//
//  Created by Ibokan on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TJxiangxiVC.h"

@implementation TJxiangxiVC
@synthesize listTableView;
//@synthesize titleL;
@synthesize listDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    UIImageView *topIM=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    topIM.image=[UIImage imageNamed:@"top.png"];
    topIM.userInteractionEnabled=YES;
    [self.view addSubview:topIM];
    [topIM release];
    
    UIButton *fanhuiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fanhuiBtn.frame=CGRectMake(5, 5, 50, 30);
    [fanhuiBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    fanhuiBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [fanhuiBtn setTitle:@"返回" forState:UIControlStateNormal];
    [fanhuiBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [topIM addSubview:fanhuiBtn];
    
    UILabel *titleL=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleL.center=topIM.center;
    titleL.backgroundColor=[UIColor clearColor];
    titleL.textColor=[UIColor whiteColor];
    titleL.textAlignment=UITextAlignmentCenter;
    titleL.font=[UIFont boldSystemFontOfSize:18];
    titleL.text=@"详细信息";
    [topIM addSubview:titleL];
    [titleL release];
    
    self.listTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 460-44) style:UITableViewStylePlain];
    listTableView.delegate=self;
    listTableView.dataSource=self;
    [self.view addSubview:listTableView];
    
}

#pragma mark--
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *keyArray=[listDic allKeys];
    return [keyArray count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *keyArray=[listDic allKeys];
    return [keyArray objectAtIndex:section];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *keyArray=[listDic allKeys];
    return [[listDic objectForKey:[keyArray objectAtIndex:section]] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ind=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ind];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ind];
    }
    NSArray *keyArray=[listDic allKeys];
    NSString *keyStr=[keyArray objectAtIndex:indexPath.section];
    NSArray *titleArray=[listDic objectForKey:keyStr];
    cell.textLabel.text=[titleArray objectAtIndex:indexPath.row];
    return cell;
}


-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [listTableView release];
    [listDic release];
//    [titleL release];
    [super dealloc];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    listTableView=nil;
    listDic=nil;
//    titleL=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
