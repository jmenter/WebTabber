
#import "EventInterceptorView.h"

@implementation EventInterceptorView

- (void)scrollWheel:(NSEvent *)event;
{
    if (event.phase == NSEventPhaseEnded || event.momentumPhase == NSEventPhaseEnded) {
        [self.eventInterceptorDelegate scrollDidEnd];
    }
    [self.eventInterceptorDelegate scrollIsHappening];
    [self.nextResponder scrollWheel:event];
}

- (void)keyUp:(NSEvent *)event;
{
    [self.eventInterceptorDelegate scrollDidEnd];
    [self.nextResponder keyUp:event];
}

@end
