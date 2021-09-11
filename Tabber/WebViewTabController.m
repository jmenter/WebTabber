
@import WebKit;

#import "WebViewTabController.h"
#import "EventInterceptorView.h"
#import "NSImage+Extras.h"

@interface WebViewTabController()<WKNavigationDelegate, EventInterceptorDelegate>
@property (nonatomic) WKWebView *myWebView;
@end

@implementation WebViewTabController

- (instancetype)init;
{
    if (!(self = [super init])) { return nil; }
    
    self.myWebView = WKWebView.new;
    EventInterceptorView *eeView = [[EventInterceptorView alloc] initWithFrame:self.myWebView.bounds];
    eeView.eventInterceptorDelegate = self;
    eeView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.myWebView addSubview:eeView];
    self.myWebView.navigationDelegate = self;
    self.preferredThumbnailImageSize = NSMakeSize(119 * 2, 68 * 2);

    [self.myWebView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context;
{
    [self.delegate webViewControllerDidLoadAmount:self.myWebView.estimatedProgress];
    [self requestThumbnail];
}

- (instancetype)initWithDelegate:(id<WebViewTabControllerDelegate>)delegate;
{
    if (!(self = [self init])) { return nil; }
    
    self.delegate = delegate;
    return self;
}

- (void)requestThumbnail;
{
    static BOOL isRequestingThumbnail = NO;
    if (isRequestingThumbnail) {
        return;
    }
    isRequestingThumbnail = YES;
    WKSnapshotConfiguration *config = WKSnapshotConfiguration.new;
    config.afterScreenUpdates = NO;
    [self.myWebView takeSnapshotWithConfiguration:config
                                completionHandler:^(NSImage * _Nullable snapshotImage, NSError * _Nullable error) {
        self.lastThumbnailImage = [snapshotImage resizedTo:self.preferredThumbnailImageSize];
        [self.delegate tabController:self didCreateThumbnail:self.lastThumbnailImage];
        isRequestingThumbnail = NO;
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

#pragma mark - EventInterceptorDelegate

- (void)scrollDidEnd;
{
    [self requestThumbnail];
}

- (void)scrollIsHappening;
{
    [self requestThumbnail];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
{
    [self requestThumbnail];
    [self.delegate webViewControllerDidFinishLoading:self];
}


@end
