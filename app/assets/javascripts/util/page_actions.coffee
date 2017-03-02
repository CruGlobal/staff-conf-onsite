alreadyFired = false
registry = []

window.pageAction = (args...) ->
  len = args.length
  func = args[len - 1]
  classes = args[0..(len - 2)]

  throw 'last argument must be a function' if typeof(func) != 'function'

  if alreadyFired
    fire(func, classes)
  else
    registry.push(func: func, classes: classes)

fire = (func, classes) ->
  $body = $(document.body)
  for cl in classes
    return false unless $body.hasClass(cl)
  func($)

$ ->
  alreadyFired = true
  fire(r.func, r.classes) for r in registry
