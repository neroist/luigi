import luigi

initialise()

let window = windowCreate(nil, 0, "My First Application", 640, 480)
let panel = panelCreate(addr window.e, PANEL_GRAY or PANEL_MEDIUM_SPACING)

let
  button = buttonCreate(addr panel.e, 0, "Push")
  colorPicker = colorPickerCreate(addr panel.e)
  gauge = gaugeCreate(addr panel.e)
  slider = sliderCreate(addr panel.e)
  spacer = spacerCreate(addr panel.e, 0, 0, 20)
  label = labelCreate(addr panel.e, 0, "Label")
  textbox = textboxCreate(addr panel.e)

button.e.messageUser = proc(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgClicked:
    colorPicker.saturation = 0
    colorPicker.value = 1

    elementRefresh(addr colorPicker.e)

slider.e.messageUser = proc(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgValueChanged:
    gauge.position = slider.position

    elementRefresh(addr gauge.e)

textbox.e.messageUser = proc(element: ptr Element, message: Message, di: cint, dp: pointer): cint {.cdecl.} =
  if message == msgValueChanged:
    labelSetContent(label, textbox.string, castInt)

    elementRefresh(addr label.e)
    elementRefresh(label.e.parent)

quit messageLoop()
