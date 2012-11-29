//
//  HouzhuiListVC.m
//  万网
//
//  Created by Ibokan on 12-11-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HouzhuiListVC.h"
#define ENGLISH @".com",@".cn",@".mobi",@".co",@".net",@".com.cn",@".net.cn",@".so",@".org",@".gov.cn",@".org.cn",@".tel",@".tv",@".biz",@".cc",@".hk",@".name",@".info",@".asia",@".me",nil
#define CHINA @".com",@".net",@".tv",@".biz",@".cc",@"公司",@"网络",@"中国",nil

@implementation HouzhuiListVC
@synthesize listTableView,listArray;
@synthesize zhuangtaiDic;
//@synthesize chinaArray;
@synthesize isChina;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.listArray=[NSMutableArray array];
        self.zhuangtaiDic=[NSMutableDictionary dictionary];
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
    isAllSelected=NO;
    if (isChina) {
        [listArray addObjectsFromArray:[NSArray arrayWithObjects:CHINA]];
    }
    else{
        [listArray addObjectsFromArray:[NSArray arrayWithObjects:ENGLISH]];
    }
    for (NSString *str in listArray) {
             [zhuangtaiDic removeAllObjects];
            [zhuangtaiDic setObject:[NSNumber numberWithBool:NO] forKey:str];//初始全部为未选中状态
            [zhuangtaiDic setObject:[NSNumber numberWithBool:YES] forKey:@".com"];//设置才.com初始为选中状态
        }
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
    label.text=@"后缀选择";
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
    
    self.listTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 460-44) style:UITableViewStylePlain];
    listTableView.delegate=self;
    listTableView.dataSource=self;
    listTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:listTableView];
    [listTableView release];
}

-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)commit{
    
}

#pragma mark---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSLog(@"%s",__FUNCTION__);
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//    headView.backgroundColor=[UIColor clearColor];
    headView.alpha=0.9;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 40, 20)];
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont boldSystemFontOfSize:16];
    label.text=@"全选";
    [headView addSubview:label];
    [label release];
    UIButton *allBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    allBtn.frame=CGRectMake(280, 10, 20, 20);
    [allBtn setBackgroundImage:[UIImage imageNamed:@"suffix_notselected.png"] forState:UIControlStateNormal];
    [allBtn setBackgroundImage:[UIImage imageNamed:@"suffix_selected.png"] forState:UIControlStateSelected];
    [allBtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:allBtn];
    if (isAllSelected) {
        allBtn.selected=YES;
    }
    else{
        allBtn.selected=NO;
    }
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ind=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ind];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ind];
        UIButton *selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame=CGRectMake(280, 10, 20, 20);
        selectBtn.tag=100;
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"suffix_notselected.png"] forState:UIControlStateNormal];
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"suffix_selected.png"] forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(selectMe:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:selectBtn];
    }
        cell.textLabel.text=[listArray objectAtIndex:indexPath.row];
        UIButton *selectBtn=(UIButton *)[cell viewWithTag:100];
        BOOL isSelected=[[zhuangtaiDic objectForKey:cell.textLabel.text] boolValue];
        if (isSelected) {
            selectBtn.selected=YES;
        }
        else{
            selectBtn.selected=NO;
        }
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)allSelect:(UIButton *)sender{
    if (sender.selected==NO) {
        sender.selected=YES;
        isAllSelected=YES;
        for (NSString *str in listArray) {
            [zhuangtaiDic setObject:[NSNumber numberWithBool:YES] forKey:str];//初始全部为未选中状态
        }
        }
    else{
        isAllSelected=NO;
        sender.selected=NO;
        for (NSString *str in listArray) {
            [zhuangtaiDic setObject:[NSNumber numberWithBool:NO] forKey:str];//初始全部为未选中状态
            }
        }
    [listTableView reloadData];
}

-(void)selectMe:(UIButton *)sender{
    UITableViewCell *cell=(UITableViewCell *)sender.superview;//通过button获得cell对象，便获得了数组中的key
//    NSIndexPath *indexPath=[self.listTableView indexPathForCell:cell];
    if (sender.selected==NO) {
        [zhuangtaiDic setObject:[NSNumber numberWithBool:YES] forKey:cell.textLabel.text];
        sender.selected=YES;
    }
    else{
        [zhuangtaiDic setObject:[NSNumber numberWithBool:NO] forKey:cell.textLabel.text];
        sender.selected=NO;
    }
}

- (void)dealloc
{
    [listTableView release];
    [listArray release];
    [zhuangtaiDic release];
//    [chinaArray release];
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
