//
//  XinshouVC.m
//  万网
//
//  Created by Ibokan on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XinshouVC.h"

@implementation XinshouVC
@synthesize page;

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
//    UIImageView *bgIM=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"suffix_background.png"]];
//    bgIM.frame=CGRectMake(0, 0, 320, 460);
//    [self.view addSubview:bgIM];
//    [bgIM release];
//    
//    UIImageView *topIM=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    topIM.image=[UIImage imageNamed:@"top.png"];
//    topIM.userInteractionEnabled=YES;
//    [self.view addSubview:topIM];
//    [topIM release];
//    
//    UIButton *fanhuiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    fanhuiBtn.frame=CGRectMake(5, 5, 50, 30);
//    [fanhuiBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
//    fanhuiBtn.titleLabel.font=[UIFont systemFontOfSize:13];
//    [fanhuiBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [fanhuiBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
//    [topIM addSubview:fanhuiBtn];
//    
//    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    label.center=topIM.center;
//    label.backgroundColor=[UIColor clearColor];
//    label.textColor=[UIColor whiteColor];
//    label.textAlignment=UITextAlignmentCenter;
//    label.font=[UIFont boldSystemFontOfSize:18];
//    label.text=@"新手指南";
//    [topIM addSubview:label];
//    [label release];
    
    UIScrollView *scrollV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    scrollV.delegate=self;
    scrollV.pagingEnabled=YES;
    scrollV.contentSize=CGSizeMake(320*6, 460);
    [self.view addSubview:scrollV];
    [scrollV release];
    
    
    
    for (int i=0; i<6; i++) {
        UIImageView *im=[[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, 460)];
        im.image=[UIImage imageNamed:[NSString stringWithFormat:@"fu%d",i+1]];
        im.tag=i+1;
        [scrollV addSubview:im];
        [im release];
    }
    UIImageView *im=(UIImageView *)[scrollV viewWithTag:6];
    im.userInteractionEnabled=YES;
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(110, 320, 130, 60);
    [button addTarget:self action:@selector(kaishiTiyan) forControlEvents:UIControlEventTouchUpInside];
    [im addSubview:button];
    
    self.page=[[UIPageControl alloc]initWithFrame:CGRectMake(100, 430, 120, 20)];
    page.currentPage=0;
    page.numberOfPages=6;
    [self.view addSubview:page];
    [page release];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    page.currentPage=scrollView.contentOffset.x/320;
}

-(void)kaishiTiyan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [page release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    page=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
