# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

  
class Creation
  constructor: (@id, @title, @status) ->
    

class CreationsList
  items: ko.observableArray([])
  loadData: ->
    this.showSpinner true
    self = this
    $.getJSON "/api/creations", (creations) ->
      vm.items.push(new Creation(data.id, data.title, 'supprimée')) for data in creations
      self.showSpinner false
      self.showTable   true
      
  showSpinner: ko.observable false
  showTable:   ko.observable false

vm = new CreationsList


vm.loadData()

ko.applyBindings vm
