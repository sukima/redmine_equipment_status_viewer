$.facebox.settings.closeImage = 'css/images/closelabel.png'
$.facebox.settings.loadingImage = 'css/images/loading.gif'


jQuery(document).ready(function() {

  jQuery('#mycarousel').jcarousel({
    wrap: "both",
    scroll: 1, 
    animation: "slow"
  });


  if ( $.browser.msie && $.browser.version.substr(0,1) == 6 ) {
    DD_belatedPNG.fix('.slider img');
  }	

  $('a[rel*=facebox]').facebox();

});
