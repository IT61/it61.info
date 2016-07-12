function handleFileUpload() {
  var wrapper = $( ".file_upload" ),
      inp = wrapper.find( "input" ),
      btn = wrapper.find( "button" ),
      lbl = wrapper.find( "label" );

  btn.focus(function(){
      inp.focus()
  });
  // Crutches for the :focus style:
  inp.focus(function(){
      wrapper.addClass( "focus" );
  }).blur(function(){
      wrapper.removeClass( "focus" );
  });

  var file_api = ( window.File && window.FileReader && window.FileList && window.Blob ) ? true : false;

  inp.change(function(){
      var file_name;
      if( file_api && inp[ 0 ].files[ 0 ] )
          file_name = inp[ 0 ].files[ 0 ].name;
      else
          file_name = inp.val().replace( "C:\\fakepath\\", '' );

      if( ! file_name.length )
          return;

      if( lbl.is( ":visible" ) ){
          lbl.text( file_name );
          btn.text( "Выбрать файл" );
      } else
          btn.text( file_name );
  }).change();

  $( window ).resize(function(){
    $( ".file_upload input" ).triggerHandler( "change" );
  });
}

function fileReaderSupported() {
  return window.File && window.FileReader && window.FileList && window.Blob
}

function showImageOnLoad() {
  if (!document.getElementById('event_title_image')) {
    return;
  }
  
  document.getElementById('event_title_image').onchange = function () {
    var reader = new FileReader();
    reader.onload = function (e) {
      document.getElementById('image').src = e.target.result;
    };
    if (this.files.length !== 0) {
      reader.readAsDataURL(this.files[0]);
    }
  };
}

$(document).ready(function () {
    var editor = new SimpleMDE({
        element: document.getElementById("editor"),
        autofocus: true,
        forceSync: true
    });

    $('form').bind('submit', function () {
        $(this).find(':input').prop('disabled', false);
    });

    if (fileReaderSupported()) {
        showImageOnLoad();
    }
    handleFileUpload();
});
