import React from 'react';
import { createRoot } from 'react-dom/client';
import StudentWorkCardList from './components/StudentWorkCardList';

document.addEventListener('DOMContentLoaded', () => {
  const currentUser = document.body.dataset.currentUser ? JSON.parse(document.body.dataset.currentUser) : undefined;

  const jissakuList = document.getElementById('jissaku-list');
  if (jissakuList && jissakuList.dataset.jissakusPath) {
    const root = createRoot(jissakuList);
    root.render(
      <StudentWorkCardList jsonUrl={jissakuList.dataset.jissakusPath} currentUser={currentUser}></StudentWorkCardList>
    );
  }

  const kougaiList = document.getElementById('kougai-list');
  if (kougaiList && kougaiList.dataset.kougaisPath) {
    const root = createRoot(kougaiList);
    root.render(
      <StudentWorkCardList jsonUrl={kougaiList.dataset.kougaisPath} currentUser={currentUser}></StudentWorkCardList>
    );
  }
});
