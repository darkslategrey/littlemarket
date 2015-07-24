# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

  
class Creation
  constructor: (@lm_id, @title, @state) ->
    @checked = ko.observable false
    @state   = ko.observable @state
    
  published: ->
    return @state() == 'published'

  delete: ->
    console.log 'delete ' + this.lm_id
    @state('deleted')
    ajax_call = $.ajax('/api/creations/delete?id=' + @lm_id)
    ajax_call.done @ajax_done
    ajax_call.fail @ajax_fail

  ajax_done: (response) ->
    console.log "ajax done"

  ajax_fail: (response) ->
    err = ko.toJS(response)

    noty
      text: 'Echec: ' + err.responseJSON.error
      layout: 'top'
      theme: 'relax'

      type: 'error'
      maxVisible: 1
      timeout: 1
      closeWith: ['click', 'hover', 'backdrop']
      dismissQueue: false
      animation: 
          open: 'animated bounceInLeft', # Animate.css class names
          close: 'animated bounceOutLeft', # Animate.css class names
          easing: 'swing', # unavailable - no need
          speed: 500 # unavailable - no need


    console.log "ajax fail " + err['status']
      
  publish: ->
    console.log 'publish' + this.lm_id
    @state('published')
    
class CreationsList

  constructor: ->
    
    @checkAll = ko.observable false
    @items    = ko.observableArray([])
    @loadData = ->
      this.showSpinner true
      self = this
      $.getJSON "/api/creations", (creations) ->
        vm.items.push(new Creation(data.lm_id, data.title, data.state)) for data in creations
        self.showSpinner false
        self.showTable   true
        $("button[data-toogle='tooltip']").tooltip({delay: { "show": 500, "hide": 100 }})
        
    @toogleCreations = ->
      for data in this.items()
        data.checked(this.checkAll())
      return true
    
    @showSpinner = ko.observable false
    @showTable   = ko.observable false

    @publishSelected = ->
      console.log 'publish selected'

    @currentCreation = ko.observable ""
    
    @deleteSelected = ->
      selected = []
      for data in @items()
        if data.checked() == true        
          console.log "selected " + data.lm_id
          self = this
          @currentCreation(data)
          success = (response) ->
            console.log "response " + ko.toJSON(response)
            @currentCreation().checked false
            @currentCreation().state 'deleted'
            
          $.getJSON "/api/creations/delete?lm_id=#{data.lm_id}", success

vm = new CreationsList


vm.loadData()

ko.applyBindings vm

