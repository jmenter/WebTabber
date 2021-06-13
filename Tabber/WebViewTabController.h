
@import Foundation;
@import WebKit;

@protocol WebViewTabControllerDelegate <NSObject>
- (void)tabControllerDidCreateThumbnail:(NSImage *)thumbnail;
- (void)webViewDidFinishLoading;
@end

@interface WebViewTabController : NSObject

@property (weak, nonatomic) id<WebViewTabControllerDelegate> delegate;
@property (readonly) NSView *webView;
@property (readonly) NSURL *url;
@property NSRect webViewFrame;
@property NSSize thumbnailImageSize;
@property (nonatomic) NSImage *lastThumbnailImage;

- (instancetype)initWithDelegate:(id<WebViewTabControllerDelegate>)delegate;

- (void)loadUrl:(NSURL *)url;
- (void)requestThumbnail;

@end

