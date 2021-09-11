
@import Foundation;

@class WebViewTabController;

@protocol WebViewTabControllerDelegate <NSObject>
@optional
- (void)tabController:(WebViewTabController *)controller didCreateThumbnail:(NSImage *)thumbnail;
- (void)webViewControllerDidLoadAmount:(CGFloat)amount;
- (void)webViewControllerDidFinishLoading:(WebViewTabController *)controller;
@end

@interface WebViewTabController : NSObject

@property (weak, nonatomic) id<WebViewTabControllerDelegate> delegate;
@property (readonly) NSView *webView;
@property (readonly) NSURL *url;
@property NSSize preferredThumbnailImageSize;
@property (nonatomic) NSImage *lastThumbnailImage;

- (instancetype)initWithDelegate:(id<WebViewTabControllerDelegate>)delegate;

- (void)loadUrl:(NSURL *)url;
- (void)requestThumbnail;

@end

