function Slideshow(slidesContainer) {
  this.slidesContainer = slidesContainer;
};

Slideshow.prototype.initialize = function() {
  this.start();
};

Slideshow.prototype.start = function() {
  this.continueSlideshow(0);
};

Slideshow.prototype.continueSlideshow = function(index) {
   var _this = this;
   this.slides = $("#slide").find("img")
  this.slides.eq(index).fadeIn(1000).fadeOut(1000, function() {
    _this.continueSlideshow(_this.selectIndex(index));
  });
};

Slideshow.prototype.selectIndex = function(index) {
  var nextIndex = index + 1;
  if (nextIndex >= this.slides.length) {
    nextIndex = 0;
  }
  return nextIndex;
};

$(function() {
  var slidesContainer = $("body"),
    slideshow = new Slideshow(slidesContainer);
  slideshow.initialize();
});
