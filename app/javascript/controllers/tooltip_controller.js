import { Controller } from 'stimulus';
import { Tooltip } from 'bootstrap';

export default class extends Controller {
  connect() {
    new Tooltip(this.element);
  }
}
