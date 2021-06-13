
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
    [NSTimer scheduledTimerWithTimeInterval:.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.tabs[self.selectedTab] requestThumbnail];
    }];
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
    [self.selectedTabController loadUrl:[NSURL URLWithString:sender.stringValue]];
}

- (void)updateWebviewPreviews;
{
    for (WebViewTabController *controller in self.tabs) {
        controller.webView.frame = self.webViewSuperView.bounds;
        [controller requestThumbnail];
    }
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return self.tabs.count + 1;
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
