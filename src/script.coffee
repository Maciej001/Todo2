# TodoApp is a function. This is why when initializing app variable we call the function
# @ - means this
class TodoApp
  constructor: ->
    @cacheElements()  # this method caches often used elements
    @bindEvents()

    # display items
    # funny enough defining the method and trying to execute @displayItems() didn't work
    # as if funciton didn't exist at all
    # that is bacause 'this' pointed to the #new-todo item instead of to TodoApp class itself
    # When binding events use (e) => function_name, that will ensure that within the function
    # 'this' will still point to the class
    @displayItems()

  cacheElements: ->
    @$input = $('#new-todo')  # @$input is a class variable that we can use later on 
    @$todoList = $('#todo-list') # where list items are to be displayed
    @$clearCompleted = $('#clear-completed')

  bindEvents: ->
    #hide message notifier. will be used later for displaying information
    $('#message').hide()

    # on every keypress the create method is called
    # using => (fat arrow) ensures that within the create method  'this' will still point to our class object 
    @$input.on( 'keyup', (e) => @create(e) )

    # binding destroy task event
    @$todoList.on( 'click', '.destroy', (e) => @destroy(e.target) )

    # checking element as completed
    @$todoList.on( 'change', '.toggle', (e) => @toggle(e.target) )

    # clear completed task
    @$clearCompleted.on( 'click', (e) => @clear(e.target) )

  create: (e) ->
    # here $input points to #new-todo, it always points to element that triggered the event
    # this, by using => was reserved for the class itself
    $input = $(e.target)  

    val = ( $.trim @$input.val() ) # $.trim removes all the whitespaces

    # if key != 'enter' exit
    return unless e.which == 13 && val

    # below part of the code will be executed only if 'enter' (13) is pressed

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

    @displayItems()

  displayItems: ->
    # first let's clear the list of items
    @clearItems()

    # cycle through all key, value pairs stored in localStorage
    @addItem(localStorage.getObj(id)) for id in Object.keys(localStorage)

  clearItems: ->
    @$todoList.empty()

  addItem: (item) ->
    # html = """
    #         <li #{if item.completed then 'class="completed"' else ''} data-id="#{item.id}">
    #           <div class="view">
    #             <input class="toggle" type="checkbox"  #{if item.completed then 'checked' else ''}>
    #             <label>#{item.title}</label>
    #             <button class="destroy">delete</button>
    #           </div>
    #         </li>
    #       """

    # where is my template
    var template = $('#itemTemplate');

    # compile your template
    var renderer = Handlebars.compile(template);
    var item = if item.completed then 'class="completed"' else ''
    var id = item.id
    var checked = if item.completed then 'checked' else ''
    var title = item.title

    var html = renderer({
        "completed" : item,
        "id"        : id,
        "checked"   : checked,
        "title"     : title,
      });

    # add item to #todoList      
    @$todoList.append(html)

  destroy: (element) ->
    # find element's id
    id = $(element).closest('li').data('id')

    # remove it from localStorage
    localStorage.removeItem( id )

    # redisplay items
    @displayItems()

    displayInfo('Item removed1c')

  toggle: (element) ->
    #find id
    id = $(element).closest('li').data('id')

    # load item
    item = localStorage.getObj(id)

    # toggle item completed status
    item.completed = !item.completed

    # save item back to local storage
    localStorage.setObj( id, item )

  # clear completed items
  clear: ->
    @removeItem(localStorage.getObj(id)) for id in Object.keys(localStorage) 

    # refresh displayed items
    @displayItems()

    # list cleared message
    displayInfo('Completed items cleared')

  removeItem: (item) ->
    localStorage.removeItem( item.id ) if item.completed

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
    .fadeOut('fast')
