(function ($) {
  'use strict';

  $.fn.autocomplete = function (options) {

    var $container,
      _data = [],
      self = this.filter('input');

    var settings = $.extend({
      itemClass: 'autocomplete-container-item',
      containerClass: 'autocomplete-container',
      containerID: 'container'
    }, options);

    var selectItemCallback = function () {
      self.val($(this).text());
      $container.html('');
      self.trigger('focus');
    };

    $container = $('<div/>', {
      id: settings.containerID,
      class: settings.containerClass
    });
    self.after($container);

    // Set functions for container
    this.$autocomplete = $container;
    this.$autocomplete.setData = function (data) {
      $.map(data, this.addItem);
    };

    this.$autocomplete.getData = function () {
      return _data;
    };

    this.$autocomplete.addItem = function (label, customSelectItemCallback) {
      var $row = $('<div/>', { class: settings.itemClass }).text(label);
      $container.append($row);
      $row.on('click', $.isFunction(customSelectItemCallback) ? customSelectItemCallback : selectItemCallback);
    };

    this.$autocomplete.clear = function () {
      $container.html('');
      $container.hide();
    };

    return this;
  };

})(window.jQuery);
