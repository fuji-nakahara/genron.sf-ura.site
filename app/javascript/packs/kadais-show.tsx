import React from 'react';
import ReactDOM from 'react-dom';
import WorkCardList from 'WorkCardList';

document.addEventListener('DOMContentLoaded', () => {
  const currentUser = document.body.dataset.currentUser ? JSON.parse(document.body.dataset.currentUser) : undefined;

  const jissakuList = document.getElementById('jissaku-list');
  if (jissakuList && jissakuList.dataset.jissakusPath) {
    ReactDOM.render(
      <WorkCardList jsonUrl={jissakuList.dataset.jissakusPath} currentUser={currentUser}></WorkCardList>,
      jissakuList
    );
  }

  const kougaiList = document.getElementById('kougai-list');
  if (kougaiList && kougaiList.dataset.kougaisPath) {
    ReactDOM.render(
      <WorkCardList jsonUrl={kougaiList.dataset.kougaisPath} currentUser={currentUser}></WorkCardList>,
      kougaiList
    );
  }
});
