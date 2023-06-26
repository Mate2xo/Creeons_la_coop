initDocumentsSorting()

function initDocumentsSorting(){
  let sortingLinks = [...document.querySelectorAll('.sort-link')];

  for (let i = 0; i  < sortingLinks.length; i ++) {
    sortingLinks[i].addEventListener("click", switchLinkBetweenAscendingAndDescending);
    sortingLinks[i].addEventListener("click", chooseContentToDisplay);
    sortingLinks[i].addEventListener("click", resetOtherSortingLink);
  };
};

function switchLinkBetweenAscendingAndDescending() {
  let links = this.parentNode.childNodes;

  links[1].hidden = !links[1].hidden || false;
  links[3].hidden = !links[3].hidden || false;
};

function chooseContentToDisplay(){
  let currentLinkId = this.id;
  let currentCategory = this.dataset['category'];
  let selector = `.sort-pane[data-category=\"${currentCategory}\"]`;
  let contentToDisplay = [...document.querySelectorAll(selector)];

  for (let i = 0; i < contentToDisplay.length; i ++) {
    if(contentToDisplay[i].classList.contains(currentLinkId)){
      contentToDisplay[i].hidden = false;
    } else {
      contentToDisplay[i].hidden = true;
    };
  };
};

function resetOtherSortingLink(){
  let currentCategory = this.dataset['category'];

  if(this.classList.contains("name")){
    document.getElementById(`${currentCategory}-date-asc`).hidden = false;
    document.getElementById(`${currentCategory}-date-desc`).hidden = true;
  } else {
    document.getElementById(`${currentCategory}-name-asc`).hidden = false;
    document.getElementById(`${currentCategory}-name-desc`).hidden = true;
  };
};

