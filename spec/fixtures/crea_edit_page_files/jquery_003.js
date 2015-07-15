;
(function ($) {
    var defaultOptions = {
        'classlink': 'menu_hover'
    };
    var div;
    var width;
    var overflow;
    var opt;
    var self;
    var content;
    var fleche;
    var style1;
    var style2;
    var startDelay = 250;
    var hideDelay = 500;
    var currentID;
    var hideTimer = null;
    var hideshowTimer = null;
    var display = false;

    $.fn.pop = function (options) {
        opt = $.extend({}, defaultOptions, options);


        return this.each(function () {
            self = $(this);

            $.fn.pop.init();
        });

    };

    $.fn.extend({
        findPos: function () {
            obj = jQuery(this).get(0);
            var curleft = obj.offsetLeft || 0;
            var curtop = obj.offsetTop || 0;
            while (obj = obj.offsetParent) {
                curleft += obj.offsetLeft
                curtop += obj.offsetTop
            }
            return {
                x: curleft,
                y: curtop
            };
        }
    });

    $.fn.pop.init = function () {
        var pos;

        var popup = $(self).attr('href');


        if ($.browser.msie) {
            var width = opt.width;
            var height = opt.height;
        }
        else {
            var width = opt.width;
            var height = opt.height;
        }


        $(popup).css({
            "padding": "10px",
            "width": width,
            "height": height,
            "overflow": opt.overflow
        });


        $('.close-box').bind("click", function () {


            $(popup).css('display', 'none');


            $(popup).css('display', 'none');
            $("#backgroundPopup").css({
                "opacity": 0.5
            }).hide();

        });


        $(self).bind("click", function () {
            $('.minibox_notif').css({
                'display': 'none'
            });
            var thisA = this;
            //loadInfo(thisA);

            loadInfo(thisA);

            return false;

        });

        $("#backgroundPopup").click(function () {

            $(popup).css('display', 'none');
            $("#backgroundPopup").css({
                "opacity": 0.5
            }).hide();
        });


        function loadInfo(val) {


            pos = $(val).findPos();
            $("#backgroundPopup").css({
                "opacity": 0.1
            }).fadeIn('fast');
            $(popup).css({
                "top": pos.y,
                "left": pos.x
            }).fadeIn('fast');
        }


        return false;
    };


})(jQuery);
