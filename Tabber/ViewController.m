
#import "ViewController.h"
#import "WebViewTabController.h"
#import "ThumnailCellView.h"
#import "NSView+Extras.h"

@import WebKit;

@interface ViewController() <NSTableViewDelegate, NSTableViewDataSource, WebViewTabControllerDelegate, NSSplitViewDelegate>
@property (weak) IBOutlet NSView *paneContainerView;
@property (weak) IBOutlet NSView *listContainerView;
@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *webViewSuperView;
@property (weak) IBOutlet NSTextField *addressField;
@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic) NSMutableArray <WebViewTabController *> *tabs;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (nonatomic) NSUInteger selectedTab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabs = NSMutableArray.new;

    [self.tabs addObject:[WebViewTabController.alloc initWithDelegate:self]];
    [self.webViewSuperView addSubview:self.tabs.firstObject.webView];
    self.tabs[self.selectedTab].webView.frame = self.webViewSuperView.bounds;
    self.tabs[self.selectedTab].preferredThumbnailImageSize = self.optimalThumbnailSize;
}

- (NSSize)optimalThumbnailSize;
{
    CGFloat targetWidth = self.listContainerView.bounds.size.width - 6;
    CGFloat widthRatio = targetWidth / self.paneContainerView.bounds.size.width;
    CGFloat targetImageHeight = self.listContainerView.bounds.size.height * widthRatio;

    return NSMakeSize(targetWidth * 2, targetImageHeight * 2);
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
        controller.preferredThumbnailImageSize = self.optimalThumbnailSize;
        controller.webView.frame = self.webViewSuperView.bounds;
        [controller requestThumbnail];
    }
}
#pragma mark - NSSplitViewDelegate

- (void)splitViewDidResizeSubviews:(NSNotification *)notification;
{
    [self viewDidLayout];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return self.tabs.count + 1;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row;
{
    return row == self.tabs.count ? 80 : (self.optimalThumbnailSize.height / 2) + 16 + 3 + 3 + 3;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
{

    ThumnailCellView *view = [tableView makeViewWithIdentifier:@"cellView" owner:self];
    if (row == self.tabs.count) {
        view.myTextField.stringValue = @"";
        view.myImageView.image = nil;
        return view;
    }
    view.myTextField.stringValue = self.tabs[row].url.absoluteString ?: @"";
    view.myImageView.image = self.tabs[row].lastThumbnailImage;
    return view;
}

#pragma mark - NSTableViewDelegate

- (void)tableViewSelectionDidChange:(NSNotification *)notification;
{
    BOOL addWasSelected = self.tableView.selectedRow == self.tabs.count;
    if (addWasSelected) {
        [self.tabs addObject:[WebViewTabController.alloc initWithDelegate:self]];
        self.progressIndicator.doubleValue = 0;
    }
    [self selectTab:self.tableView.selectedRow];
    self.selectedTabController.preferredThumbnailImageSize = self.optimalThumbnailSize;
    if (addWasSelected) {
        [self.tableView reloadData];
    }
}

#pragma mark - WebViewTabControllerDelegate

- (void)tabController:(WebViewTabController *)controller didCreateThumbnail:(NSImage *)thumbnail;
{
    [self.tableView reloadData];
}

- (void)webViewControllerDidLoadAmount:(CGFloat)amount;
{
    self.progressIndicator.doubleValue = amount * 100;
}

- (void)webViewControllerDidFinishLoading:(WebViewTabController *)controller;
{
    [self.tableView reloadData];
}

@end
