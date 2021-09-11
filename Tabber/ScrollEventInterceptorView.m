
#import "ScrollEventInterceptorView.h"

@implementation ScrollEventInterceptorView

- (void)scrollWheel:(NSEvent *)event;
{
    if (event.phase == NSEventPhaseEnded || event.momentumPhase == NSEventPhaseEnded) {
        [self.scrollEventDelegate scrollDidEnd];
    }
    [self.nextResponder scrollWheel:event];
}

- (void)keyUp:(NSEvent *)event;
{
    [self.scrollEventDelegate scrollDidEnd];
    [self.nextResponder keyUp:event];
}

@end
