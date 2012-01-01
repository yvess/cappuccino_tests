/*
 * AppController.j
 * CustomDataView
 *
 * Created by You on December 31, 2011.
 * Copyright 2011, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>



/* ** Parent */
@implementation Parent : CPObject
{
  CPString        label @accessors();
  CPMutableArray  childs @accessors(readonly);
}

- (id)initWithLabel:(CPString)aLabel
{
    self = [super init];
    if (self)
    {
      childs = [[CPMutableArray alloc] init];
      [self setLabel:aLabel];
    }
    return self;
}

- (CPString)objectValueForOutlineColumn:(CPString)aTableColumn
{
    return [self label];
}
@end




@implementation EditButtonView : CPView
{
}

- (void)setObjectValue:(id)anObject
{
    var textfield = [[self subviews] objectAtIndex:1]; // this is the textfield
    [textfield setObjectValue:anObject];
}
@end






/* ** Child */
@implementation Child : CPObject
{
    CPString name @accessors();
    CPView editView @accessors();
}

- (id)initWithName:(CPString)aName editView:(CPView)aView
{
    [self setName:aName];
    [self setEditView:aView];
    return self;
}
- (CPString)objectValueForOutlineColumn:(CPString)aTableColumn
{
    return [self name];
}
@end







/* ** Outline Controller */
@implementation GroupOutlineController : CPObject
{
    Group group @accessors(readonly);
    CPOutlineView groupOutline;
}

- (id)initWithGroup:(Group)aGroup outline:(CPOutlineView)anOutline
{
    self = [super init];
    if (self)
    {
        group = aGroup;
        groupOutline = anOutline;
    }
    return self;
}

- (int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
    var count = 2; // for root îtem
    if (item != nil)
    {
        if ([item respondsToSelector:CPSelectorFromString(@"childs")])
        {
            count = [[item childs] count];
        } else {
            count = 0;
        }
    }
    return count;
}

- (id)outlineView:(CPOutlineView)outlineView child:(int)index ofItem:(id)item
{
    var result = nil;
    if (item == nil)
    {
        result = [[self group] objectAtIndex: index];
    } else {
        result = [[item childs] objectAtIndex: index];
    }
    return result;
}

- (id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)item
{
    var value = @"";
    if ([tableColumn identifier])
    {
        value = (item == nil) ? @"" : [item objectValueForOutlineColumn: tableColumn];
    }
    return value;
}

- (BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
    var numberOfChilds = [self outlineView:outlineView numberOfChildrenOfItem:item];
    if (numberOfChilds == 0)
    {
        var rows = [outlineView rowsInRect:[outlineView visibleRect]];
    }
    return [self outlineView:outlineView numberOfChildrenOfItem:item] > 0;
}

- (CPView)outlineView:(CPOutlineView)aOutlineView dataViewForTableColumn:(CPTableColumn)aTableColumn item:(id)anItem
{
    var dataView = nil;
    if ([anItem isKindOfClass:[Child class]])
    {
        dataView = [anItem editView];
    } else {
        dataView = nil;
    }
    console.log("dataview", dataView);
    return dataView;
}

@end






/* AppController */
@implementation AppController : CPObject
{
    CPWindow                theWindow; //this "outlet" is connected automatically by the Cib
    IBOutlet                CPOutlineView namesOutline;
    IBOutlet                CPView editView;
    GroupOutlineController  groupOutlineController;
}

- (id)init
{
    return self;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var child1 = [[Child alloc] initWithName:@"Michael" editView:editView],
        child2 = [[Child alloc] initWithName:@"Daniel" editView:editView],
        child3 = [[Child alloc] initWithName:@"Jane" editView:editView],
        child4 = [[Child alloc] initWithName:@"Greta" editView:editView];

    var parent1 = [[Parent alloc] initWithLabel:@"Peter"],
        parent2 = [[Parent alloc] initWithLabel:@"Maria"];

    [[parent1 childs] addObject:child1];
    [[parent1 childs] addObject:child2];
    [[parent2 childs] addObject:child3];
    [[parent2 childs] addObject:child4];

    var group = [[CPMutableArray alloc] init];
    [group addObject:parent1];
    [group addObject:parent2];
    groupOutlineController = [[GroupOutlineController alloc] initWithGroup:group outline:namesOutline];

    [namesOutline setDataSource:groupOutlineController];
    [namesOutline setDelegate:groupOutlineController];
}

- (void)awakeFromCib
{
    [theWindow setFullPlatformWindow:YES];
}

@end
