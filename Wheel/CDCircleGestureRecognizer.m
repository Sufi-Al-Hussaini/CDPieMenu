/*
 Copyright (C) <2012> <Wojciech Czelalski/CzekalskiDev>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#define deceleration_multiplier 30.0f

#import <QuartzCore/QuartzCore.h>
#import "CDCircleGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "CDCircle.h"
#import "CDCircleThumb.h"
#import <AudioToolbox/AudioServices.h>
#import "CDCircleOverlayView.h"
#import "Common.h"


@implementation CDCircleGestureRecognizer

@synthesize rotation = rotation_, controlPoint;
@synthesize ended;
@synthesize currentThumb;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CDCircle *view = (CDCircle *) [self view];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:view];
    
   // Fail when more than 1 finger detected.
   if ([[event touchesForGestureRecognizer:self] count] > 1 || ([view.path containsPoint:point] == YES )) {
      [self setState:UIGestureRecognizerStateFailed];
   }
    self.ended = NO;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   if ([self state] == UIGestureRecognizerStatePossible) {
      [self setState:UIGestureRecognizerStateBegan];
   } else {
      [self setState:UIGestureRecognizerStateChanged];
   }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
       CDCircle *view = (CDCircle *)[self view];
       UITouch *touch = [touches anyObject];
       
       for (CDCircleThumb *thumb in view.thumbs) {
           
           CGPoint touchPoint = [touch locationInView:thumb];
           if (CGPathContainsPoint(thumb.arc.CGPath, NULL, touchPoint, NULL)) {
               
               CGFloat deltaAngle= - degreesToRadians(180) + atan2(view.transform.a, view.transform.b) + atan2(thumb.transform.a, thumb.transform.b);
               CGAffineTransform current = view.transform;
               [UIView animateWithDuration:0.3f animations:^{
                   [view setTransform:CGAffineTransformRotate(current, deltaAngle)];
               } completion:^(BOOL finished) {
                   
                   SystemSoundID soundID;
                   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iPod Click" ofType:@"aiff"];
                   
                   NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
                   AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &soundID);
                   AudioServicesPlaySystemSound(soundID);
                   
                   [currentThumb.iconView setIsSelected:NO];
                   [thumb.iconView setIsSelected:YES];
                   self.currentThumb = thumb;
                   //Delegate method
                   [view.delegate circle:view didMoveToSegment:thumb.tag thumb:thumb];
                   self.ended = YES;
                   
               }];
               
               break;
           }
           
       }
       
       [self setState:UIGestureRecognizerStateFailed];
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   [self setState:UIGestureRecognizerStateFailed];
}
@end
