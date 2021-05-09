import React from 'react';
import ReactDOM from 'react-dom';
import KadaiWorkCardList from 'KadaiWorkCardList';

document.addEventListener('DOMContentLoaded', () => {
  const currentUser = document.body.dataset.currentUser ? JSON.parse(document.body.dataset.currentUser) : undefined;

  const jissakuList = document.getElementById('jissaku-list');
  if (jissakuList && jissakuList.dataset.jissakusPath) {
    ReactDOM.render(
      <KadaiWorkCardList
        jsonUrl={jissakuList.dataset.jissakusPath}
        currentUser={currentUser}
        sortByGenronSf={jissakuList.dataset.sort === 'genron_sf'}
      ></KadaiWorkCardList>,
      jissakuList
    );
  }

  const kougaiList = document.getElementById('kougai-list');
  if (kougaiList && kougaiList.dataset.kougaisPath) {
    ReactDOM.render(
      <KadaiWorkCardList
        jsonUrl={kougaiList.dataset.kougaisPath}
        currentUser={currentUser}
        sortByGenronSf={kougaiList.dataset.sort === 'genron_sf'}
      ></KadaiWorkCardList>,
      kougaiList
    );
  }
});
