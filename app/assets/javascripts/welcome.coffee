# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

  
class Creation
  constructor: (@lmid, @title, @state) ->
    @checked = ko.observable false
    @state   = ko.observable @state
    @lmid   = ko.observable @lmid
    
  published: ->
    return @state() == 'published'

  delete: ->
    console.log 'delete ' + @lmid()
    $.ajax
      url:'/api/creations/delete?lmid=' + @lmid() + '&title=' + @title
      success: ((response) ->
        toastr.success "" + response.msg, "Succès"
        @state('deleted')).bind(this)
      error: ((response) ->
        toastr.error "'" + response.title + "' n'est pas supprimé", "Echec"
        console.log "ajax fail ").bind(this)
      
  publish: ->
    console.log 'publish' + @lmid()
    $.ajax
      url:'/api/creations/publish?lmid=' + @lmid()
      success: ((response) ->
        toastr.success "" + response.msg, "Succès"
        @lmid(response.lmid)
        @state('published')).bind(this)
      error: ((response) ->
        toastr.error "'" + response.title + "' n'à pas été publiée", "Echec"
        console.log "ajax fail ").bind(this)

    
class CreationsList

  constructor: ->
    
    @checkAll = ko.observable false
    @items    = ko.observableArray([])
    @total    = ko.observable 0
    @showSpinner = ko.observable false
    @showTable   = ko.observable false

    @checkedItems = ko.observableArray([])
     
    @loadData = ->
      this.showSpinner true
      self = this
      $.getJSON "/api/creations", (creations) ->
        vm.items.push(new Creation(data.lmid, data.title, data.state)) for data in creations
        self.showSpinner false
        self.showTable   true
        $("button[data-toogle='tooltip']").tooltip({delay: { "show": 500, "hide": 100 }})
        self.total(self.items().length)



    @creaChecked = (crea) ->
      if crea.checked()
        vm.checkedItems.push { lmid: crea.lmid(), obj: crea }
      else
        vm.checkedItems.remove (e) ->
          return e.lmid == crea.lmid()
          # { lmid: crea.lmid(), obj: crea }
      return true
      
    @toogleCreations = (element, event) ->
      if vm.checkAll()
        e = $(event.currentTarget).next()
        e.removeClass('label-danger')
        e.addClass('label-success')
        e.text('Aucun')
      else
        e = $(event.currentTarget).next()
        e.removeClass('label-success')
        e.addClass('label-danger')
        e.text('Tous')

      for data in this.items()
        data.checked(this.checkAll())
      return true

    @currentCreation = ko.observable ""

    @publishSelected = ->
      lmids = []
      @checkedItems().forEach (e) ->
        crea = e.obj
        if crea.state() != 'published'
          crea.publish()
          lmids.push e.lmid
        
      console.log 'publish selected ' + lmids
        
    @deleteSelected = ->
      lmids = []
      @checkedItems().forEach (e) ->
        crea = e.obj
        if crea.state() != 'deleted'
          crea.delete()
          lmids.push e.lmid
      console.log 'delete selected ' + lmids
      

vm = new CreationsList


vm.loadData()

ko.applyBindings vm

