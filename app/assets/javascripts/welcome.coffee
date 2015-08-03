# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

toastr.options = 
  "closeButton": false
  "debug": false
  "newestOnTop": false
  "progressBar": true
  "positionClass": "toast-bottom-center"
  "preventDuplicates": false
  "onclick": null
  "showDuration": "800"
  "hideDuration": "800"
  "timeOut": "1000"
  "extendedTimeOut": "1000"
  "showEasing": "swing"
  "hideEasing": "linear"
  "showMethod": "fadeIn"
  "hideMethod": "fadeOut"

  
class Creation
  constructor: (@lmid, @title, @state, @vm) ->
    @checked    = ko.observable false
    @state      = ko.observable @state
    @lmid       = ko.observable @lmid
    @processing = ko.observable ''
    @self       = this
    
  published: ->
    return @state() == 'published'


  deleteItem: ->
    @self.processing 'danger'
    url      = '/api/creations/delete?lmid=' + @lmid() + '&title=' + @title
    newState = 'deleted'
    errorMsg = "' n'est pas supprimé"

    $.when(@doAjax(url, newState, errorMsg)).done (->
      @processing('')).bind(this)

  publishItem: ->
    @self.processing 'success'
    console.log 'publish ' + @lmid()
    url      = '/api/creations/publish?lmid=' + @lmid()
    newState = 'published'
    errorMsg = "' n'a pas été publiée"

    $.when(@doAjax(url, newState, errorMsg)).done (->
      @processing('')).bind(this)
    
  delete: ->
    console.log 'delete ' + @lmid()
    url      = '/api/creations/delete?lmid=' + @lmid() + '&title=' + @title
    newState = 'deleted'
    errorMsg = "' n'est pas supprimé"

    $.when(@doAjax(url, newState, errorMsg)).done(console.log('done!!'))

  publish: ->
    console.log 'publish ' + @lmid()
    url      = '/api/creations/publish?lmid=' + @lmid()
    newState = 'published'
    errorMsg = "' n'a pas été publiée"

    $.when(@doAjax(url, newState, errorMsg)).done(console.log('done!!!'))
    
  doAjax: (url, newState, errorMsg) ->
    return $.ajax
      url: url
      success: ((response) ->
        toastr.success "" + response.msg, "Succès"
        if url.match('publish')
          @lmid(response.lmid)
        @state(newState)).bind(this)
      error: ((response) ->
        toastr.error "'" + response.title + errorMsg, "Echec"
        @processing ''
        console.log "ajax fail ").bind(this)
        
            
class CreationsList

  constructor: ->
    
    @checkAll = ko.observable false
    @items    = ko.observableArray([])
    @total    = ko.observable 0
    @showSpinner = ko.observable false
    @showTable   = ko.observable false
    @spinnerText = ko.observable ''
    @checkedItems = ko.observableArray([])
     
    @loadData = ->
      this.spinnerText 'Chargement de vos creations...'
      this.showSpinner true
      self = this
      $.getJSON "/api/creations", (creations) ->
        vm.items.push(new Creation(data.lmid, data.title, data.state, vm)) for data in creations
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
        for data in vm.items()
          data.checked(vm.checkAll())
          vm.checkedItems.push { lmid: data.lmid(), obj: data }          
      else
        e = $(event.currentTarget).next()
        e.removeClass('label-success')
        e.addClass('label-danger')
        e.text('Tous')
        for data in vm.items()
          data.checked(vm.checkAll())
          vm.checkedItems.remove (e) ->
            return e.lmid == data.lmid()

      return true

    @currentCreation = ko.observable ""

    @publishSelected = ->
      @showSpinner true
      @spinnerText 'Opération en cours...'
      $.when(@publishItems()).done ->
        vm.showSpinner false        


    @publishItems = ->
      # @lmids = []
      @checkedItems().forEach (e) ->
        crea = e.obj
        if crea.state() != 'published'
          # crea.processing('success')
          crea.publishItem()
          # $.when(crea.publish()).done(console.log('done!!!'))
        
    @deleteSelected = ->
      @showSpinner true
      @spinnerText 'Opération en cours...'
      $.when(@deleteItems()).done ->
        vm.showSpinner false
        # console.log 'delete selected ' + lmids
        
    @deleteItems = ->
      # @lmids = []
      @checkedItems().forEach (e) ->
        crea = e.obj
        console.log "state " + crea.state()
        if crea.state() != 'deleted'
          # crea.processing('danger')
          crea.deleteItem()
          # $.when(crea.delete()).done(console.log('done!!!!'))
      

vm = new CreationsList


if not window.location.href.toString().match '/user/login'
  vm.loadData()


ko.applyBindings vm

console.log window.location.href.toString()
