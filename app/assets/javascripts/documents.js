console.log("ready");
function sortContent(){
  let sortingLinks = [...document.querySelectorAll('.sort-link')];

  for (let i = 0; i  < sortingLinks.length; i ++) {
    sortingLinks[i].addEventListener("click", switchLinkBetweenAscendingAndDescending);
    sortingLinks[i].addEventListener("click", chooseContentToDisplay);
    sortingLinks[i].addEventListener("click", resetOtherLink);
  };
};

function switchLinkBetweenAscendingAndDescending() {
  let links = [...this.parentNode.childNodes];

  links[1].hidden = !links[1].hidden || false;
  links[3].hidden = !links[3].hidden || false;
};

function chooseContentToDisplay(){
  let currentLinkId = this.id;
  let currentCategory = this.dataset['category'];
  let selector = '.sort-pane[data-category="' + currentCategory + '"]';
  let content = [...document.querySelectorAll(selector)];

  for (let i = 0; i < content.length; i ++) {
    if(content[i].classList.contains(currentLinkId)){
      content[i].hidden = false;
    } else {
      content[i].hidden = true;
    };
  };
};

function resetOtherLink(){
  let currentCategory = this.dataset['category'];

  if(this.classList.contains("name")){
    document.getElementById(currentCategory.split("_").join("-") + "-date-asc").hidden =false;
    document.getElementById(currentCategory.split("_").join("-") + "-date-desc").hidden =true;
  } else {
    document.getElementById(currentCategory.split("_").join("-") + "-name-asc").hidden =false;
    document.getElementById(currentCategory.split("_").join("-") + "-name-desc").hidden =true;
  };
};

sortContent()
