//
//  ShouyeVC.h
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ShouyeVC : UIViewController<iCarouselDelegate,iCarouselDataSource,UIScrollViewDelegate>
{
    NSArray *imageArray;
}
@property(retain,nonatomic)iCarousel *myIcarousel;
@property(nonatomic,assign)BOOL wrap;
@property(retain,nonatomic)UIPageControl *page;

@end
