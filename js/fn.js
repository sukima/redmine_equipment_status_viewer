$.facebox.settings.closeImage = 'css/images/closelabel.png'
$.facebox.settings.loadingImage = 'css/images/loading.gif'


function mycarousel_initCallback(carousel)
{
    // Disable autoscrolling if the user clicks the prev or next button.
    carousel.buttonNext.bind('click', function() {
        carousel.startAuto(0);
    });

    carousel.buttonPrev.bind('click', function() {
        carousel.startAuto(0);
    });

    // Pause autoscrolling if the user moves with the cursor over the clip.
    carousel.clip.hover(function() {
        carousel.stopAuto();
    }, function() {
        carousel.startAuto();
    });
};


jQuery(document).ready(function() {

  jQuery('#mycarousel').jcarousel({
    wrap: "both",
    auto: 10,
    scroll: 1, 
    initCallback: mycarousel_initCallback,
    animation: "slow"
  });


  if ( $.browser.msie && $.browser.version.substr(0,1) == 6 ) {
    DD_belatedPNG.fix('.slider img');
  }	

  $('a[rel*=facebox]').facebox();

});
