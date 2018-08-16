//
// STableViewController.m
//
// @author Shiki
//

#import "STableViewController.h"

#define DEFAULT_HEIGHT_OFFSET 52.0f

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation STableViewController

@synthesize tableView;
@synthesize headerView;
@synthesize footerView;

@synthesize isDragging;
@synthesize isRefreshing;
@synthesize isLoadingMore;

@synthesize canLoadMore;

@synthesize pullToRefreshEnabled;

@synthesize clearsSelectionOnViewWillAppear;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) initialize
{
  pullToRefreshEnabled = YES;
  
  canLoadMore = YES;
  
  clearsSelectionOnViewWillAppear = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init
{
  if ((self = [super init]))
    [self initialize];  
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder]))
    [self initialize];
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidLoad
{
  [super viewDidLoad];
  
  self.tableView = [[[UITableView alloc] init] autorelease];
  tableView.frame = self.view.bounds;
  tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  tableView.dataSource = self;
  tableView.delegate = self;
  
  [self.view addSubview:tableView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if (clearsSelectionOnViewWillAppear) {
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected)
      [self.tableView deselectRowAtIndexPath:selected animated:animated];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Pull to Refresh

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setHeaderView:(UIView *)aView
{
  if (!tableView)
    return;
  
  if (headerView && [headerView isDescendantOfView:tableView])
    [headerView removeFromSuperview];
  [headerView release]; headerView = nil;
  
  if (aView) {
    headerView = [aView retain];
    
    CGRect f = headerView.frame;
    headerView.frame = CGRectMake(f.origin.x, 0 - f.size.height, f.size.width, f.size.height);
    headerViewFrame = headerView.frame;
    
    [tableView addSubview:headerView];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) headerRefreshHeight
{
  if (!CGRectIsEmpty(headerViewFrame))
    return headerViewFrame.size.height;
  else
    return DEFAULT_HEIGHT_OFFSET;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pinHeaderView
{
  [UIView animateWithDuration:0.3 animations:^(void) {
    self.tableView.contentInset = UIEdgeInsetsMake([self headerRefreshHeight], 0, 0, 0);
  }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unpinHeaderView
{
  [UIView animateWithDuration:0.3 animations:^(void) {
    self.tableView.contentInset = UIEdgeInsetsZero;
  }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willBeginRefresh
{ 
  if (pullToRefreshEnabled)
    [self pinHeaderView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willShowHeaderView:(UIScrollView *)scrollView
{
  
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
  
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) refresh
{
  if (isRefreshing)
    return NO;
  
  [self willBeginRefresh];
  isRefreshing = YES;
  return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) refreshCompleted
{
  isRefreshing = NO;
  
  if (pullToRefreshEnabled)
    [self unpinHeaderView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Load More

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterView:(UIView *)aView
{
  if (!tableView)
    return;
  
  tableView.tableFooterView = nil;
  [footerView release]; footerView = nil;
  
  if (aView) {
    footerView = [aView retain];
    
    tableView.tableFooterView = footerView;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willBeginLoadingMore
{
  
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadMoreCompleted
{
  isLoadingMore = NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (isLoadingMore)
    return NO;
  
  [self willBeginLoadingMore];
  isLoadingMore = YES;  
  return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) footerLoadMoreHeight
{
  if (footerView)
    return footerView.frame.size.height;
  else
    return DEFAULT_HEIGHT_OFFSET;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterViewVisibility:(BOOL)visible
{
  if (visible && self.tableView.tableFooterView != footerView)
    self.tableView.tableFooterView = footerView;
  else if (!visible)
    self.tableView.tableFooterView = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) allLoadingCompleted
{
  if (isRefreshing)
    [self refreshCompleted];
  if (isLoadingMore)
    [self loadMoreCompleted];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if (isRefreshing)
    return;
  isDragging = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (!isRefreshing && isDragging && scrollView.contentOffset.y < 0) {
    [self headerViewDidScroll:scrollView.contentOffset.y < 0 - [self headerRefreshHeight] 
                   scrollView:scrollView];
  } else if (!isLoadingMore && canLoadMore) {
    CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    if (scrollPosition < [self footerLoadMoreHeight]) {
      [self loadMore];
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if (isRefreshing)
    return;
  
  isDragging = NO;
  if (scrollView.contentOffset.y <= 0 - [self headerRefreshHeight]) {
    if (pullToRefreshEnabled)
      [self refresh];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) releaseViewComponents
{
  [headerView release]; headerView = nil;
  [footerView release]; footerView = nil;
  [tableView release]; tableView = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
  [self releaseViewComponents];
  [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidUnload
{
  [self releaseViewComponents];
  [super viewDidUnload];
}

@end
