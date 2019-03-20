(function (window, $) {

  var Sidebar = function (target, options) {
    this.$sidebar = $(target);
    this.$body = $(document.body);
    this.options = options;

    this.init();
  };

  Sidebar.prototype = {
    defaults: {
      trigger: null,
      content: '.content'
    },
    init: function () {
      this.config = $.extend({}, this.defaults, this.options);
      this.$content = $(this.config.content);
      this.$trigger = $(this.config.trigger) || this.$body.find(this.config.trigger);

      this.attach();
    },
    attach: function () {
      this.$trigger.on('click', this.onShow.bind(this));
      this.$content.on('click', this.onHide.bind(this));
    },
    onShow: function (e) {
      e.stopPropagation();
      this.slideIn();
    },
    onHide: function (e) {
      if (this.$sidebar.hasClass('sidebar-opened')) {
        e.stopPropagation();
        this.slideOut();
      }
    },
    slideIn: function () {
      this.$sidebar.addClass('sidebar-opened');
      this.$sidebar.css({'animation': 'slidein .2s ease-in-out'});
    },
    slideOut: function () {
      this.$sidebar.css({'animation': 'slideout .2s ease-in-out'});
      this.$sidebar.removeClass('sidebar-opened');
    }
  };

  $.fn.sidebar = function (options) {
    return this.each(function () {
      $(this).data('sidebar', new Sidebar(this, options));
    });
  };

})(window, window.jQuery);