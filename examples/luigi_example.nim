import std/strutils
import std/colors

import luigi

# TODO find a way so i dont have to import this, i really dont like using this
proc snprintf*(s: cstring, maxlen: csize_t, format: cstring): cint {.importc,
    header: "<stdio.h>", varargs.}

const
  themeItems = [ 
    "panel1",
    "panel2",
    "selected",
    "border",
    "text",
    "textDisabled",
    "textSelected",
    "buttonNormal",
    "buttonHovered",
    "buttonPressed",
    "buttonDisabled",
    "textboxNormal",
    "textboxFocused",
    "codeFocused",
    "codeBackground",
    "codeDefault",
    "codeComment",
    "codeString",
    "codeNumber",
    "codeOperator",
    "codePreprocessor",
  ]

var
  window: ptr Window
  testWindow: ptr Window
  label: ptr Label

  themeEditorColorPicker: ptr ColorPicker
  themeEditorTable: ptr Table

  slider: ptr Slider
  gauge: ptr Gauge

  code: ptr Code

  themeEditorSelectedColor: int = -1
  selected: int

template getValOfTheme(idx: int): uint32 = 
  case idx
  of 0: ui.theme.panel1
  of 1: ui.theme.panel2
  of 2: ui.theme.selected
  of 3: ui.theme.border
  of 4: ui.theme.text
  of 5: ui.theme.textDisabled
  of 6: ui.theme.textSelected
  of 7: ui.theme.buttonNormal
  of 8: ui.theme.buttonHovered
  of 9: ui.theme.buttonPressed
  of 10: ui.theme.buttonDisabled
  of 11: ui.theme.textboxNormal
  of 12: ui.theme.textboxFocused
  of 13: ui.theme.codeFocused
  of 14: ui.theme.codeBackground
  of 15: ui.theme.codeDefault
  of 16: ui.theme.codeComment
  of 17: ui.theme.codeString
  of 18: ui.theme.codeNumber
  of 19: ui.theme.codeOperator
  of 20: ui.theme.codePreprocessor
  else: 0

proc teTableMessage(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgTableGetItem:
    var m = cast[ptr TableGetItem](dp)
    m.isSelected = themeEditorSelectedColor == m.index

    if m.column == 0:
      return snprintf(m.buffer, m.bufferBytes, cstring themeItems[m.index])
    else:
      return snprintf(m.buffer, m.bufferBytes, cstring $Color(int getValOfTheme(m.index)))
  elif message == msgLeftDown:
    themeEditorSelectedColor = tableHitTest(cast[ptr Table](element), element.window.cursorX, element.window.cursorY)

    colorToHSV(
      getValOfTheme(themeEditorSelectedColor),
      addr themeEditorColorPicker.hue,
      addr themeEditorColorPicker.saturation,
      addr themeEditorColorPicker.value
    )

    elementRepaint(addr themeEditorColorPicker.e)

proc teColorPickerMessage(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgValueChanged:
    if themeEditorSelectedColor == -1: return

    colorToRGB(themeEditorColorPicker.hue, themeEditorColorPicker.saturation, themeEditorColorPicker.value):
      case themeEditorSelectedColor
      of 0: addr ui.theme.panel1
      of 1: addr ui.theme.panel2
      of 2: addr ui.theme.selected
      of 3: addr ui.theme.border
      of 4: addr ui.theme.text
      of 5: addr ui.theme.textDisabled
      of 6: addr ui.theme.textSelected
      of 7: addr ui.theme.buttonNormal
      of 8: addr ui.theme.buttonHovered
      of 9: addr ui.theme.buttonPressed
      of 10: addr ui.theme.buttonDisabled
      of 11: addr ui.theme.textboxNormal
      of 12: addr ui.theme.textboxFocused
      of 13: addr ui.theme.codeFocused
      of 14: addr ui.theme.codeBackground
      of 15: addr ui.theme.codeDefault
      of 16: addr ui.theme.codeComment
      of 17: addr ui.theme.codeString
      of 18: addr ui.theme.codeNumber
      of 19: addr ui.theme.codeOperator
      of 20: addr ui.theme.codePreprocessor
      else: addr ui.theme.panel1
    
    elementRepaint(addr window.e)
    elementRepaint(addr element.window.e)
    elementRepaint(addr testWindow.e)

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

proc sliderMessage(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgValueChanged:
    gauge.position = slider.position

    elementRepaint(addr gauge.e)

# NEW
proc codeMessage(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgMouseMove:
    let lineno = codeHitTest(code, element.window.cursorX, element.window.cursorY)

    codeFocusLine(code, lineno)
    elementRepaint(element)

proc winMessage(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgWindowDropFiles:
    var paths: seq[cstring]

    # when message == msgWindowDropFiles, `dp` is an UncheckedArray of the file
    # paths, and `di` is the number of files.

    # we cast the pointer to an UncheckedArray and convert it to an openArray so
    # we can iterate over the contents
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

window = windowCreate(nil, 0, "Test Window")
window.e.messageUser = winMessage
testWindow = window

let
  # Split window (vertically) into top/bottom panes.
  split1 = splitPaneCreate(addr window.e, SPLIT_PANE_VERTICAL, 0.8)

  # Split top pane (horizontally) into left/right panes.
  split3 = splitPaneCreate(addr split1.e, 0, 0.3)

block:
  let panel = panelCreate(addr split3.e, PANEL_GRAY)
  panel.border.t = 5
  panel.gap = 5

  buttonCreate(addr panel.e, 0, "Hello").e.messageUser = btnMessage
  buttonCreate(addr panel.e, 0, "World").e.messageUser = btnMessage
  buttonCreate(addr panel.e, 0, "3").e.messageUser = btnMessage
  buttonCreate(addr panel.e, 0, "4").e.messageUser = btnMessage
  buttonCreate(addr panel.e, 0, "5").e.messageUser = btnMessage
  
  gauge = gaugeCreate(addr panel.e)
  gauge.position = 0.3

  slider = sliderCreate(addr panel.e)
  slider.e.messageUser = sliderMessage
  slider.position = 0.3

  discard textboxCreate(addr panel.e)

block:
  let buffer = static(staticRead("../src/luigi.nim"))
      .replace("\r", "") # leaving '\r' in there makes files look weird
  
  code = codeCreate(addr split3.e)
  code.e.messageUser = codeMessage

  codeInsertContent(code, cstring buffer, castInt, true)
  codeFocusLine(code, 0)

# Split bottom pane (horizontally) into left/right panes.
let split2 = splitPaneCreate(addr split1.e, 0, 0.3)

block:
  let panel = panelCreate(addr split2.e, PANEL_WHITE)
  panel.border = Rectangle(l: 5, r: 5, t: 5, b: 5)
  panel.gap = 5

  buttonCreate(addr panel.e, 0, "It's a button??").e.messageUser = btn2Message
  label = labelCreate(addr panel.e, ELEMENT_H_FILL, "Hello, I am a label!")

# idk why this isnt in a block
let tabPane = tabPaneCreate(addr split2.e, 0, "Tab 1\tMiddle Tab\tTab 3")

let table = tableCreate(addr tabPane.e, 0, "Column 1\tColumn 2")
table.itemCount = 10000
table.e.messageUser = tblMessage
tableResizeColumns(table)

discard labelCreate(addr panelCreate(addr tabPane.e, PANEL_GRAY).e, 0, "you're in tab 2, bucko")
discard labelCreate(addr panelCreate(addr tabPane.e, PANEL_GRAY).e, 0, "haiii !!!")

block:
  window = windowCreate(nil, 0, "Theme Editor")
  let pane = splitPaneCreate(addr window.e, 0, 0.5)

  themeEditorColorPicker = colorPickerCreate(addr panelCreate(addr pane.e, PANEL_GRAY).e)
  themeEditorColorPicker.e.messageUser = teColorPickerMessage

  themeEditorTable = tableCreate(addr pane.e, 0, "Item\tColor")
  themeEditorTable.itemCount = themeItems.len # / sizeof(themeItems[0])
  themeEditorTable.e.messageUser = teTableMessage
  tableResizeColumns(themeEditorTable)

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
  window = windowCreate(nil, 0, "MDI Example")

  let client = mdiClientCreate(addr window.e, 0)
  let child1 = mdiChildCreate(addr client.e, MDI_CHILD_CLOSE_BUTTON, Rectangle(l: 10, r: 600, t: 10, b: 400), "My Window")

  let panel1 = panelCreate(addr child1.e, PANEL_GRAY or PANEL_MEDIUM_SPACING)
  discard labelCreate(addr panel1.e, 0, "It's a christmas miracle")

  let child2 = mdiChildCreate(addr client.e, MDI_CHILD_CLOSE_BUTTON, Rectangle(l: 40, r: 630, t: 40, b: 430), "Second Window")

  let panel2 = panelCreate(addr child2.e, PANEL_GRAY or PANEL_MEDIUM_SPACING)
  discard labelCreate(addr panel2.e, 0, "the system is down")

  let child3 = mdiChildCreate(addr client.e, MDI_CHILD_CLOSE_BUTTON, Rectangle(l: 70, r: 670, t: 70, b: 470), "Third Window")
  discard buttonCreate(addr child3.e, 0, "giant button!!")

ui.theme.codePreprocessor = ui.theme.codeComment

echo "Tip: Try dragging a text file on the test window."

# wanna try out different fonts?
when defined(lFreetype):
  # looks similar but this is the undertale font !!!
  # pretty cool ngl :3
  # let determinationSans = fontCreate("./DeterminationSansWebRegular-369X.ttf", 14)
  # fontActivate(determinationSans)
  
  let robotoMono = fontCreate("./RobotoMono-VariableFont_wght.ttf", 11) 
  let firaCode = fontCreate("./FiraCode-Retina.ttf", 10)

  fontActivate(robotoMono)
  code.font = firaCode

quit messageLoop()
