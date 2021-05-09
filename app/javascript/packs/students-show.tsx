import React from 'react';
import ReactDOM from 'react-dom';
import StudentWorkCardList from 'StudentWorkCardList';

document.addEventListener('DOMContentLoaded', () => {
  const currentUser = document.body.dataset.currentUser ? JSON.parse(document.body.dataset.currentUser) : undefined;

  const jissakuList = document.getElementById('jissaku-list');
  if (jissakuList && jissakuList.dataset.jissakusPath) {
    ReactDOM.render(
      <StudentWorkCardList jsonUrl={jissakuList.dataset.jissakusPath} currentUser={currentUser}></StudentWorkCardList>,
      jissakuList
    );
  }

  const kougaiList = document.getElementById('kougai-list');
  if (kougaiList && kougaiList.dataset.kougaisPath) {
    ReactDOM.render(
      <StudentWorkCardList jsonUrl={kougaiList.dataset.kougaisPath} currentUser={currentUser}></StudentWorkCardList>,
      kougaiList
    );
  }
});
