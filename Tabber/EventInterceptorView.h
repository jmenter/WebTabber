
@import Cocoa;

@protocol EventInterceptorDelegate <NSObject>
- (void)scrollIsHappening;
- (void)scrollDidEnd;
@end

@interface EventInterceptorView : NSView

@property (nonatomic, weak) id <EventInterceptorDelegate> eventInterceptorDelegate;

@end

