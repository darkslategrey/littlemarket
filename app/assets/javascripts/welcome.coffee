# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

  
class Creation
  constructor: (@id, @title) ->
    @checked = ko.observable false

  delete: ->
    console.log 'delete ' + this.id

  publish: ->
    console.log 'publish ' + this.id



class CreationsList

  constructor: ->
    
    @checkAll = ko.observable false
    @items    = ko.observableArray([])
    @loadData = ->
      this.showSpinner true
      self = this
      $.getJSON "/api/creations", (creations) ->
        vm.items.push(new Creation(data.id, data.title)) for data in creations
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

    @deleteSelected = ->
      selected = []
      for data in @items()
        selected.push data.id if data.checked() == true
      console.log "selected " + selected



vm = new CreationsList


vm.loadData()

ko.applyBindings vm

