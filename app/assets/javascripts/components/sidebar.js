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
      this.distance = this.$sidebar.width();

      this.attach();
    },
    attach: function () {
      this.$trigger.on('click', $.proxy(function (e) {
        e.preventDefault();
        this.slideIn();
      }, this));

      this.$content.on('click', $.proxy(function (e) {
        if (this.$sidebar.hasClass('sidebar-opened')) {
          e.preventDefault();
          this.slideOut();
        }
      }, this));
    },
    slideIn: function () {
      this.$sidebar
        .animate({marginLeft: 0})
        .promise()
        .done($.proxy(function () {
          this.$sidebar.addClass('sidebar-opened');
        }, this));
    },
    slideOut: function () {
      this.$sidebar
        .animate({marginLeft: -this.distance})
        .promise()
        .done($.proxy(function () {
          this.$sidebar.removeClass('sidebar-opened');
        }, this));
    }
  };

  $.fn.sidebar = function (options) {
    return this.each(function () {
      $(this).data('sidebar', new Sidebar(this, options));
    });
  };

})(window, window.jQuery);