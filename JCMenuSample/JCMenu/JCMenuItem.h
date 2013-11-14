//
//  JCMenuItem.h
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

#import <Foundation/Foundation.h>

@interface JCMenuItem : NSObject

typedef void(^actionItem)(JCMenuItem *item);    // Block action

/*
 @image         -> unselected image / normal image if no selected image.
 @selectedImage -> selected image / nil
 @action        -> action related to item
 */
- (instancetype)initWithImage:(UIImage*)image selectedImage:(UIImage *)selectedImage action:(actionItem)action;

@property(nonatomic, strong) UIImage     *image;
@property(nonatomic, strong) UIImage     *selectedImage;
@property(nonatomic, copy)   actionItem   action;

@end
