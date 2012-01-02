/*
 * AppController.j
 * OutlineView
 *
 * Created by Chandler Kent on December 7, 2009.
 * Copyright 2009, Your Company All rights reserved.
 *
 * http://www.chandlerkent.com/2009/12/10/Building-a-Sidebar-With-CPOutlineView.html
 * modified by Yves Serrano
 */

@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@implementation AppController : CPObject
{
    CPDictionary items;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    CPLogRegister(CPLogConsole);

    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, CGRectGetHeight([contentView bounds]))];
    [scrollView setBackgroundColor:[CPColor colorWithHexString:@"e0ecfa"]];
    [scrollView setAutohidesScrollers:YES];

    var outlineView = [[CPOutlineView alloc] initWithFrame:[[scrollView contentView] bounds]];

    var textColumn = [[CPTableColumn alloc] initWithIdentifier:@"TextColumn"];
    [textColumn setWidth:200.0];

    [outlineView setHeaderView:nil];
    [outlineView setCornerView:nil];
    [outlineView addTableColumn:textColumn];
    [outlineView setOutlineTableColumn:textColumn];

    [scrollView setDocumentView:outlineView];

    [contentView addSubview:scrollView];

    items = [CPDictionary dictionaryWithObjects:[[@"glossary 1"], [@"proj 1", @"proj 2", @"proj 3"]] forKeys:[@"Glossaries", @"Projects"]];
    [outlineView setDataSource:self];
    [outlineView setDelegate:self];

    [theWindow orderFront:self];
}

- (id)outlineView:(CPOutlineView)outlineView child:(int)index ofItem:(id)item
{
    if (item === nil)
    {
        var keys = [items allKeys];
        return [keys objectAtIndex:index];
    }
    else
    {
        var values = [items objectForKey:item];
        return [values objectAtIndex:index];
    }
}

- (BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
    var values = [items objectForKey:item];
    return ([values count] > 0);
}

- (int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
    if (item === nil)
    {
        return [items count];
    }
    else
    {
        var values = [items objectForKey:item];
        return [values count];
    }
}

- (id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)item
{
    return item;
}

- (void)outlineView:(CPOutlineView)outlineView willDisplayView:(id)dataView forTableColumn:(CPTableColumn)tableColumn item:(id)item
{
    console.log(item);
    if (item == @"proj 3")
    {
        CPLog.debug(dataView);CPLog.debug(@"set to red");
        [dataView setTextColor:[CPColor colorWithHexString:@"FF0000"]];
    }
}

@end
