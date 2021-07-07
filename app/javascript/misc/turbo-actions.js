// https://jpscaletti.com/p/5/adding-custom-actions-to-hotwire-turbo-streams

const ExtraActions = {
  addclass: function (target, content) {
    target.classList.add(content)
  },

  removeclass: function (target, content) {
    target.classList.remove(content)
  }
}

document.addEventListener(
  "turbo:before-stream-render",
  function (event) {
    const stream = event.target
    const actionFunction = ExtraActions[stream.action]
    if (!actionFunction) {
      return  // A built-in action, ignore
    }
    const target = getTarget(stream)
    const content = getContent(stream)
    actionFunction(target, content)
    event.preventDefault()
  }
)

function getTarget (stream) {
  if (stream.target) {
    return stream.ownerDocument?.getElementById(stream.target)
  }
  throw "target attribute is missing"
}

function getContent (stream) {
  // Quick and dirty method to extract the content of the
  // <template> tag.
  return stream.innerHTML.trim().slice(10, -11).trim()
}
