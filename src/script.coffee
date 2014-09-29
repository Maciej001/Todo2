# TodoApp is a function. This is why when initializing app variable we call the function
# @ - means this
class TodoApp
  constructor: ->
    @cacheElements()  # this method caches often used elements
    @bindEvents()

  cacheElements: ->
    @$input = $('#new-todo')  # @$input is a class variable that we can use later on 
    @$todoList = $('#todo-list') # where list items are to be displayed

  bindEvents: ->
    #hide message notifier
    $('#message').hide()

    # on every keypress the create method is called
    # using => (fat arrow) ensures that within the create method  this will still point to our class object 
    @$input.on( 'keyup', (e) => @create(e) )

  create: (e) ->
    # here $input points to #new-todo, it always points to element that triggered the event
    # this, by using => was reserved for the class itself
    $input = $(e.target)  

    val = ( $.trim @$input.val() ) # $.trim removes all the whitespaces

    return unless e.which == 13 && val

    # below part of the code will be executed only if enter (13) is pressed

    # create random ID
    randomId = Math.floor Math.random()*999999

    # store object containing id, task and status if task has been completed
    # in local storage
    localStorage.setObj randomId, 
    {
      id:         randomId
      title:      val
      completed:  false
    }

    #clear input field
    @$input.val ''

    #display info for user that item has been added
    displayInfo('Item added to your list')

    # display items
    # funny enough defining the method and trying to execute @displayItems() didn't work
    # as if funciton didn't exist at all
    # that is bacause this now points to the #new-todo item instead of to class TodoApp itself
    # to avoid this when binding events use (e) => function, that will ensure that within the function
    # this will still point to the class
    @displayItems()

  displayItems: ->
    # first let's clear the list of items
    @clearItems()
    console.log('items cleared')
    @addItem(localStorage.getObj(id)) for id in Object.keys(localStorage)

  clearItems: ->
    @$todoList.empty()

  addItem: (item) ->
    html = """
            <li #{if item.completed then 'class="completed"' else ''} data-id="#{item.id}">
              <div id="view">
                <input class="toggle" type="checkbox"  #{if item.completed then 'checked' else ''}>
                <label>#{item.title}</label>
                <button class="destroy">delete</button>
              </div>
            </li>
          """
    console.log("inside addItem : " + html)
    @$todoList.append(html)


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
