// ECSlidingAnimationController.m
// ECSlidingViewController 2
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

#import "ECSlidingAnimationController.h"
#import "ECSlidingConstants.h"

@interface ECSlidingAnimationController ()
@property (nonatomic, copy) void (^coordinatorAnimations)(id<UIViewControllerTransitionCoordinatorContext>context);
@property (nonatomic, copy) void (^coordinatorCompletion)(id<UIViewControllerTransitionCoordinatorContext>context);
@end

@implementation ECSlidingAnimationController

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	CGRect fromViewInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
	CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
	
	UIViewController *toViewController  = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
	CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
	
	UIView* containerView = [transitionContext containerView];
	fromViewController.view.frame = fromViewInitialFrame;
	toViewController.view.frame = toViewInitialFrame;
    
	UIViewController *topViewController = [transitionContext viewControllerForKey:ECTransitionContextTopViewControllerKey];
    if (toViewController != topViewController) {
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
		if (self.coordinatorAnimations) self.coordinatorAnimations((id<UIViewControllerTransitionCoordinatorContext>)transitionContext);
		fromViewController.view.frame = fromViewFinalFrame;
		toViewController.view.frame = toViewFinalFrame;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            fromViewController.view.frame = fromViewInitialFrame;
			toViewController.view.frame = toViewInitialFrame;
        } else if (toViewController == topViewController) {
			[fromViewController.view removeFromSuperview];
		}
        
		if (self.coordinatorCompletion) self.coordinatorCompletion((id<UIViewControllerTransitionCoordinatorContext>)transitionContext);
        [transitionContext completeTransition:finished];
    }];
}

@end
