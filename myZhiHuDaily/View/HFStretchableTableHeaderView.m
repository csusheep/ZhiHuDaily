//
//  StretchableTableHeaderView.m
//  StretchableTableHeaderView
//

#import "HFStretchableTableHeaderView.h"

@interface HFStretchableTableHeaderView()
{
    CGRect initialFrame;
    CGFloat defaultViewHeight;
}
@end


@implementation HFStretchableTableHeaderView

@synthesize tableView = _tableView;
@synthesize view = _view;

- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view
{
    _tableView = tableView;
    _view      = view;

    initialFrame      = _view.frame;
    defaultViewHeight = initialFrame.size.height;
    
    UIView* emptyTableHeaderView = [[UIView alloc] initWithFrame:initialFrame];
    _tableView.tableHeaderView   = emptyTableHeaderView;
    [_tableView.tableHeaderView addSubview:_view];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView.contentOffset.y > initialFrame.size.height ) {
        return;
    }
    CGFloat offsetY          = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
    initialFrame.origin.y    = offsetY * -1;
    initialFrame.size.height = defaultViewHeight + offsetY;
    _view.frame              = initialFrame;

}

- (void)resizeView
{
//    initialFrame.size.width = _tableView.frame.size.width;
//    _view.frame = initialFrame;
}


@end
