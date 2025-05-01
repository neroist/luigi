import std/strutils

import luigi/luigi2

# TODO find a way so i dont have to import this, i really dont like using this
proc snprintf*(s: cstring, maxlen: csize_t, format: cstring): cint {.importc,
    header: "<stdio.h>", varargs.}

var
  window: ptr Window
  label: ptr Label

  sliderHoriz: ptr Slider
  gaugeHoriz1: ptr Gauge
  gaugeHoriz2: ptr Gauge

  sliderVert: ptr Slider
  gaugeVert1: ptr Gauge
  gaugeVert2: ptr Gauge

  code: ptr Code

  selected: int

proc btnMessage(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgClicked:
    echo "Clicked!"

    elementDestroy(element)
    elementRefresh(element.parent)

proc menuCallback(cp: pointer) {.cdecl.} =
  labelSetContent(label, cast[cstring](cp))
  elementRefresh(addr label.e)

proc btn2Message(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgClicked:
    let menu = menuCreate(element)

    menuAddItem(menu, 0, "Item 1\tCtrl+F5", castInt, menuCallback, cast[pointer](cstring"Item 1 clicked!"))
    menuAddItem(menu, 0, "Item 2\tF6", castInt, menuCallback, cast[pointer](cstring"Item 2 clicked!"))
    menuShow(menu)

# NEW
proc codeMessage(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgMouseMove:
    let lineno = codeHitTest(code, element.window.cursorX, element.window.cursorY)

    codeFocusLine(code, lineno)

proc sliderHMessage(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgValueChanged:
    gaugeHoriz2.position = sliderHoriz.position
    gaugeVert1.position = sliderHoriz.position

    elementRepaint(addr gaugeHoriz2.e)
    elementRepaint(addr gaugeVert1.e)

proc sliderVMessage(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgValueChanged:
    gaugeVert2.position = sliderVert.position
    gaugeHoriz1.position = sliderVert.position

    elementRepaint(addr gaugeVert2.e)
    elementRepaint(addr gaugeHoriz1.e)

proc winMessage(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgWindowDropFiles:
    var paths: seq[cstring]

    # when message == msgWindowDropFiles, `dp` is an UncheckedArray of the file
    # paths, and `di` is the number of files.
    for path in cast[ptr UncheckedArray[cstring]](dp).toOpenArray(0, int di - 1):
      paths.add path

    codeInsertContent(code, cstring readFile($paths[^1]), castInt, true)

    elementRefresh(addr code.e)

proc tblMessage(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgTableGetItem:
    var m = cast[ptr TableGetItem](dp)
    m.isSelected = selected == m.index

    if m.column == 0:
      return snprintf(m.buffer, m.bufferBytes, cstring "Item " & $m.index)
    else:
      return snprintf(m.buffer, m.bufferBytes, cstring "other column " & $m.index)
  elif message == msgLeftDown:
    let hit = tableHitTest(cast[ptr Table](element), element.window.cursorX, element.window.cursorY)

    if selected != hit:
      selected = hit

      if not tableEnsureVisible(cast[ptr Table](element), cint selected):
        elementRepaint(element)

initialise()

window = windowCreate(nil, 0, "luigi2 - Example Application")
window.e.messageUser = winMessage

let
  # Split window (vertically) into top/bottom panes.
  splitTopBottom = splitPaneCreate(addr window.e, SPLIT_PANE_VERTICAL, 0.75)

  # Split top pane (horizontally) into left/right panes.
  splitTopLeftright = splitPaneCreate(addr splitTopBottom.e, 0, 0.3)

block:
  # In the top-left pane - create a single panel taking up the whole pane.
  let panel = panelCreate(addr splitTopLeftright.e, PANEL_COLOR_1 or PANEL_MEDIUM_SPACING)

  # Panels are by default vertical in layout, so items start at top and go down.
  buttonCreate(addr panel.e, 0, "Hello World").e.messageUser = btnMessage

  # Create a new horizontal-layout "sub-panel" and put left and right panels inside it.
  let subpanel = panelCreate(addr panel.e, PANEL_COLOR_1 or PANEL_HORIZONTAL)

  # The left side will layout elements horizontally, with custom borders and gap.
  let subLeft = panelCreate(addr subpanel.e, PANEL_COLOR_1 or PANEL_HORIZONTAL)
  subLeft.border.t = 10
  subLeft.border.b = 10
  subLeft.border.l = 10
  subLeft.border.r = 10
  subLeft.gap = 2

  gaugeVert1 = gaugeCreate(addr subLeft.e, GAUGE_VERTICAL)
  gaugeVert2 = gaugeCreate(addr subLeft.e, GAUGE_VERTICAL)

  sliderVert = sliderCreate(addr subLeft.e, SLIDER_VERTICAL)
  sliderVert.e.messageUser = sliderVMessage

  # The right side will lay out elements vertically (the default), with default medium spacing.
  let subRight = panelCreate(addr subpanel.e, PANEL_COLOR_1 or PANEL_MEDIUM_SPACING)

  buttonCreate(addr subRight.e, 0, "1").e.messageUser = btnMessage
  buttonCreate(addr subRight.e, 0, "2").e.messageUser = btnMessage
  buttonCreate(addr subRight.e, 0, "3").e.messageUser = btnMessage
  buttonCreate(addr subRight.e, 0, "4").e.messageUser = btnMessage
  buttonCreate(addr subRight.e, 0, "5").e.messageUser = btnMessage

  # Back outside of the "sub-panel", we continue layout downwards.
  buttonCreate(addr panel.e, 0, "Goodbye World").e.messageUser = btnMessage

  gaugeHoriz1 = gaugeCreate(addr panel.e)
  gaugeHoriz2 = gaugeCreate(addr panel.e)

  sliderHoriz = sliderCreate(addr panel.e)
  sliderHoriz.e.messageUser = sliderHMessage

  discard textboxCreate(addr panel.e)
  discard textboxCreate(addr panel.e, TEXTBOX_HIDE_CHARACTERS)

  # Set default slider positions.
  sliderSetPosition(sliderVert, 0.1, true)
  sliderSetPosition(sliderHoriz, 0.3, true)

block:
  # Top-Right pane.

  let buffer = static(staticRead("../src/luigi/luigi2.nim"))
      .replace("\r", "") # leaving '\r' in there makes files look weird

  code = codeCreate(addr splitTopLeftright.e)
  code.e.messageUser = codeMessage

  codeInsertContent(code, cstring buffer, castInt, false)
  codeFocusLine(code, 0)

# Split bottom pane (horizontally) into left/right panes.
let splitBottomLeftright = splitPaneCreate(addr splitTopBottom.e, 0, 0.3)

block:
  # Bottom-Left pane.

  let panel = panelCreate(addr splitBottomLeftright.e, PANEL_COLOR_2)
  panel.border = Rectangle(l: 5, r: 5, t: 5, b: 5)
  panel.gap = 5

  buttonCreate(addr panel.e, 0, "It's a button??").e.messageUser = btn2Message
  label = labelCreate(addr panel.e, ELEMENT_H_FILL, "Hello, I am a label!")

block:
  # Bottom-Right pane

  let tabPane = tabPaneCreate(addr splitBottomLeftright.e, 0, "Tab 1\tMiddle Tab\tTab 3")

  let table = tableCreate(addr tabPane.e, 0, "Column 1\tColumn 2")
  table.itemCount = 10000
  table.e.messageUser = tblMessage
  tableResizeColumns(table)

  discard labelCreate(addr panelCreate(addr tabPane.e, PANEL_COLOR_1).e, 0, "you're in tab 2, bucko")
  discard labelCreate(addr panelCreate(addr tabPane.e, PANEL_COLOR_1).e, 0, "haiii !!!")

# windowRegisterShortcut(window):
#   Shortcut(
#     code: KEYCODE_LETTER('T'),
#     ctrl: true,
#     shift: false,
#     alt: false,
#     invoke: menuCallback,
#     cp: cast[pointer](cstring "Keyboard shortcut!")
#   )

block:
  # Create a separate window demonstrating the MDI element
  window = windowCreate(nil, 0, "luigi 2 - MDI Example")

  let client = mdiClientCreate(addr window.e, 0)
  let child1 = mdiChildCreate(addr client.e, MDI_CHILD_CLOSE_BUTTON, Rectangle(l: 10, r: 600, t: 10, b: 400), "My Window")

  let panel1 = panelCreate(addr child1.e, PANEL_COLOR_1 or PANEL_MEDIUM_SPACING)
  discard labelCreate(addr panel1.e, 0, "It's a christmas miracle")

  let child2 = mdiChildCreate(addr client.e, MDI_CHILD_CLOSE_BUTTON, Rectangle(l: 40, r: 630, t: 40, b: 430), "Second Window")

  let panel2 = panelCreate(addr child2.e, PANEL_COLOR_1 or PANEL_MEDIUM_SPACING)
  discard labelCreate(addr panel2.e, 0, "the system is down")

  let child3 = mdiChildCreate(addr client.e, MDI_CHILD_CLOSE_BUTTON, Rectangle(l: 70, r: 670, t: 70, b: 470), "Third Window")
  discard buttonCreate(addr child3.e, 0, "giant button!!")

echo "Tip: Try dragging a text file on the test window."

# wanna try out different fonts?
when defined(lFreetype):
  let robotoMono = fontCreate("./RobotoMono-VariableFont_wght.ttf", 11) 
  let firaCode = fontCreate("./FiraCode-Retina.ttf", 10)

  fontActivate(robotoMono)
  code.font = firaCode

quit messageLoop()
