when defined(lFreetype):
  import freetype

when defined(windows):
  when defined(vcc):
    {.link: "user32.lib".}
    {.link: "gdi32.lib".}
  else:
    {.passL: "-luser32".}
    {.passL: "-lgdi32".}

  {.passC: "-DUI_WINDOWS".}
elif defined(linux):
  {.passL: "-lX11".}
  {.passL: "-lm".}

  {.passC: "-DUI_LINUX".}
else:
  {.error: "Only Linux and Windows are supported by luigi.".}

when defined(lFreetype):
  {.passC: "-DUI_FREETYPE".}

when defined(lDebug):
  {.passC: "-DUI_DEBUG".}

{.passC: "-DUI_IMPLEMENTATION".}
{.compile: "./luigi/source/luigi.c".}

const
  SIZE_BUTTON_MINIMUM_WIDTH* = (100)
  SIZE_BUTTON_PADDING* = (16)
  SIZE_BUTTON_HEIGHT* = (27)
  SIZE_BUTTON_CHECKED_AREA* = (4)

  SIZE_CHECKBOX_BOX* = (14)
  SIZE_CHECKBOX_GAP* = (8)

  SIZE_MENU_ITEM_HEIGHT* = (24)
  SIZE_MENU_ITEM_MINIMUM_WIDTH* = (160)
  SIZE_MENU_ITEM_MARGIN* = (9)

  SIZE_GAUGE_WIDTH* = (200)
  SIZE_GAUGE_HEIGHT* = (22)

  SIZE_SLIDER_WIDTH* = (200)
  SIZE_SLIDER_HEIGHT* = (25)
  SIZE_SLIDER_THUMB* = (15)
  SIZE_SLIDER_TRACK* = (5)

  SIZE_TEXTBOX_MARGIN* = (3)
  SIZE_TEXTBOX_WIDTH* = (200)
  SIZE_TEXTBOX_HEIGHT* = (27)

  SIZE_TAB_PANE_SPACE_TOP* = (2)
  SIZE_TAB_PANE_SPACE_LEFT* = (4)

  SIZE_SPLITTER* = (8)

  SIZE_SCROLL_BAR* = (16)
  SIZE_SCROLL_MINIMUM_THUMB* = (20)

  #SIZE_CODE_MARGIN* = (ui.activeFont.glyphWidth * 5)
  #SIZE_CODE_MARGIN_GAP* = (ui.activeFont.glyphWidth * 1)

  SIZE_TABLE_HEADER* = (26)
  SIZE_TABLE_COLUMN_GAP* = (20)
  SIZE_TABLE_ROW* = (20)

  SIZE_PANE_MEDIUM_BORDER* = (5)
  SIZE_PANE_MEDIUM_GAP* = (5)
  SIZE_PANE_SMALL_BORDER* = (3)
  SIZE_PANE_SMALL_GAP* = (3)

  SIZE_MDI_CHILD_BORDER* = (6)
  SIZE_MDI_CHILD_TITLE* = (30)
  SIZE_MDI_CHILD_CORNER* = (12)
  SIZE_MDI_CHILD_MINIMUM_WIDTH* = (100)
  SIZE_MDI_CHILD_MINIMUM_HEIGHT* = (50)
  SIZE_MDI_CASCADE* = (30)

  # --- update

  UPDATE_HOVERED* = (1)
  UPDATE_PRESSED* = (2)
  UPDATE_FOCUSED* = (3)

  # --- cursor

  CURSOR_ARROW* = (0)
  CURSOR_TEXT* = (1)
  CURSOR_SPLIT_V* = (2)
  CURSOR_SPLIT_H* = (3)
  CURSOR_FLIPPED_ARROW* = (4)
  CURSOR_CROSS_HAIR* = (5)
  CURSOR_HAND* = (6)
  CURSOR_RESIZE_UP* = (7)
  CURSOR_RESIZE_LEFT* = (8)
  CURSOR_RESIZE_UP_RIGHT* = (9)
  CURSOR_RESIZE_UP_LEFT* = (10)
  CURSOR_RESIZE_DOWN* = (11)
  CURSOR_RESIZE_RIGHT* = (12)
  CURSOR_RESIZE_DOWN_RIGHT* = (13)
  CURSOR_RESIZE_DOWN_LEFT* = (14)
  CURSOR_COUNT* = (15)

  # --- align

  ALIGN_LEFT* = (1)
  ALIGN_RIGHT* = (2)
  ALIGN_CENTER* = (3)

  # --- element

  ELEMENT_V_FILL* = (1 shl 16)
  ELEMENT_H_FILL* = (1 shl 17)
  ELEMENT_WINDOW* = (1 shl 18)
  ELEMENT_PARENT_PUSH* = (1 shl 19)
  ELEMENT_TAB_STOP* = (1 shl 20)
  ELEMENT_NON_CLIENT* = (1 shl 21) ##  Don't destroy in UIElementDestroyDescendents, like scroll bars.
  ELEMENT_DISABLED* = (1 shl 22)  ##  Don't receive input events.
  ELEMENT_HIDE* = (1 shl 29)
  ELEMENT_DESTROY_C* = (1 shl 30)
  ELEMENT_DESTROY_DESCENDENT* = (1 shl 31)

  # --- window

  WINDOW_MENU* = (1 shl 0)
  WINDOW_INSPECTOR* = (1 shl 1)
  WINDOW_CENTER_IN_OWNER* = (1 shl 2)
  WINDOW_MAXIMIZE* = (1 shl 3)

  # --- panel

  PANEL_HORIZONTAL* = (1 shl 0)
  PANEL_GRAY* = (1 shl 2)
  PANEL_WHITE* = (1 shl 3)
  PANEL_EXPAND* = (1 shl 4)
  PANEL_MEDIUM_SPACING* = (1 shl 5)
  PANEL_SMALL_SPACING* = (1 shl 6)
  PANEL_SCROLL* = (1 shl 7)
  PANEL_BORDER* = (1 shl 8)

  # --- button

  BUTTON_SMALL* = (1 shl 0)
  BUTTON_MENU_ITEM* = (1 shl 1)
  BUTTON_CAN_FOCUS* = (1 shl 2)
  BUTTON_DROP_DOWN* = (1 shl 3)
  BUTTON_CHECKED* = (1 shl 15)

  # --- checkbox

  CHECKBOX_ALLOW_INDETERMINATE* = (1 shl 0)
  CHECK_UNCHECKED* = (0)
  CHECK_CHECKED* = (1)
  CHECK_INDETERMINATE* = (2)

  # --- spacer line

  SPACER_LINE* = (1 shl 0)

  # --- split pane

  SPLIT_PANE_VERTICAL* = (1 shl 0)

  # --- scroll bar

  SCROLL_BAR_HORIZONTAL* = (1 shl 0)

  # --- code

  CODE_NO_MARGIN* = (1 shl 0)

  # --- menu

  MENU_PLACE_ABOVE* = (1 shl 0)
  MENU_NO_SCROLL* = (1 shl 1)

  # --- color picker

  COLOR_PICKER_HAS_OPACITY* = (1 shl 0)

  # --- MDI

  MDI_CLIENT_TRANSPARENT* = (1 shl 0)
  MDI_CHILD_CLOSE_BUTTON* = (1 shl 0)

  # --- Keycodes

  KEYCODE_A* = 97
  KEYCODE_BACKSPACE* = 65288
  KEYCODE_DELETE* = 65535
  KEYCODE_DOWN* = 65364
  KEYCODE_END* = 65367
  KEYCODE_ENTER* = 65293
  KEYCODE_ESCAPE* = 65307
  KEYCODE_F1* = 65470
  KEYCODE_HOME* = 65360
  KEYCODE_LEFT* = 65361
  KEYCODE_RIGHT* = 65363
  KEYCODE_SPACE* = 32
  KEYCODE_TAB* = 65289
  KEYCODE_UP* = 65362
  KEYCODE_INSERT* = 65379
  KEYCODE_0* = 48

type
  Message* = enum
    msgPaint,                ##  dp = pointer to UIPainter
    msgLayout, 
    msgDestroy, 
    msgUpdate, ##  di = UI_UPDATE_... constant
    msgAnimate, 
    msgScrolled, 
    msgGetWidth, ##  di = height (if known); return width
    msgGetHeight,           ##  di = width (if known); return height
    msgFindByPoint,        ##  dp = pointer to UIFindByPoint; return 1 if handled
    msgClientParent,        ##  dp = pointer to UIElement *, set it to the parent for client elements
    msgInputEventsStart,   ##  not sent to disabled elements
    msgLeftDown, 
    msgLeftUp, 
    msgMiddleDown, 
    msgMiddleUp, 
    msgRightDown,
    msgRightUp, 
    msgKeyTyped, ##  dp = pointer to UIKeyTyped; return 1 if handled
    msgMouseMove, 
    msgMouseDrag, 
    msgMouseWheel, ##  di = delta; return 1 if handled
    msgClicked, 
    msgGetCursor, ##  return cursor code
    msgPressedDescendent,   ##  dp = pointer to child that is/contains pressed element
    msgInputEventsEnd, 
    msgValueChanged, ##  sent to notify that the element's value has changed
    msgTableGetItem,       ##  dp = pointer to UITableGetItem; return string length
    msgCodeGetMarginColor, ##  di = line index (starts at 1); return color
    msgCodeDecorateLine,   ##  dp = pointer to UICodeDecorateLine
    msgWindowClose,         ##  return 1 to prevent default (process exit for UIWindow; close for UIMDIChild)
    msgTabSelected,         ##  sent to the tab that was selected (not the tab pane itself)
    msgWindowDropFiles,    ##  di = count, dp = char ** of paths
    msgWindowActivate, 
    msgUser


type
  Rectangle* {.bycopy.} = object
    l*: cint
    r*: cint
    t*: cint
    b*: cint

  Theme* {.bycopy.} = object
    panel1*: uint32
    panel2*: uint32
    selected*: uint32
    border*: uint32
    text*: uint32
    textDisabled*: uint32
    textSelected*: uint32
    buttonNormal*: uint32
    buttonHovered*: uint32
    buttonPressed*: uint32
    buttonDisabled*: uint32
    textboxNormal*: uint32
    textboxFocused*: uint32
    codeFocused*: uint32
    codeBackground*: uint32
    codeDefault*: uint32
    codeComment*: uint32
    codeString*: uint32
    codeNumber*: uint32
    codeOperator*: uint32
    codePreprocessor*: uint32

  Painter* {.bycopy.} = object
    clip*: Rectangle
    bits*: ptr uint32
    width*: cint
    height*: cint
    when defined(lDebug):
      fillCount*: cint

  Font* {.bycopy.} = object
    glyphWidth*: cint
    glyphHeight*: cint
    when defined(lFreetype):
      isFreeType*: bool
      font*: FT_Face
      glyphs*: array[128, FT_Bitmap]
      glyphsRendered*: array[128, bool]
      glyphOffsetsX*: array[128, cint]
      glyphOffsetsY*: array[128, cint]

  Shortcut* {.bycopy.} = object
    code*: cint # intptr_t
    ctrl*: bool
    shift*: bool
    alt*: bool
    invoke*: proc (cp: pointer) {.cdecl.}
    cp*: pointer

  StringSelection* {.bycopy.} = object
    carets*: array[2, cint]
    colorText*: uint32
    colorBackground*: uint32

  KeyTyped* {.bycopy.} = object
    text*: cstring
    textBytes*: cint
    code*: cint # intptr_t

  TableGetItem* {.bycopy.} = object
    buffer*: cstring
    bufferBytes*: csize_t
    index*: cint
    column*: cint
    isSelected*: bool

  CodeDecorateLine* {.bycopy.} = object
    bounds*: Rectangle
    index*: cint
    ##  Starting at 1!
    x*: cint
    y*: cint
    ##  Position where additional text can be drawn.
    painter*: ptr Painter

  FindByPoint* {.bycopy.} = object
    x*: cint
    y*: cint
    result*: ptr Element

  Element* {.bycopy.} = object
    flags*: uint32
    ##  First 16 bits are element specific.
    id*: uint32
    parent*: ptr Element
    next*: ptr Element
    children*: ptr Element
    window*: ptr Window
    bounds*: Rectangle
    clip*: Rectangle
    cp*: pointer
    ##  Context pointer (for user).
    messageClass*: proc (element: ptr Element; message: Message; di: cint; dp: pointer): cint {.
        cdecl.}
    messageUser*: proc (element: ptr Element; message: Message; di: cint; dp: pointer): cint {.
        cdecl.}
    cClassName*: cstring

  Window* {.bycopy.} = object
    e*: Element
    dialog*: ptr Element
    shortcuts*: ptr Shortcut
    shortcutCount*: csize_t
    shortcutAllocated*: csize_t
    scale*: cfloat
    bits*: ptr uint32
    width*: cint
    height*: cint
    next*: ptr Window
    hovered*: ptr Element
    pressed*: ptr Element
    focused*: ptr Element
    dialogOldFocus*: ptr Element
    pressedButton*: cint
    cursorX*: cint
    cursorY*: cint
    cursorStyle*: cint
    ##  Set when a textbox is modified.
    ##  Useful for tracking whether changes to the loaded document have been saved.
    textboxModifiedFlag*: bool
    ctrl*: bool
    shift*: bool
    alt*: bool
    updateRegion*: Rectangle
    when defined(lDebug):
      lastFullFillCount*: cfloat
    when defined(linux):
      #window*: Window
      #image*: ptr XImage
      #xic*: XIC
      
      ctrlCode*: cuint
      shiftCode*: cuint
      altCode*: cuint
      #dragSource*: Window
    when defined(windows):
      hwnd*: pointer # HWND
      trackingLeave*: bool

  Panel* {.bycopy.} = object
    e*: Element
    scrollBar*: ptr ScrollBar
    border*: Rectangle
    gap*: cint

  Button* {.bycopy.} = object
    e*: Element
    label*: cstring
    labelBytes*: pointer # cint
    invoke*: proc (cp: pointer) {.cdecl.}

  Checkbox* {.bycopy.} = object
    e*: Element
    check*: uint8
    label*: cstring
    labelBytes*: pointer # cint
    invoke*: proc (cp: pointer) {.cdecl.}

  Label* {.bycopy.} = object
    e*: Element
    label*: cstring
    labelBytes*: pointer # cint

  Spacer* {.bycopy.} = object
    e*: Element
    width*: cint
    height*: cint

  SplitPane* {.bycopy.} = object
    e*: Element
    weight*: cfloat

  TabPane* {.bycopy.} = object
    e*: Element
    tabs*: cstring
    active*: cint

  ScrollBar* {.bycopy.} = object
    e*: Element
    maximum*: int64
    page*: int64
    dragOffset*: int64
    position*: cdouble
    lastAnimateTime*: uint64
    inDrag*: bool
    horizontal*: bool

  CodeLine* {.bycopy.} = object
    offset*: cint
    bytes*: cint

  Code* {.bycopy.} = object
    e*: Element
    vScroll*: ptr ScrollBar
    lines*: ptr CodeLine
    font*: ptr Font
    lineCount*: cint
    focused*: cint
    moveScrollToFocusNextLayout*: bool
    content*: cstring
    contentBytes*: csize_t
    tabSize*: cint

  Gauge* {.bycopy.} = object
    e*: Element
    position*: cfloat

  Table* {.bycopy.} = object
    e*: Element
    vScroll*: ptr ScrollBar
    itemCount*: cint
    columns*: cstring
    columnWidths*: ptr cint
    columnCount*: cint
    columnHighlight*: cint

  Textbox* {.bycopy.} = object
    e*: Element
    string*: cstring
    bytes*: pointer # cint
    carets*: array[2, cint]
    scroll*: cint
    rejectNextKey*: bool

  Menu* {.bycopy.} = object
    e*: Element
    pointX*: cint
    pointY*: cint
    vScroll*: ptr ScrollBar

  Slider* {.bycopy.} = object
    e*: Element
    position*: cfloat
    steps*: cint

  ColorPicker* {.bycopy.} = object
    e*: Element
    hue*: cfloat
    saturation*: cfloat
    value*: cfloat
    opacity*: cfloat

  MDIClient* {.bycopy.} = object
    e*: Element
    active*: ptr MDIChild
    cascade*: cint

  MDIChild* {.bycopy.} = object
    e*: Element
    bounds*: Rectangle
    title*: cstring
    titleBytes*: pointer # cint
    dragHitTest*: cint
    dragOffset*: Rectangle
    previous*: ptr MDIChild

  ExpandPane* {.bycopy.} = object
    e*: Element
    button*: ptr Button
    panel*: ptr Panel
    expanded*: bool

  ImageDisplay* {.bycopy.} = object
    e*: Element
    bits*: ptr uint32
    width*: cint
    height*: cint
    panX*: cfloat
    panY*: cfloat
    zoom*: cfloat
    ##  Internals:
    previousWidth*: cint
    previousHeight*: cint
    previousPanPointX*: cint
    previousPanPointY*: cint

  WrapPanel* {.bycopy.} = object
    e*: Element

  UI* {.bycopy.} = object
    windows*: ptr Window
    animating*: ptr Element
    theme*: Theme
    parentStack*: array[16, ptr Element]
    parentStackCount*: cint
    quit*: bool
    dialogResult*: cstring
    dialogOldFocus*: ptr Element
    activeFont*: ptr Font
    when defined(lDebug):
      inspector*: ptr Window
      inspectorTable*: ptr Table
      inspectorTarget*: ptr Window
      inspectorLog*: ptr Code
    when defined(lFreetype):
      ft*: FT_Library


var ui* {.importc: "ui".}: UI

const castInt* = cast[pointer](-1)

proc initialise*() {.cdecl, importc: "UIInitialise".}
proc messageLoop*(): cint {.cdecl, importc: "UIMessageLoop".}
proc elementCreate*(bytes: csize_t; parent: ptr Element; flags: uint32 = 0; messageClass: proc (
    a1: ptr Element; a2: Message; a3: cint; a4: pointer): cint {.cdecl.};
                   cClassName: cstring): ptr Element {.cdecl,
    importc: "UIElementCreate".}
proc buttonCreate*(parent: ptr Element; flags: uint32 = 0; label: cstring;
                  labelBytes: pointer = castInt): ptr Button {.cdecl,
    importc: "UIButtonCreate".} # cint
proc checkboxCreate*(parent: ptr Element; flags: uint32 = 0; label: cstring;
                    labelBytes: pointer = castInt): ptr Checkbox {.cdecl,
    importc: "UICheckboxCreate".} # cint
proc colorPickerCreate*(parent: ptr Element; flags: uint32 = 0): ptr ColorPicker {.cdecl,
    importc: "UIColorPickerCreate".}
proc expandPaneCreate*(parent: ptr Element; flags: uint32 = 0; label: cstring;
                      labelBytes: pointer = castInt; panelFlags: uint32 = 0): ptr ExpandPane {.
    cdecl, importc: "UIExpandPaneCreate".} # labelBytes: cint
proc gaugeCreate*(parent: ptr Element; flags: uint32 = 0): ptr Gauge {.cdecl,
    importc: "UIGaugeCreate".}
proc mdiClientCreate*(parent: ptr Element; flags: uint32 = 0): ptr MDIClient {.cdecl,
    importc: "UIMDIClientCreate".}
proc mdiChildCreate*(parent: ptr Element; flags: uint32 = 0; initialBounds: Rectangle;
                    title: cstring; titleBytes: pointer = castInt): ptr MDIChild {.cdecl,
    importc: "UIMDIChildCreate".} # cint
proc panelCreate*(parent: ptr Element; flags: uint32 = 0): ptr Panel {.cdecl,
    importc: "UIPanelCreate".}
proc scrollBarCreate*(parent: ptr Element; flags: uint32 = 0): ptr ScrollBar {.cdecl,
    importc: "UIScrollBarCreate".}
proc sliderCreate*(parent: ptr Element; flags: uint32 = 0): ptr Slider {.cdecl,
    importc: "UISliderCreate".}
proc spacerCreate*(parent: ptr Element; flags: uint32 = 0; width: cint; height: cint): ptr Spacer {.
    cdecl, importc: "UISpacerCreate".}
proc splitPaneCreate*(parent: ptr Element; flags: uint32 = 0; weight: cfloat): ptr SplitPane {.
    cdecl, importc: "UISplitPaneCreate".}
proc tabPaneCreate*(parent: ptr Element; flags: uint32 = 0; tabs: cstring): ptr TabPane {.
    cdecl, importc: "UITabPaneCreate".}
  ##  separate with \t, terminate with \0
proc wrapPanelCreate*(parent: ptr Element; flags: uint32 = 0): ptr WrapPanel {.cdecl,
    importc: "UIWrapPanelCreate".}
proc labelCreate*(parent: ptr Element; flags: uint32 = 0; label: cstring;
                 labelBytes: pointer = castInt): ptr Label {.cdecl, importc: "UILabelCreate".} # ptrdiff_r
proc labelSetContent*(code: ptr Label; content: cstring; byteCount: pointer = castInt) {.cdecl,
    importc: "UILabelSetContent".} # cint
proc imageDisplayCreate*(parent: ptr Element; flags: uint32 = 0; bits: ptr uint32;
                        width: csize_t; height: csize_t; stride: csize_t): ptr ImageDisplay {.
    cdecl, importc: "UIImageDisplayCreate".}
proc imageDisplaySetContent*(display: ptr ImageDisplay; bits: ptr uint32;
                            width: csize_t; height: csize_t; stride: csize_t) {.cdecl,
    importc: "UIImageDisplaySetContent".}
proc windowCreate*(owner: ptr Window; flags: uint32 = 0; cTitle: cstring; width: cint = 0;
                  height: cint = 0): ptr Window {.cdecl, importc: "UIWindowCreate".}
proc windowRegisterShortcut*(window: ptr Window; shortcut: Shortcut) {.cdecl,
    importc: "UIWindowRegisterShortcut".}
proc windowPostMessage*(window: ptr Window; message: Message; dp: pointer) {.cdecl,
    importc: "UIWindowPostMessage".}
##  Thread-safe.

proc windowPack*(window: ptr Window; width: cint) {.cdecl, importc: "UIWindowPack".}
##  Change the size of the window to best match its contents.

type
  DialogUserCallback* = proc (a1: ptr Element) {.cdecl.}

proc dialogShow*(window: ptr Window; flags: uint32 = 0; format: cstring): cstring {.
    varargs, cdecl, importc: "UIDialogShow".}
proc menuCreate*(parent: ptr Element; flags: uint32 = 0): ptr Menu {.cdecl,
    importc: "UIMenuCreate".}
proc menuAddItem*(menu: ptr Menu; flags: uint32 = 0; label: cstring;
                 labelBytes: pointer = castInt; invoke: proc (cp: pointer) {.cdecl.};
                 cp: pointer = nil) {.cdecl, importc: "UIMenuAddItem".}
proc menuShow*(menu: ptr Menu) {.cdecl, importc: "UIMenuShow".}
proc textboxCreate*(parent: ptr Element; flags: uint32 = 0): ptr Textbox {.cdecl,
    importc: "UITextboxCreate".}
proc textboxReplace*(textbox: ptr Textbox; text: cstring; bytes: pointer = castInt;
                    sendChangedMessage: bool) {.cdecl, importc: "UITextboxReplace".}
proc textboxClear*(textbox: ptr Textbox; sendChangedMessage: bool) {.cdecl,
    importc: "UITextboxClear".}
proc textboxMoveCaret*(textbox: ptr Textbox; backward: bool; word: bool) {.cdecl,
    importc: "UITextboxMoveCaret".}
proc tableCreate*(parent: ptr Element; flags: uint32 = 0; columns: cstring): ptr Table {.
    cdecl, importc: "UITableCreate".}
proc tableHitTest*(table: ptr Table; x: cint; y: cint): cint {.cdecl,
    importc: "UITableHitTest".}
##  Returns item index. Returns -1 if not on an item.

proc tableHeaderHitTest*(table: ptr Table; x: cint; y: cint): cint {.cdecl,
    importc: "UITableHeaderHitTest".}
##  Returns column index or -1.

proc tableEnsureVisible*(table: ptr Table; index: cint): bool {.cdecl,
    importc: "UITableEnsureVisible".}
##  Returns false if the item was already visible.

proc tableResizeColumns*(table: ptr Table) {.cdecl, importc: "UITableResizeColumns".}
proc codeCreate*(parent: ptr Element; flags: uint32 = 0): ptr Code {.cdecl,
    importc: "UICodeCreate".}
proc codeFocusLine*(code: ptr Code; index: cint) {.cdecl, importc: "UICodeFocusLine".}
##  Line numbers are 1-indexed!!

proc codeHitTest*(code: ptr Code; x: cint; y: cint): cint {.cdecl,
    importc: "UICodeHitTest".}
##  Returns line number; negates if in margin. Returns 0 if not on a line.

proc codeInsertContent*(code: ptr Code; content: cstring; byteCount: pointer = castInt;
                       replace: bool) {.cdecl, importc: "UICodeInsertContent".}
proc drawBlock*(painter: ptr Painter; rectangle: Rectangle; color: uint32) {.cdecl,
    importc: "UIDrawBlock".}
proc drawInvert*(painter: ptr Painter; rectangle: Rectangle) {.cdecl,
    importc: "UIDrawInvert".}
proc drawLine*(painter: ptr Painter; x0: cint; y0: cint; x1: cint; y1: cint; color: uint32): bool {.
    cdecl, importc: "UIDrawLine".}
##  Returns false if the line was not visible.

proc drawTriangle*(painter: ptr Painter; x0: cint; y0: cint; x1: cint; y1: cint; x2: cint;
                  y2: cint; color: uint32) {.cdecl, importc: "UIDrawTriangle".}
proc drawTriangleOutline*(painter: ptr Painter; x0: cint; y0: cint; x1: cint; y1: cint;
                         x2: cint; y2: cint; color: uint32) {.cdecl,
    importc: "UIDrawTriangleOutline".}
proc drawGlyph*(painter: ptr Painter; x: cint; y: cint; c: cint; color: uint32) {.cdecl,
    importc: "UIDrawGlyph".}
proc drawRectangle*(painter: ptr Painter; r: Rectangle; mainColor: uint32;
                   borderColor: uint32; borderSize: Rectangle) {.cdecl,
    importc: "UIDrawRectangle".}
proc drawBorder*(painter: ptr Painter; r: Rectangle; borderColor: uint32;
                borderSize: Rectangle) {.cdecl, importc: "UIDrawBorder".}
proc drawString*(painter: ptr Painter; r: Rectangle; string: cstring; bytes: pointer = castInt;
                color: uint32; align: cint; selection: ptr StringSelection) {.cdecl,
    importc: "UIDrawString".}
proc drawStringHighlighted*(painter: ptr Painter; r: Rectangle; string: cstring;
                           bytes: pointer = castInt; tabSize: cint): cint {.cdecl,
    importc: "UIDrawStringHighlighted".}
proc measureStringWidth*(string: cstring; bytes: pointer = castInt): cint {.cdecl,
    importc: "UIMeasureStringWidth".}
proc measureStringHeight*(): cint {.cdecl, importc: "UIMeasureStringHeight".}
proc animateClock*(): uint64 {.cdecl, importc: "UIAnimateClock".}
##  In ms.

proc elementAnimate*(element: ptr Element; stop: bool): bool {.cdecl,
    importc: "UIElementAnimate".}
proc elementDestroy*(element: ptr Element) {.cdecl, importc: "UIElementDestroy".}
proc elementDestroyDescendents*(element: ptr Element) {.cdecl,
    importc: "UIElementDestroyDescendents".}
proc elementFindByPoint*(element: ptr Element; x: cint; y: cint): ptr Element {.cdecl,
    importc: "UIElementFindByPoint".}
proc elementFocus*(element: ptr Element) {.cdecl, importc: "UIElementFocus".}
proc elementScreenBounds*(element: ptr Element): Rectangle {.cdecl,
    importc: "UIElementScreenBounds".}
##  Returns bounds of element in same coordinate system as used by UIWindowCreate.

proc elementRefresh*(element: ptr Element) {.cdecl, importc: "UIElementRefresh".}
proc elementRepaint*(element: ptr Element; region: ptr Rectangle) {.cdecl,
    importc: "UIElementRepaint".}
proc elementMove*(element: ptr Element; bounds: Rectangle; alwaysLayout: bool) {.cdecl,
    importc: "UIElementMove".}
proc elementMessage*(element: ptr Element; message: Message; di: cint; dp: pointer): cint {.
    cdecl, importc: "UIElementMessage".}
proc elementChangeParent*(element: ptr Element; newParent: ptr Element;
                         insertBefore: ptr Element) {.cdecl,
    importc: "UIElementChangeParent".}
##  Set insertBefore to null to insert at the end.

proc parentPush*(element: ptr Element): ptr Element {.cdecl, importc: "UIParentPush".}
proc parentPop*(): ptr Element {.cdecl, importc: "UIParentPop".}
proc rectangleIntersection*(a: Rectangle; b: Rectangle): Rectangle {.cdecl,
    importc: "UIRectangleIntersection".}
proc rectangleBounding*(a: Rectangle; b: Rectangle): Rectangle {.cdecl,
    importc: "UIRectangleBounding".}
proc rectangleAdd*(a: Rectangle; b: Rectangle): Rectangle {.cdecl,
    importc: "UIRectangleAdd".}
proc rectangleTranslate*(a: Rectangle; b: Rectangle): Rectangle {.cdecl,
    importc: "UIRectangleTranslate".}
proc rectangleEquals*(a: Rectangle; b: Rectangle): bool {.cdecl,
    importc: "UIRectangleEquals".}
proc rectangleContains*(a: Rectangle; x: cint; y: cint): bool {.cdecl,
    importc: "UIRectangleContains".}
proc colorToHSV*(rgb: uint32; hue: ptr cfloat; saturation: ptr cfloat;
                value: ptr cfloat): bool {.cdecl, importc: "UIColorToHSV".}
proc colorToRGB*(hue: cfloat; saturation: cfloat; value: cfloat; rgb: ptr uint32) {.
    cdecl, importc: "UIColorToRGB".}
proc stringCopy*(`in`: cstring; inBytes: pointer = castInt): cstring {.cdecl,
    importc: "UIStringCopy".}
proc fontCreate*(cPath: cstring; size: uint32): ptr Font {.cdecl,
    importc: "UIFontCreate".}
proc fontActivate*(font: ptr Font): ptr Font {.cdecl, importc: "UIFontActivate".}
##  Returns the previously active font.

when defined(lDebug):
  proc InspectorLog*(cFormat: cstring) {.varargs, cdecl, importc: "UIInspectorLog".}

template KEYCODE_LETTER*(x: untyped): cint = cint(KEYCODE_A + int(x) - int'A')
template KEYCODE_DIGIT*(x: untyped): cint = cint(KEYCODE_0 + int(x) - int'0')
template KEYCODE_FKEY*(x: untyped): cint = cint(KEYCODE_F1 + int(x) - 1)

when defined(lFreetype):
  export freetype