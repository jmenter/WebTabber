
#import "WebViewTabController.h"
#import "NSImage+Extras.h"

@interface WebViewTabController()<WKNavigationDelegate>
@property (nonatomic) WKWebView *myWebView;
@end

@implementation WebViewTabController

- (instancetype)init;
{
    if (!(self = [super init])) { return nil; }
    
    self.myWebView = WKWebView.new;
    self.myWebView.navigationDelegate = self;
    self.thumbnailImageSize = NSMakeSize(119 * 2, 68 * 2);
    return self;
}

- (instancetype)initWithDelegate:(id<WebViewTabControllerDelegate>)delegate;
{
    if (!(self = [self init])) { return nil; }
    
    self.delegate = delegate;
    return self;
}

- (void)requestThumbnail;
{
    WKSnapshotConfiguration *config = WKSnapshotConfiguration.new;
    config.afterScreenUpdates = NO;
    [self.myWebView takeSnapshotWithConfiguration:config
                                completionHandler:^(NSImage * _Nullable snapshotImage, NSError * _Nullable error) {
        self.lastThumbnailImage = [snapshotImage resizedTo:self.thumbnailImageSize];
        [self.delegate tabControllerDidCreateThumbnail:self.lastThumbnailImage];
    }];
}

- (NSRect)webViewFrame;
{
    return self.myWebView.frame;
}

- (void)setWebViewFrame:(NSRect)frame;
{
    self.myWebView.frame = frame;
}

- (void)loadUrl:(NSURL *)url;
{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (NSView *)webView;
{
    return self.myWebView;
}

- (NSURL *)url;
{
    return self.myWebView.URL.absoluteURL;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
{
    [self.delegate webViewDidFinishLoading];
}


@end
