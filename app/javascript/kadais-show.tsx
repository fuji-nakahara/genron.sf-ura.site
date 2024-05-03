import React from 'react';
import { createRoot } from 'react-dom/client';
import KadaiWorkCardList from './components/KadaiWorkCardList';

document.addEventListener('DOMContentLoaded', () => {
  const currentUser = document.body.dataset.currentUser ? JSON.parse(document.body.dataset.currentUser) : undefined;

  const jissakuList = document.getElementById('jissaku-list');
  if (jissakuList && jissakuList.dataset.jissakusPath) {
    const root = createRoot(jissakuList);
    root.render(
      <KadaiWorkCardList
        jsonUrl={jissakuList.dataset.jissakusPath}
        defaultSortingMethod={jissakuList.dataset.sort || 'default'}
        currentUser={currentUser}
      ></KadaiWorkCardList>
    );
  }

  const kougaiList = document.getElementById('kougai-list');
  if (kougaiList && kougaiList.dataset.kougaisPath) {
    const root = createRoot(kougaiList);
    root.render(
      <KadaiWorkCardList
        jsonUrl={kougaiList.dataset.kougaisPath}
        defaultSortingMethod={kougaiList.dataset.sort || 'default'}
        currentUser={currentUser}
      ></KadaiWorkCardList>
    );
  }
});
