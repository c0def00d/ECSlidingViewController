// MEParallaxAnimationController.h
// TransitionFun
//
// Copyright (c) 2013, Michael Enriquez (http://enriquez.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MEParallaxAnimationController.h"

@implementation MEParallaxAnimationController

#pragma mark - ECSlidingViewControllerDelegate

- (id<ECSlidingViewControllerLayout>)slidingViewController:(ECSlidingViewController *)slidingViewController
                        layoutControllerForTopViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition
{
    return self;
}

#pragma mark - ECSlidingViewControllerLayout

- (CGRect)slidingViewController:(ECSlidingViewController *)slidingViewController
         frameForViewController:(UIViewController *)viewController
                topViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition
{
	CGRect frame = slidingViewController.view.bounds;
	
	if (viewController == slidingViewController.topViewController) {
		if (topViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
			frame.origin.x = slidingViewController.anchorRightRevealAmount;
		} else if (topViewPosition == ECSlidingViewControllerTopViewPositionAnchoredLeft) {
			frame.origin.x = -slidingViewController.anchorLeftRevealAmount;
		}
	} else if (viewController == slidingViewController.underLeftViewController) {
		if (topViewPosition != ECSlidingViewControllerTopViewPositionAnchoredRight) {
			frame.origin.x = -slidingViewController.anchorRightRevealAmount * self.parallaxFactor;
		}
	} else if (viewController == slidingViewController.underRightViewController) {
		if (topViewPosition != ECSlidingViewControllerTopViewPositionAnchoredLeft) {
			frame.origin.x = slidingViewController.anchorLeftRevealAmount * self.parallaxFactor;
		}
	}
	
	return frame;
}

@end
