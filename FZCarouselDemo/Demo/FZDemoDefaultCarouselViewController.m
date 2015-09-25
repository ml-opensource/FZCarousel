//
//  FZDemoDefaultCarouselViewController.m
//  FZCarousel
//
//  Created by Sheng Dong on 9/25/15.
//  Copyright © 2015 Fuzz Productions, LLC. All rights reserved.
//

#import "FZDemoDefaultCarouselViewController.h"
#import "FZCarouselView.h"

@interface FZDemoDefaultCarouselViewController ()

@property (weak, nonatomic) IBOutlet FZCarouselView *carouselView;

@end

@implementation FZDemoDefaultCarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self prepareCarousel];
}

- (void)prepareCarousel
{
	NSArray *imageArray = @[[UIImage imageNamed:@"horse_01.png"], [UIImage imageNamed:@"horse_02.png"], [UIImage imageNamed:@"horse_03.png"], [UIImage imageNamed:@"horse_04.png"]];
	self.carouselView.imageArray = imageArray;
	self.carouselView.crankInterval = 2.0f;
	[self.carouselView beginCarousel];
}

@end
