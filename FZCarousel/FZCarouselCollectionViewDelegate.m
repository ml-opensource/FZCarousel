//
//  TAPCarouselCollectionViewDelegate.m
//  Fuzz Productions
//
//  Created by Noah Blake on 6/3/14.
//  Copyright (c) 2014 Fuzz Productions, LLC. All rights reserved.
//
//	This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, as well as to the Additional Term regarding proper attribution.
//	The latter is located in Term 11 of the License.
//	If a copy of the MPL with the Additional Term was not distributed with this file, You can obtain one at http://static.fuzzhq.com/licenses/MPL

#import "FZCarouselCollectionViewDelegate.h"

@interface FZCarouselCollectionViewDelegate ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIPanGestureRecognizer *timerInvalidatingGestureRecognizer;
@property (nonatomic, assign) NSInteger cycleLength;
@property (nonatomic, assign) NSInteger dataMultiplier;
@property (nonatomic, assign) BOOL isLazyScrolling;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation FZCarouselCollectionViewDelegate
#pragma mark - Initial configuration -
- (instancetype)init
{
	if (self = [super init])
	{
		self.gestureRecognitionShouldEndCarousel = YES;
	}
	return self;
}

+ (instancetype)carouselCollectionViewDelegateForCollectionView:(UICollectionView *)inCollectionView dataArray:(NSArray *)inDataArray crankInterval:(NSTimeInterval)inCrankInterval
{
	return [self carouselCollectionViewDelegateForCollectionView:inCollectionView dataArray:inDataArray defaultCrankInterval:inCrankInterval lazyCrankInterval:inCrankInterval];
}

+ (instancetype)carouselCollectionViewDelegateForCollectionView:(UICollectionView *)inCollectionView dataArray:(NSArray *)inArray defaultCrankInterval:(NSTimeInterval)inDefaultCrankInterval lazyCrankInterval:(NSTimeInterval)inLazyCrankInterval
{
	FZCarouselCollectionViewDelegate *rtnDelegate = [[self class] new];
	rtnDelegate.collectionView = inCollectionView;
	rtnDelegate.collectionView.pagingEnabled = YES;
	inCollectionView.delegate = rtnDelegate;
	inCollectionView.dataSource = rtnDelegate;
	rtnDelegate.dataArray = inArray;
	rtnDelegate.defaultCrankInterval = inDefaultCrankInterval;
	rtnDelegate.lazyCrankInterval = inLazyCrankInterval;
	[rtnDelegate addPageControl];
	
	return rtnDelegate;
}

#pragma mark - Data setting response -
- (void)setDataArray:(NSArray *)inDataArray
{
	NSMutableArray *tmpDataArray = [inDataArray mutableCopy];
	self.cycleLength = tmpDataArray.count;
	[tmpDataArray addObjectsFromArray:inDataArray];
	[tmpDataArray addObjectsFromArray:inDataArray];
	self.dataMultiplier = 3;
	_dataArray = tmpDataArray.copy;

	[self.collectionView reloadData];
}

#pragma mark - Page control -
- (void)setPageControl:(UIPageControl *)pageControl
{
	_pageControl = pageControl;
	[self updatePageControl];
}

- (void)addPageControl
{
	_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.bounds) - 50.0f, CGRectGetWidth(self.collectionView.frame), 40.0f)];
	[self configurePageControl];
}

- (void)configurePageControl
{
	self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
	self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
	self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
	UIView *tmpSuperView = self.collectionView.superview;
	if (tmpSuperView)
	{
		[tmpSuperView addSubview:self.pageControl];
		[tmpSuperView addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tmpSuperView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-5.0f]];
		[tmpSuperView addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:tmpSuperView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
	}
}

#pragma mark - CollectionView Delegate -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	NSInteger tmpRowCount = self.dataArray.count;
	if (tmpRowCount)
	{
		[self updatePageControl];
	}
	return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSException *tmpException = [NSException exceptionWithName:@"FZCarouselCollectionViewDelegate" reason:@"FZCarouselCollectionViewDelegate is an abstract class. Subclasses are expected to implement collectionView:cellForItemAtIndexPath:." userInfo:nil];
	[tmpException raise];
	return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.didSelectCellBlock)
	{
		id tmpData = nil;;
		if (self.dataArray.count > indexPath.item)
		{
			tmpData = self.dataArray[indexPath.item];
		}
		else
		{
			NSLog(@"(FZCarouselCollectionViewDelegate) WARNING: Failed to find data object for cell selection at index path: %@", indexPath);
		}
		
		self.didSelectCellBlock(collectionView, indexPath, tmpData);
	}
}

#pragma mark - ScrollView delegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	NSInteger tmpCurrentPage = floorf(CGRectGetMidX(scrollView.bounds) / CGRectGetWidth(scrollView.bounds));
	tmpCurrentPage %= self.cycleLength;
	self.pageControl.currentPage = tmpCurrentPage;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	NSInteger tmpCurrentPage = floorf(CGRectGetMidX(scrollView.bounds) / CGRectGetWidth(scrollView.bounds));
	if (tmpCurrentPage == 0)
	{
		self.collectionView.contentOffset = CGPointMake(CGRectGetWidth(self.collectionView.frame) * self.cycleLength, 0);
	}
	else if (tmpCurrentPage == self.dataArray.count - 1)
	{
		self.collectionView.contentOffset = CGPointMake(CGRectGetWidth(self.collectionView.frame) * (self.cycleLength  - 1), 0);
	}
}

#pragma mark - Carousel control -
- (void)updatePageControl
{
	self.pageControl.numberOfPages = self.dataArray.count / self.dataMultiplier;
	self.pageControl.hidden = (self.cycleLength < 2);
}

- (void)beginCarousel
{
	self.isLazyScrolling = NO;
	[self prepareCarouselForInterval:self.defaultCrankInterval];
}

- (void)beginLazyCarousel
{
	self.isLazyScrolling = YES;
	[self prepareCarouselForInterval:self.lazyCrankInterval];
}

- (void)prepareCarouselForInterval:(NSTimeInterval)inInterval
{
	// Clean up existing trackers.
	[self endCarousel];
	
	// Add a gesture to disable the crank.
	[self enableGestureRecognizer:self.gestureRecognitionShouldEndCarousel];
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:inInterval target:self selector:@selector(crankCarousel:) userInfo:nil repeats:YES];
}

- (void)endCarousel
{
	[self.timer invalidate];
	self.timer = nil;
	if (self.timerInvalidatingGestureRecognizer)
	{
		[self.collectionView removeGestureRecognizer:self.timerInvalidatingGestureRecognizer];
		self.timerInvalidatingGestureRecognizer = nil;
	}
}

- (void)crankCarousel:(id)sender
{
	NSIndexPath *tmpCurrentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
	NSInteger tmpNextItem = tmpCurrentIndexPath.item + 1;
	BOOL tmpHasReachedEndOfCycle = self.cycleLength && tmpNextItem % self.cycleLength == 0;
	if (!self.isLazyScrolling && tmpHasReachedEndOfCycle)
	{
		[self beginLazyCarousel];
	}

	NSIndexPath *tmpNextIndexPath = [NSIndexPath indexPathForItem:tmpCurrentIndexPath.item + 1 inSection:0];

	if (tmpNextIndexPath.row < (NSInteger)(self.dataArray.count - 1))
	{
		[self.collectionView scrollToItemAtIndexPath:tmpNextIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
	}
	else
	{
		if ([self.collectionView numberOfItemsInSection:0] > self.cycleLength)
		{
			[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:MAX(self.cycleLength - 2, 0) inSection:0]  atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
			[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:MAX(1, self.cycleLength - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
		}
	}
}

#pragma mark - Gesture recognizer configuration -
- (void)setGestureRecognitionShouldEndCarousel:(BOOL)inGestureRecognitionShouldEndCarousel
{
	_gestureRecognitionShouldEndCarousel = inGestureRecognitionShouldEndCarousel;
	[self enableGestureRecognizer:inGestureRecognitionShouldEndCarousel];
}

- (void)enableGestureRecognizer:(BOOL)inEnableGestureRecognizer
{
	if (inEnableGestureRecognizer)
	{
		self.timerInvalidatingGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(endCarousel)];
		self.timerInvalidatingGestureRecognizer.cancelsTouchesInView = NO;
		self.timerInvalidatingGestureRecognizer.delegate = self;
		[self.collectionView addGestureRecognizer:self.timerInvalidatingGestureRecognizer];
	}
	else
	{
		[self.collectionView removeGestureRecognizer:self.timerInvalidatingGestureRecognizer];
		self.timerInvalidatingGestureRecognizer	= nil;
	}
}

#pragma mark - Gesture recognizer delegate -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

- (void)dealloc
{
	[self.timer invalidate];
	self.timer = nil;
}
@end
