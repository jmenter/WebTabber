
@import Foundation;
@import WebKit;

@protocol WebViewTabControllerDelegate <NSObject>
- (void)tabControllerDidTakeSnapshot:(NSImage *)snapshot;
- (void)webViewDidFinishLoading;
@end

@interface WebViewTabController : NSObject

@property (weak, nonatomic) id<WebViewTabControllerDelegate> delegate;
@property (readonly) NSView *webView;
@property (readonly) NSURL *url;
@property NSRect webViewFrame;
@property (nonatomic) NSImage *lastSnapshotImage;

- (instancetype)initWithDelegate:(id<WebViewTabControllerDelegate>)delegate;

- (void)loadUrl:(NSURL *)url;
- (void)requestSnapshot;

@end

