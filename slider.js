const slider = document.querySelector("#slider");
let sliderSection = document.querySelectorAll(".slider__section");
let sliderSectionLast = sliderSection[sliderSection.length - 1];

const btnLeft = document.querySelector("#btn-left");
const btnRight = document.querySelector("#btn-right");

slider.insertAdjacentElement("afterbegin", sliderSectionLast);

function moveRight() {
    let sliderSectionFirst = document.querySelectorAll(".slider__section")[0];
    slider.style.margingLeft = "-200%";
    slider.style.transition = "all 1s";
    setTimeout(function () {
        slider.style.transition = "none";
        slider.insertAdjacentElement('beforeend', sliderSectionFirst);
        slider.style.margingLeft = "-100%";
    }, 500);
}

function moveLeft() {
    let sliderSection = document.querySelectorAll(".slider__section");
    let sliderSectionLast = sliderSection[sliderSection.length - 1];
    slider.style.margingLeft = "0";
    slider.style.transition = "all 1s";
    setTimeout(function () {
        slider.style.transition = "none";
        slider.insertAdjacentElement('afterbegin', sliderSectionLast);
        slider.style.margingLeft = "-100%";
    }, 500);
}

btnRight.addEventListener('click', function () {
    moveRight();
});

btnLeft.addEventListener('click', function () {
    moveLeft();
});

setInterval(function () {
    moveRight();
}, 4000);