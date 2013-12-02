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

#pragma mark - ECSlidingViewControllerDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>)slidingViewController:(ECSlidingViewController *)slidingViewController
									animationControllerForOperation:(ECSlidingViewControllerOperation)operation
												  topViewController:(UIViewController *)topViewController
{
	return self;
}

- (id <ECSlidingViewControllerLayout>)slidingViewController:(ECSlidingViewController *)slidingViewController
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

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
	UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	CGRect fromViewInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
	CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
	
	UIViewController * toViewController  = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
	CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];

	UIView* containerView = [transitionContext containerView];
	fromViewController.view.frame = fromViewInitialFrame;
	toViewController.view.frame = toViewInitialFrame;
    
	UIViewController * topViewController = [transitionContext viewControllerForKey:ECTransitionContextTopViewControllerKey];
    if (toViewController != topViewController) {
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
		fromViewController.view.frame = fromViewFinalFrame;
		toViewController.view.frame = toViewFinalFrame;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            fromViewController.view.frame = fromViewInitialFrame;
			toViewController.view.frame = toViewInitialFrame;
        } else if (toViewController == topViewController) {
			[fromViewController.view removeFromSuperview];
		}
        
        [transitionContext completeTransition:finished];
    }];
}

@end
