//
//  JCMenu.m
//  JC UI Composant
//

/*
 *
 * Copyright (c) 2013 Jean-Baptiste Castro (@jbaptistecastro)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "JCMenu.h"
#import "JCMenuItem.h"

#import <QuartzCore/QuartzCore.h>

@interface JCMenu (/* Private */)

@property(nonatomic, copy)   NSMutableArray *layerArray;                   // Contain layer items. Use for rect management.

@property(nonatomic)         CGFloat originX;
@property(nonatomic)         CGFloat originY;
@property(nonatomic)         CGFloat segmentWidth;
@property(nonatomic)         CGFloat menuHeight;

@property(nonatomic, assign) NSInteger index;
@property(nonatomic, assign) NSInteger touchIndex;

- (void)__setupMenu;

/*
 Expand / Shrink Management
 */
- (void)__expandMenu;
- (void)__shrinkMenu;

/*
 Rect management (menu expand/shrink)
 */
- (void)__buildMenu;
- (CGRect)__updateFrame;                                                    // Menu frame.
- (CGRect)__updateItemRectFromFrame:(CGRect)frame index:(NSInteger)index;   // Item frame.

/*
 Update Layer Content
 */
- (void)__updateLayer:(CALayer *)layer withImage:(UIImage*)image;

- (CGRect)__getSegmentFrameAtIndex:(NSInteger)index;                        // Use for touch methods

@end

@implementation JCMenu

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        
        self.items = [items copy];
        [self __setupMenu];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        [self __setupMenu];
    }
    
    return self;
}

- (void)__setupMenu
{
    self.originX = self.frame.origin.x;
    self.originY = self.frame.origin.y;
    
    self.expand = NO;
    
    self.menuTintColor = [UIColor blackColor];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    self.isExpand ? [self __expandMenu] : [self __shrinkMenu];
    
    if (self.selectedItem.selectedImage != nil) {
        CALayer    *selectedLayer = [self.layerArray objectAtIndex:self.index];
        [self __updateLayer:selectedLayer withImage:self.selectedItem.selectedImage];
    }
}

#pragma mark - Rect Management

- (void)__buildMenu
{
    NSMutableArray *layerA = [[NSMutableArray alloc] initWithCapacity:[self.items count]];
    
    [self.items enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
        JCMenuItem *menuItem = item;
        UIImage *image = menuItem.image;
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        
        CGFloat x = self.segmentWidth * index + (self.segmentWidth - imageWidth) / 2;
        CGFloat y = (self.menuHeight / 2) - (imageHeight / 2);
        
        CGRect rect = CGRectMake(x, y, imageWidth, imageHeight);
        
        CALayer *imageLayer = [CALayer layer];
        [imageLayer setContents:(id)image.CGImage];
        [imageLayer setFrame:rect];
        [imageLayer setOpacity:0];
        [self.layer addSublayer:imageLayer];
        
        [layerA addObject:imageLayer];
    }];
    
    self.layerArray = layerA;
}

- (CGRect)__updateFrame
{
    CGRect expandRect = CGRectMake(self.originX, self.originY, self.frame.size.width * [self.items count], self.menuHeight);
    CGRect shrinkRect = CGRectMake(self.originX, self.originY, self.frame.size.width / [self.items count], self.frame.size.height);
    
    
    return self.isExpand ? expandRect : shrinkRect;
}

- (CGRect)__updateItemRectFromFrame:(CGRect)frame index:(NSInteger)index
{
    CGFloat imageWidth = frame.size.width;
    CGFloat imageHeight = frame.size.height;
    CGFloat y = (self.menuHeight / 2) - (imageHeight / 2);
    
    CGRect itemExpandRect = CGRectMake(self.segmentWidth * index + (self.segmentWidth - imageWidth) / 2, y, imageWidth, imageHeight);
    CGRect itemShrinkRect = CGRectMake((self.segmentWidth - imageWidth) / 2, y, imageWidth, imageWidth);
    
    return self.isExpand ? itemExpandRect : itemShrinkRect;
}

#pragma mark - Touch method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        if (self.isExpand) {
            self.touchIndex = touchLocation.x / (self.frame.size.width / [self.items count]);
            
            if (self.index != self.touchIndex) {
                JCMenuItem *touchItem = [self.items objectAtIndex:self.touchIndex];
                
                CALayer    *touchLayer = [self.layerArray objectAtIndex:self.touchIndex];
                if (touchItem.selectedImage != nil)
                    [self __updateLayer:touchLayer withImage:touchItem.selectedImage];
                else
                    [touchLayer setOpacity:1];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint([self __getSegmentFrameAtIndex:self.touchIndex], touchLocation)) {
        if (self.isExpand) {
            if (self.index != self.touchIndex) {
                JCMenuItem *touchItem  = [self.items objectAtIndex:self.touchIndex];
                
                CALayer    *touchLayer = [self.layerArray objectAtIndex:self.touchIndex];
                if (touchItem.selectedImage != nil)
                    [self __updateLayer:touchLayer withImage:touchItem.selectedImage];
                else
                    [touchLayer setOpacity:1];
            }
        }
    } else {
        if (self.index != self.touchIndex) {
            JCMenuItem *touchItem = [self.items objectAtIndex:self.touchIndex];
            
            CALayer    *touchLayer = [self.layerArray objectAtIndex:self.touchIndex];
            if (touchItem.selectedImage != nil)
                [self __updateLayer:touchLayer withImage:touchItem.image];
            else
                [touchLayer setOpacity:0.5];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        if (self.isExpand) {
            self.index = touchLocation.x / (self.frame.size.width / [self.items count]);
            
            [self setSelectedItem:[self.items objectAtIndex:self.index]];
        } else
            [self setExpand:YES];
    }
}

- (CGRect)__getSegmentFrameAtIndex:(NSInteger)index
{
    return CGRectMake(self.originX + (self.segmentWidth * index), 0, self.segmentWidth, self.frame.size.height);
}

#pragma mark - Expand / Shrink

- (void)__expandMenu
{
    [UIView animateWithDuration:0.2 animations:^{
        CALayer *selectedLayer = [self.layerArray objectAtIndex:self.index];
        [selectedLayer setFrame:[self __updateItemRectFromFrame:selectedLayer.frame index:self.index]];
        [selectedLayer setOpacity:1];
        
        [self setFrame:[self __updateFrame]];
    }completion:^(BOOL finished){
        [self.items enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
            JCMenuItem *menuItem = item;
            CALayer *layer = [self.layerArray objectAtIndex:index];
            
            if (index != self.index) {
                if (menuItem.selectedImage != nil) {
                    [self __updateLayer:layer withImage:menuItem.image];
                    [layer setOpacity:1];
                } else
                    [layer setOpacity:0.5];
            }
            
        }];
    }];
}

- (void)__shrinkMenu
{
    [self.items enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
            JCMenuItem *menuItem = item;
            
            CALayer *layer = [self.layerArray objectAtIndex:index];
            
            if (index != self.index) {
                if (menuItem.selectedImage != nil)
                    [self __updateLayer:layer withImage:menuItem.image];
            }
            
            [layer setOpacity:0];
                
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        CALayer *selectedLayer = [self.layerArray objectAtIndex:self.index];
        [selectedLayer setFrame:[self __updateItemRectFromFrame:selectedLayer.frame index:self.index]];
        [selectedLayer setOpacity:1];
            
        [self setFrame:[self __updateFrame]];
    }];
}

#pragma mark - Update Layer Content

- (void)__updateLayer:(CALayer *)layer withImage:(UIImage*)image
{
    CGRect frame = layer.frame;
    frame.size.width  = image.size.width;
    frame.size.height = image.size.height;
    
    [layer setFrame:frame];
    [layer setContents:(id)image.CGImage];
}

#pragma mark - Setter

- (void)setItems:(NSArray *)items
{
    if (_items != items) {
        _items = items;
        
        self.segmentWidth = self.frame.size.width / [self.items count];
        self.menuHeight = self.frame.size.height;
        
        [self __updateFrame];   // Update menu frame
        [self __buildMenu];     // Build menu with items
        
        [self setNeedsDisplay];
    }
}

- (void)setSelectedItem:(JCMenuItem *)selectedItem
{
    if (_selectedItem != selectedItem) {
        _selectedItem = selectedItem;
        
        // Item action
        
        if (_selectedItem.action)
            _selectedItem.action(_selectedItem);
        
        if (_selectedItem.selectedImage != nil)
            [self setNeedsDisplay];
    }
    
    [self setExpand:NO];
}

- (void)setExpand:(BOOL)expand
{
    if (_expand != expand) {
        _expand = expand;
        
        [self setNeedsDisplay];
    }
}

- (void)setMenuTintColor:(UIColor *)menuTintColor
{
    if (_menuTintColor != menuTintColor) {
        _menuTintColor = menuTintColor;
        
        [self setBackgroundColor:_menuTintColor];
    }
}

@end
