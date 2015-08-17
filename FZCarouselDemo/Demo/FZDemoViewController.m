//
//  FZDemoViewController.m
//  Fuzz Productions
//
//  Created by Noah Blake on 11/20/14.
//  Copyright (c) 2014 Fuzz Productions, LLC. All rights reserved.
//
//	This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, as well as to the Additional Term regarding proper attribution.
//	The latter is located in Term 11 of the License.
//	If a copy of the MPL with the Additional Term was not distributed with this file, You can obtain one at http://static.fuzzhq.com/licenses/MPL

#import "FZDemoViewController.h"

#import "FZDemoCarouselCollectionViewDelegate.h"

@interface FZDemoViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) FZDemoCarouselCollectionViewDelegate *carouselCollectionViewDelegate;
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UIView *didSelectView;
@property (weak, nonatomic) IBOutlet UILabel *didSelectIndicatorLabel;
@end

@implementation FZDemoViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self prepareData];
	[self prepareCollectionViewDelegate];
	[self configureView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.carouselCollectionViewDelegate beginCarousel];
}

- (void)prepareData
{
	self.dataArray = @[@"horse_01.png"];//, @"horse_02.png", @"horse_03.png", @"horse_04.png"];
}

- (void)prepareCollectionViewDelegate
{
	__weak FZDemoViewController *tmpSelf = self;
	self.carouselCollectionViewDelegate = [FZDemoCarouselCollectionViewDelegate carouselCollectionViewDelegateForCollectionView:self.collectionView dataArray:self.dataArray crankInterval:2.0f];
	self.carouselCollectionViewDelegate.didSelectCellBlock = ^(UICollectionView *inCollectionView, NSIndexPath *inIndexPath, id inDataForIndexPath)
															 {
																 [tmpSelf showSelectionIndicator:YES withData:inDataForIndexPath];
															 };
}

- (void)configureView
{
	self.didSelectIndicatorLabel.textColor = [UIColor whiteColor];
	self.didSelectView.backgroundColor = [UIColor blackColor];
	self.didSelectView.layer.cornerRadius = 4.0f;
	self.didSelectView.alpha = 0.0f;
}

- (void)showSelectionIndicator:(BOOL)inShowSelectionIndicator withData:(NSString *)inData
{
	CGFloat tmpAlpha = 0.0f;
	static const CGFloat _animationDuration = 0.5f;
	if (inShowSelectionIndicator)
	{
		tmpAlpha = 1.0f;
		self.didSelectIndicatorLabel.text = [NSString stringWithFormat:@"%i", (int)[self.dataArray indexOfObject:inData] + 1];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(),
		^{
			[self showSelectionIndicator:NO withData:nil];
		});
	}
	
	[UIView animateWithDuration:_animationDuration animations:
	^{
		self.didSelectView.alpha = tmpAlpha;
	}];
}

@end
