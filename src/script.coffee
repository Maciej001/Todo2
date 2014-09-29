# TodoApp is a function. This is why when initializing app variable we call the function
# @ - means this
class TodoApp
  constructor: ->
    @bindEvents()

  bindEvents: ->
    #hide message notifier
    $('#message').hide()
    $('#new-todo').on('keyup', @create)

  create: (e) ->
    $input = $(this)  # here $input points to #new-todo, it always points to element that triggered the event
    val = ( $.trim $input.val() ) # $.trim removes all the whitespaces

    return unless e.which == 13 && val

    #create random ID
    randomId = Math.floor Math.random()*999999

    #store object containing id, task and status if task has been completed
    localStorage.setObj randomId, 
    {
      id:         randomId
      title:      val
      completed:  false
    }

    #clear input field
    $input.val ''

    #display info for user that item has been added
    displayInfo('Item added to your list')


# Main App ------------------------

$ ->
  app = new TodoApp()

# ---------------------------------

#Let's create two functions that will let us store data in localStorage by extending the Storage
Storage::setObj = (key, obj) ->
  @setItem key, JSON.stringify( obj ) #use the localStorage setItem function 

Storage::getObj = (key) ->
  JSON.parse @getItem(key)

displayInfo = (msg) ->
  # show the information that object was created
  $('#message')
    .fadeIn('fast')
    .text(msg)
    .delay(2000)
    .fadeOut('slow')
