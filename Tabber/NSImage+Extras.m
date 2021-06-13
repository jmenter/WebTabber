
#import "NSImage+Extras.h"
@import Accelerate;

@implementation NSImage (Extras)

- (NSImage *)resizedTo:(NSSize)newSize;
{
    CGImageRef image = [self CGImageForProposedRect:nil context:nil hints:nil];

    vImage_Error error;
    vImage_Buffer source;

    vImage_CGImageFormat imageFormat = {(uint32_t)CGImageGetBitsPerComponent(image), (uint32_t)CGImageGetBitsPerPixel(image), CGImageGetColorSpace(image), CGImageGetBitmapInfo(image), 0, NULL, kCGRenderingIntentDefault};

    vImageBuffer_InitWithCGImage(&source, &imageFormat, NULL, image, kvImageNoFlags);
    vImage_Buffer destination;

    vImageBuffer_Init(&destination, newSize.height, newSize.width, (uint32_t)CGImageGetBitsPerPixel(image), kvImageNoFlags);

    error = vImageScale_ARGB8888(&source, &destination, NULL, kvImageHighQualityResampling);

    CGImageRef outImage = vImageCreateCGImageFromBuffer(&destination, &imageFormat, NULL, NULL, kvImageNoFlags, &error);
    NSImage *newImage = [[NSImage alloc] initWithCGImage:outImage size:newSize];
    CGImageRelease(outImage);
    free(source.data);
    free(destination.data);
    
    return newImage;
}

@end
