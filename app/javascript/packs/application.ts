import Rails from '@rails/ujs';
import * as Sentry from '@sentry/browser';
import 'bootstrap';

Rails.start();

Sentry.init({
  dsn: 'https://91bdb31ba8364e0c84a60f9792ae8ae4@o420086.ingest.sentry.io/5755180',
  environment: process.env.NODE_ENV,
  release: document.documentElement.dataset.release,
});
