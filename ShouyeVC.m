//
//  ShouyeVC.m
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShouyeVC.h"
#import "ChaxunVC.h"
#import "JiexiVC.h"
#import "TijianVC.h"
#import "ZixunVC.h"
#import "ShezhiVC.h"

@implementation ShouyeVC
@synthesize myIcarousel;
@synthesize wrap;
@synthesize page;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        wrap=YES;
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
    
    UIImageView *bgIM=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_home.png"]];
    bgIM.frame=CGRectMake(0, 0, 320, 460);
    [self.view addSubview:bgIM];
    [bgIM release];
    imageArray=[NSArray arrayWithObjects:@"check_home.png",@"con_home.png",@"exam_home.png",@"infor_home.png",@"seting_home.png",nil];
    
    self.myIcarousel=[[iCarousel alloc]initWithFrame:CGRectMake(0, 240, 320, 40)];
    myIcarousel.delegate=self;
    myIcarousel.dataSource=self;
    myIcarousel.type = iCarouselTypeRotary;
    [self.view addSubview:myIcarousel];
    myIcarousel.center=self.view.center;
    [myIcarousel release];
    
    UIScrollView *scrV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 360, 320, 80)];
    scrV.contentSize=CGSizeMake(320*3, 80);
    scrV.pagingEnabled=YES;
    scrV.delegate=self;
    [self.view addSubview:scrV];
    [scrV release];
    
    for (int i=0; i<3;i++) {
        UIImageView *im=[[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, 80)];
        im.backgroundColor=[UIColor grayColor];
        [scrV addSubview:im];
        [im release];
    }
    
    self.page=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 100, 100, 30)];
    page.center=CGPointMake(160, 430);
    page.currentPage=0;
    page.numberOfPages=3;
    [self.view addSubview:page];
    [page release];
    
    UIImageView *bottomV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 440, 320, 20)];
    bottomV.image=[UIImage imageNamed:@"scoll_home.png"];
    [self.view addSubview:bottomV];
    [bottomV release];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    page.currentPage=scrollView.contentOffset.x/320;
}

- (void)dealloc
{
    [myIcarousel release];
    [page release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    myIcarousel = nil;
    page=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 5;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:index]]] autorelease];
    view.frame = CGRectMake(10, 80, 100, 100);
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 20;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 5;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 200;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.myIcarousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * myIcarousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return wrap;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    switch (index) {
        case 0:{
            ChaxunVC *chaVC=[[ChaxunVC alloc]init];
            UINavigationController *chaNC=[[UINavigationController alloc]initWithRootViewController:chaVC];
            [chaVC release];
            chaNC.navigationBarHidden=YES;
            [self presentModalViewController:chaNC animated:YES];
            [chaNC release];
            break;}
            
        case 1:{
            JiexiVC *jiexiVC=[[JiexiVC alloc]init];
            UINavigationController *jiexiNC=[[UINavigationController alloc]initWithRootViewController:jiexiVC];
            [jiexiVC release];
            jiexiNC.navigationBarHidden=YES;
            [self presentModalViewController:jiexiNC animated:YES];
            [jiexiNC release];
            break;}
            
        case 2:{
            TijianVC *tijianVC=[[TijianVC alloc]init];
            UINavigationController *tijianNC=[[UINavigationController alloc]initWithRootViewController:tijianVC];
            [tijianVC release];
            tijianNC.navigationBarHidden=YES;
            [self presentModalViewController:tijianNC animated:YES];
            [tijianNC release];
            break;}
            
        case 3:{
            ZixunVC *zixunVC=[[ZixunVC alloc]init];
            UINavigationController *zixunNC=[[UINavigationController alloc]initWithRootViewController:zixunVC];
            [zixunVC release];
            zixunNC.navigationBarHidden=YES;
            [self presentModalViewController:zixunNC animated:YES];
            [zixunNC release];
            break;}
            
        case 4:{
            ShezhiVC *shezhiVC=[[ShezhiVC alloc]init];
            UINavigationController *shezhiNC=[[UINavigationController alloc]initWithRootViewController:shezhiVC];
            [shezhiVC release];
            shezhiNC.navigationBarHidden=YES;
            [self presentModalViewController:shezhiNC animated:YES];
            [shezhiNC release];
            break;}
            
        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
