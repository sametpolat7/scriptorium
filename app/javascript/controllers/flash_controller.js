import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.autoCloseTimer = setTimeout(() => {
      this.close();
    }, 3000);
  }

  disconnect() {
    clearTimeout(this.autoCloseTimer);
  }

  close(event) {
    if (event) {
      clearTimeout(this.autoCloseTimer);
    }
    this.element.remove();
  }
}
