alreadyFired = false
registry = []

# NOTE: 'form' is a special action which will match against either 'create' or
# 'new'
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
  return false unless bodyMatch(cl) for cl in classes
  func($)

bodyMatch = (cl) ->
  if cl == 'form'
    bodyMatch('create') || bodyMatch('new')
  else
    $(document.body).hasClass(cl)


$ ->
  alreadyFired = true
  fire(r.func, r.classes) for r in registry
