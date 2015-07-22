# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

  
class Creation
  constructor: (@id, @title) ->
    @checked = ko.observable false

class CreationsList
  checkAll: ko.observable false
  items: ko.observableArray([])
  loadData: ->
    this.showSpinner true
    self = this
    $.getJSON "/api/creations", (creations) ->
      vm.items.push(new Creation(data.id, data.title)) for data in creations
      self.showSpinner false
      self.showTable   true
  toogleCreations: ->
    for data in this.items()
      console.log data.id + " avant " + data.checked()
      data.checked(this.checkAll())
      console.log data.id + " apres " + data.checked()
    return true
    
  showSpinner: ko.observable false
  showTable:   ko.observable false

vm = new CreationsList


vm.loadData()

ko.applyBindings vm
