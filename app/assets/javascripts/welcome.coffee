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
    
    @loadData = ->
      this.showSpinner true
      self = this
      $.getJSON "/api/creations", (creations) ->
        vm.items.push(new Creation(data.lmid, data.title, data.state)) for data in creations
        self.showSpinner false
        self.showTable   true
        $("button[data-toogle='tooltip']").tooltip({delay: { "show": 500, "hide": 100 }})
        self.total(self.items().length)
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
          console.log "selected " + data.lmid
          self = this
          @currentCreation(data)
          success = (response) ->
            console.log "response " + ko.toJSON(response)
            @currentCreation().checked false
            @currentCreation().state 'deleted'
            
          $.getJSON "/api/creations/delete?lmid=#{data.lmid}", success

vm = new CreationsList


vm.loadData()

ko.applyBindings vm

