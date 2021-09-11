
@import Cocoa;

@protocol ScrollEventDelegate <NSObject>
-(void)scrollDidEnd;
@end

@interface ScrollEventInterceptorView : NSView

@property (nonatomic, weak) id <ScrollEventDelegate> scrollEventDelegate;

@end

