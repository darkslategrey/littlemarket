# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

  
class Creation
  constructor: (@lm_id, @title, @state) ->
    @checked = ko.observable false

  delete: ->
    console.log 'delete ' + this.lm_id
    self = this
    $.getJSON '/api/creations/delete?id=' + this.lm_id, ->
      console.log "deleted this creationn. Others comming."
    #   self.state = 'deleted'
      
  publish: ->
    console.log 'publish' + this.lm_id
    self = this
    $.getJSON '/api/creations/publish?id=' + this.lm_id,  ->
      self.state = 'published'
      
      



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

