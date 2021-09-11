
#import "NSView+Extras.h"

@implementation NSView (Extras)

- (CGFloat)aspectRatio;
{
    return self.bounds.size.width / self.bounds.size.height;
}

@end
