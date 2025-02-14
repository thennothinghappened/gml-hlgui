# gml-hlgui

Pretty slow library for menus in the style of the Source engine. Useful for debug menus, if you're
not a fan of pulling in an ImGui library, and want more flexibility than the debug overlay can
provide.

## Sample

See the `Sample` group in the project for an example of what can be done with the UI system right
now. This also shows how to setup a `HLGui` instance to update and draw each frame.

## Default Widgets

Whilst you can of course create your own widgets, there are a few default ones based on the Source
engine's style, since I'm a fan of that personally :P

### Layout

Widgets which impact the menu layout.

#### `HLGuiWindow(x, y, width, visible, children)`

This widget is special, in that it is the root of layouts. Unlike other widgets, menus choose their
own `x`, `y`, and `width`. This widget can be extended to create custom menu looks and behaviours,
as is the case for the `Menu` variant.

```gml
var titleScreenWindow = new HLGuiWindow(200, 100, 200, true, [
    new HLGuiImage(sMenuBackground),
    new HLGuiPaddedBox(20, 20, [
        new HLGuiColumn([
            new HLGuiButton("Quit", function() {
                game_end();
            })
        ], 16)
    ])
]);

// Ordering here defines which windows sit on top of which others.
self.hlGui = new HLGui([titleScreenWindow]);
```

#### `HLGuiMenuWindow(title, x, y, width, visible, closable, children)`

A Source-styled menu, in line with HL2's menus.

```gml
var optionsMenu = new HLGuiMenuWindow("Options", 200, 100, 200, true, true, [
    new HLGuiColumn([
        HLGuiLabel("Hi!"),
        new HLGuiButton("Quit", function() {
            game_end();
        })
    ], 16)
]);

// Ordering here defines which windows sit on top of which others.
self.hlGui = new HLGui([optionsMenu]);
```

#### `HLGuiBox(children, [visible])`

A layout which stacks child elements in the same spot, and grows to the size of the largest one.

This layout is a reasonable default for widgets with only one child, or to display an overlay on
top of something else.

```gml
var box = new HLGuiBox([
    HLGuiLabel("Test!")
]);
```

#### `HLGuiColumn(children, [spacing], [visible])`

A layout which vertically stacks elements, with an optional padding (`spacing`) between each of
them.

```gml
var column = new HLGuiColumn([
    HLGuiLabel("Test!"),
    HLGuiLabel("Another line of text!"),
    HLGuiLabel("And another!"),
], 48);
```

#### `HLGuiRow(children, [spacing], [visible])`

A layout which horizontally stacks elements, with an optional padding (`spacing`) between each of
them.

> [!NOTE]
> Note that currently, misuse of `spacing` can overflow a container!

```gml
var row = new HLGuiRow([
    HLGuiLabel("Test!"),
    HLGuiLabel("Another line of text!"),
    HLGuiLabel("And another!"),
], 4);
```

#### `HLGuiSpacer(height)`

A vertical spacer to pad an area between elements.

```gml
var spacer = new HLGuiSpacer(16);
```

#### `HLGuiLabel(label)`

A static text label.

```gml
var label = HLGuiLabel("Hi!");
```

#### `HLGuiText(get)`

A dynamic text label.

```gml
var text = new HLGuiText(function() {
    return $"{floor(current_time / 1000)} seconds since game started.";
});
```

#### `HLGuiImage(sprite, [alpha])`

An image, which displays the given sprite. Images grow to fill the width they're given, and occupy
the height needed to display at the correct aspect ratio.

```gml
var image = new HLGuiImage(sExample, 0.5);
```

### Interaction

Widgets for the user to interact with in some capacity.

#### `HLGuiCheckbox(label, get, set)`

A checkbox for a toggleable value.

```gml
self.something = true;

var checkbox = new HLGuiCheckbox("Enable something",
    function() { return self.something; },
    function(checked) { self.something = checked; }
);
```

#### `HLGuiDropdown(label, choices, getChoice, setChoice)`

A dropdown for selecting items from a list.

```gml
self.options = ["Option A", "Option B", "Option C"];
self.chosenOption = self.options[0];

var dropdown = new HLGuiDropdown("Choose an option!", self.options,
    function() { return self.chosenOption; },
    function(chosenOption) { self.chosenOption = chosenOption; }
);
```

#### `HLGuiButton(label, onClick)`

A button that you can click.

```gml
var button = new HLGuiButton("Quit", function() {
    game_end();
});
```

#### `HLGuiSlider(label, minimum, maximum, get, set, [increments])`

A numerical slider between two values.

```gml
self.value = 0;

var slider = new HLGuiSlider("Value", 0, 10,
    function() { return self.value; },
    function(value) { self.value = round(value); },
);
```

## Technical Details

### Current unsuitability for "serious" work

Note that this library is **highly coupled to the mouse**. This is something that I'd like to
resolve in the future - the start of this is already in place thanks to a much higher emphasis on
widget `focus` state, but there's a lot of checking where the mouse is, and checking if the mouse is
hovering, clicks and the likes.

To tackle controller support, keyboard navigation and whatnot, it'd require a good bit of work to
abstract away input in some way. An idea that I've just thought of while writing, is something like
casting a ray from an artificial invisible "cursor" at the current focused UI element, toward the
stick direction, and finding the first thing it intersects with that isn't the same element. That'd
be neat, maybe. But that might be an issue if something were placed in a way that something else
obstructs it. I dunno.

### Backstory

The original version of this library was written by me multiple years ago, and was effectively a
single-pass UI that sat in a weird middle-ground of being defined ahead-of-time, but doing layout,
rendering *and* input in a single pass.

Needless to say, this isn't very flexible nor very fast. Regardless, I still loved using it -
a multitude of my private projects used it as a quick-and-dirty solution for a debugging UI.

It was also *extremely* loosely based on some menu system tutorials, I *think*, given the fact that
it made some very bizarre use of arrays for defining menus.

Anyway, over the years since I've, a few times, tried my hand at making *ridiculously* versatile
UI systems - most notably after spending a bit too long in Kotlin and Compose, which spawned the
extremely ill-fated [gml-sourceui](https://github.com/thennothinghappened/gml-sourceui), a framework
that tried way too hard to be like Compose despite being in GML, which has no fancy pre-processor
(the thing that makes Compose tick), and no closures (which Compose heavily uses everywhere.)

Despite those details though, I'd attribute the downfall of that project to one thing:

#### *Measuring*

To explain, "measuring" refers to a key part of the UI layout process in any multi-pass UI system.
It's a complicated process that involves figuring out what fits where, and how much space stuff
needs to work, and might even need multiple passes for finicky things like text, which can resize
by wrapping differently based on the space available.

To be honest, I've still not managed to properly wrap my head around how to measure a UI layout
properly. There's a whole lot going on, and it just hasn't quite clicked with me how to get the
order of operations right, nor how to sort out communicating up the chain of nodes when something
needs re-measuring.

I had another shot at that thanks to a bout of scope creep this morning (as of writing), but ended
up bailing on it, since it was just too complicated and went way beyond the scope of what I wanted
to achieve by re-writing this.

So, that's how we get to where we are now, with a measuring system that only works on the vertical
axis, and isn't very intelligent.

### The Current System

The way the UI system works is in a few parts. Every frame, we re-query mouse input - keyboard will
be added soon to that, to support text input.

From there, we handle the mouse hover and focus state, updating as needed.
Any changes or mouse input here is sent onto the relevant widgets to act upon.

The main magic happens in the `draw` method of `HLGui`. Here, we iterate each visible menu. Menus
have the special property of being the only widget with a defined position and width, which is then
used to define the parameters for measuring down the chain of child widgets.

Measuring in this library is done on one axis, for reasons discussed in the Backstory section
earlier. In essence though, this means two things:

  1. There's less data being passed around, and a lot less edge cases on stuff, but things are a bit
     depressing in the horizontal axis as for partitioning space interestingly.
  
  2. It means the library is actually in a usable state and not in dev-limbo, because I don't really
     know what I'm doing when it comes to this stuff yet. I'd love to learn one day though, and I'm
     open to a large-scale refactoring to make it happen if anyone can point me toward some
     resources on how people tend to accomplish this sort of measuring system (or other ways of
     approaching it!)

Once widget heights are established, we move on to drawing each one. There's a lot of room for
improvement in the speed for this, and indeed some past UI experiments I've done for my 3D RTS of
many years past, I was able to cut down drawing to only ever happen when things actually change, and
not too expensively either.

Widgets which lay out other widgets are responsible for drawing them too. This is done down the
chain recursively to draw everything that should be visible.

And, now that's done, we have a visible UI on screen!
