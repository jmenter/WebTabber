
#import "ViewController.h"
#import "WebViewTabController.h"

@import WebKit;

@interface ViewController() <NSTableViewDelegate, NSTableViewDataSource, WebViewTabControllerDelegate>
@property (weak) IBOutlet NSView *webViewSuperView;
@property (weak) IBOutlet NSTextField *addressField;
@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic) NSMutableArray <WebViewTabController *> *tabs;
@property (nonatomic) NSUInteger selectedTab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabs = NSMutableArray.new;

    [self.tabs addObject:[WebViewTabController.alloc initWithDelegate:self]];
    [self.webViewSuperView addSubview:self.tabs[0].webView];
    self.tabs[self.selectedTab].webView.frame = self.webViewSuperView.bounds;
    self.tabs[self.selectedTab].thumbnailImageSize = self.optimalThumbnailSize;

    [NSTimer scheduledTimerWithTimeInterval:.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.tabs[self.selectedTab] requestThumbnail];
    }];
}

- (NSSize)optimalThumbnailSize;
{
    CGFloat maxWidth = kBaseWidth - 4;
    CGFloat aspectRatio = self.webViewSuperView.bounds.size.width / self.webViewSuperView.bounds.size.height;
    return NSMakeSize(maxWidth * 2, (maxWidth / aspectRatio) * 2);
}

- (void)viewDidLayout;
{
    [super viewDidLayout];
    [self updateWebviewPreviews];
    [self.tableView reloadData];
}

- (WebViewTabController *)selectedTabController;
{
    return self.tabs[self.selectedTab];
}

- (void)selectTab:(NSUInteger)tab;
{
    [self.selectedTabController.webView removeFromSuperview];

    self.selectedTab = tab;
    [self.webViewSuperView addSubview:self.selectedTabController.webView];
    self.selectedTabController.webView.frame = self.webViewSuperView.bounds;
    self.addressField.stringValue = self.selectedTabController.url.absoluteString ?: @"";
}

- (IBAction)addressWasEntered:(NSTextField *)sender;
{
    NSString *value = sender.stringValue;
    if (![value hasPrefix:@"http"]) {
        value = [NSString stringWithFormat:@"https://%@", value];
    }
    [self.selectedTabController loadUrl:[NSURL URLWithString:value]];
}

- (void)updateWebviewPreviews;
{
    for (WebViewTabController *controller in self.tabs) {
        controller.thumbnailImageSize = self.optimalThumbnailSize;
        controller.webView.frame = self.webViewSuperView.bounds;
        [controller requestThumbnail];
    }
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return self.tabs.count + 1;
}

static const CGFloat kBaseWidth = 150;

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row;
{
    CGFloat aspectRatio = self.webViewSuperView.bounds.size.width / self.webViewSuperView.bounds.size.height;
    return kBaseWidth / aspectRatio;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row;
{
    if (row == self.tabs.count) {
        return [NSImage imageNamed:@"add"];
    }

    return self.tabs[row].lastThumbnailImage;
}

#pragma mark - NSTableViewDelegate

- (void)tableViewSelectionDidChange:(NSNotification *)notification;
{
    if (self.tableView.selectedRow == self.tabs.count) {
        [self.tabs addObject:[WebViewTabController.alloc initWithDelegate:self]];
    }
    [self selectTab:self.tableView.selectedRow];
    self.selectedTabController.thumbnailImageSize = self.optimalThumbnailSize;
    [self.tableView reloadData];
}

#pragma mark - WebViewTabControllerDelegate

- (void)tabControllerDidCreateThumbnail:(NSImage *)thumbnail;
{
    [self.tableView reloadData];
}

- (void)webViewDidFinishLoading;
{
    [self.tableView reloadData];
}

@end
